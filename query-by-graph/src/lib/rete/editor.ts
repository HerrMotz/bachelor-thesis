import {ClassicPreset, GetSchemes, NodeEditor} from "rete";
import {Area2D, AreaExtensions, AreaPlugin} from "rete-area-plugin";
import {ConnectionPlugin, Presets as ConnectionPresets} from "rete-connection-plugin";
import {ConnectionPathPlugin} from "rete-connection-path-plugin";
import {HistoryExtensions, HistoryPlugin, Presets as HistoryPresets} from "rete-history-plugin";
import {Presets, VueArea2D, VuePlugin} from "rete-vue-plugin";
import {h} from "vue";
import CustomConnection from "../../components/PropertyConnection.vue";
import {removeNodeWithConnections} from "./utils.ts";
import EntityType from "../types/EntityType.ts";
import ConnectionInterfaceType from "../types/ConnectionInterfaceType.ts";
import EntityNodeComponent from "../../components/EntityNode.vue";
import CustomInputControl from "../../components/EntitySelectorInputControl.vue";
import {noEntity, variableEntityConstructor, literalEntityConstructor} from "./constants.ts";
import {noDataSource} from "../constants";
import { counter } from "../utils/counter.ts";

// Each connection holds additional data, which is defined here
class Connection extends ClassicPreset.Connection<
    ClassicPreset.Node,
    ClassicPreset.Node
> {
    selected?: boolean;
    property?: EntityType;
}

// Each node has to have "entity" metadata.
// This is ensured here.
class EntityNodeClass extends ClassicPreset.Node {
    entity: EntityType;

    constructor(public label: string, public e: EntityType) {
        super(label);
        this.entity = e;
        console.log('EntityNodeClass constructor', this.entity);
    }

    setEntity(entity: EntityType) {
        console.log('setter called');
        this.entity = entity;
    }

    getEntity() {
        return this.entity;
    }
}

declare type InputControlOptions<N> = {
    /** Whether the control is readonly. Default is `false` */
    readonly?: boolean;
    /** Initial value of the control */
    initial?: N;
    /** Callback function that is called when the control value changes */
    change?: (value: N) => void;
};

class EntitySelectorInputControl extends ClassicPreset.InputControl<"text", EntityType> {
    constructor(public options: InputControlOptions<EntityType> & { isLiteral?: boolean }) {
    super("text", options);
  }

}

type Schemes = GetSchemes<EntityNodeClass, Connection>;
type AreaExtra = VueArea2D<Schemes>;

export async function createEditor(container: HTMLElement) {
    const socket = new ClassicPreset.Socket("socket");

    const editor = new NodeEditor<Schemes>();
    const area = new AreaPlugin<Schemes, AreaExtra>(container);
    const connection = new ConnectionPlugin<Schemes, AreaExtra>();
    const render = new VuePlugin<Schemes, AreaExtra>();
    const selector = AreaExtensions.selector();
    const accumulating = AreaExtensions.accumulateOnCtrl();
    const history = new HistoryPlugin<Schemes>();

    let vueCallback: (context: any) => void;
    let increaseVariablePropCounter = false;

    HistoryExtensions.keyboard(history);

    history.addPreset(HistoryPresets.classic.setup());

    function SelectableConnectionBind(props: { data: Schemes["Connection"] }) {
        const id = props.data.id;

        if (increaseVariablePropCounter) {
            increaseVariablePropCounter = false;
            counter.next();
        }

        if (!props.data.property) {
            props.data.property = variableEntityConstructor(counter.getCurrent().toString())
        }

        const label = "connection";

        // Initialize the custom connection with the custom props
        // and connect it to our editor events
        return h(CustomConnection, {
            ...props, onClick: () => {
                // DEBUG
                // console.log("Selected connection", id)
                selector.add(
                    {
                        id,
                        label,
                        translate() {
                        },
                        unselect() {
                            props.data.selected = false;
                            area.update("connection", id);
                        }
                    },
                    accumulating.active()
                );
                props.data.selected = true;
                area.update("connection", id);
            },
            onChangedEntitySelector: (value: EntityType) => {
                // in order to force the editor to notice the change,
                // I need to create a copy of the connection,
                // change the entity and add it back.
                props.data.property = value;
                editor.getConnections().forEach((c) => {
                    area.update("connection", c.id)
                })
            }
        });
    }

    AreaExtensions.selectableNodes(area, selector, {
        accumulating: accumulating
    });

    render.addPreset(Presets.classic.setup({
        customize: {
            control(data) {
                // DEBUG
                // console.log("Control payload")
                // console.log(data.payload);
                if (data.payload instanceof EntitySelectorInputControl) {
                    return CustomInputControl;
                }
            },
            node(_) {
                // DEBUG
                // console.log("Node payload")
                // console.log(data.payload);
                return EntityNodeComponent;
            },
            connection() {
                return SelectableConnectionBind;
            }
        }
    }));

    const pathPlugin = new ConnectionPathPlugin<Schemes, Area2D<Schemes>>({
        arrow: () => true
    });

    // @ts-ignore
    render.use(pathPlugin);

    connection.addPreset(ConnectionPresets.classic.setup());

    area.addPipe(async (context) => {
        // this is a workaround to hinder the counter from increasing at every
        // draw method of the editor
        if (context.type === "pointerdown") { // Left click
            const event = context.data.event;

            if(event.button===0)
            {
                console.log("Leftclick");
                console.log("Root");
                event.preventDefault();
                event.stopPropagation();
                
                const nextId = counter.getNext();
                const newLiteral = literalEntityConstructor(
                    nextId.toString()
                )

                const node = new EntityNodeClass(newLiteral.label, newLiteral);
                
                console.log("LiteralNodeId:", node.id);
                console.log("EntityType: ", node.entity.isLiteral);
                
                node.addControl(
                    "entityInput",
                    new EntitySelectorInputControl({
                        initial: newLiteral,
                        isLiteral: true,
                        change(value) {
                            node.setEntity(value);
                            editor.getConnections().forEach((c) => {
                                area.update("connection", c.id)
                            });
                            area.update("node", node.id);
                        }
                    })
                );
                node.addInput("i0", new ClassicPreset.Input(socket, "", true));
                node.addOutput("o0", new ClassicPreset.Output(socket, "", true));
    
                await editor.addNode(node);
                area.area.setPointerFrom(event);
                await area.translate(node.id, area.area.pointer);
            }
        }
        
        
        if (context.type === "connectioncreated") {
            increaseVariablePropCounter = true;
        }

        // This matches a Right Mouse button Click
        if (context.type === "contextmenu") {
            const source = context.data.context;
            const event = context.data.event;
            event.preventDefault();
            event.stopPropagation();

            // This method allows to add a new node with the Right Mouse Button click
            if (source === "root") { // add a new node
                // DEBUG
                console.log("Add variable node")

                const nextId = counter.getNext();

                const newEntity = variableEntityConstructor(
                    nextId.toString()
                )

                const node = new EntityNodeClass(newEntity.label, newEntity);

                // DEBUG
                // console.log("Node", node.entity);

                node.addControl(
                    "entityInput",
                    new EntitySelectorInputControl({
                        initial: {id: "", label: "", prefix: {uri: "", abbreviation: ""}, description: "", dataSource: noDataSource, isLiteral: false},
                        change(value) {
                            // DEBUG
                            // console.log("Entity Input called change")
                            // console.log(value)
                            // console.log("node entity value")
                            // console.log(node.getEntity())
                            node.setEntity(value)
                            // console.log("node value after update")
                            // console.log(node.getEntity())

                            editor.getConnections().forEach((c) => {
                                area.update("connection", c.id)
                            })

                            // console.log("update node in area")
                            area.update("node", node.id)
                        }
                    })
                );
                node.addInput("i0", new ClassicPreset.Input(socket, "", true));
                node.addOutput("o0", new ClassicPreset.Output(socket, "", true));

                await editor.addNode(node);
                area.area.setPointerFrom(event);

                await area.translate(node.id, area.area.pointer);

            } else if (source instanceof ClassicPreset.Node) { // remove existing node
                // DEBUG
                // console.log("Remove node", source.id);
                for (const c of editor
                    .getConnections()
                    .filter((c) => c.source === source.id || c.target === source.id)) {
                    await editor.removeConnection(c.id);
                }
                await editor.removeNode(source.id);
            }
        }

        if(context.type === 'nodepicked') {
            const node = context.data as ClassicPreset.Node;
            console.log(`Node clicked: ${node.id}`);

            if (vueCallback !== undefined){
                vueCallback({
                    type: 'nodeselected',
                    data: node,
                });
            }
        }

        if (vueCallback !== undefined) {
            vueCallback(context);
        }
        return context;
    });

    editor.use(area);
    area.use(connection);
    area.use(render);
    area.use(history);

    AreaExtensions.simpleNodesOrder(area);

    await AreaExtensions.zoomAt(area, editor.getNodes());

    return {
        setVueCallback: (callback: any) => {
            vueCallback = callback;
        },
        addPipe: (pipe: any) => editor.addPipe(pipe),
        removeSelectedConnections: async () => {
            // DEBUG
            // console.log("Remove selected connections")
            for (const item of [...editor.getConnections()]) {
                if (item.selected) {
                    await editor.removeConnection(item.id);
                }
            }
            for (const item of [...editor.getNodes()]) {
                if (item.selected) {
                    await removeNodeWithConnections(editor, item.id);
                }
            }
        },
        undo: () => history.undo(),
        redo: () => history.redo(),
        destroy: () => area.destroy(),
        exportConnections: (): ConnectionInterfaceType[] => {
            return editor.getConnections().map(connection => {
                const c = editor.getConnection(connection.id)
                const source = editor.getNode(c.source);
                const target = editor.getNode(c.target);
                return {
                    property: c.property || noEntity,
                    source: source.entity,
                    target: target.entity
                };
            })
        },
        getNode: (id: string) => editor.getNode(id)
    };
}
