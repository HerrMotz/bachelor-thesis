import {NodeEditor, GetSchemes, ClassicPreset} from "rete";
import {AreaPlugin, AreaExtensions, Area2D} from "rete-area-plugin";
import {
    ConnectionPlugin,
    Presets as ConnectionPresets
} from "rete-connection-plugin";
import {ConnectionPathPlugin} from "rete-connection-path-plugin";
import {
    HistoryExtensions,
    HistoryPlugin,
    Presets as HistoryPresets
} from "rete-history-plugin";
import {VuePlugin, Presets, VueArea2D} from "rete-vue-plugin";
import {h} from "vue";
import CustomConnection from "../../components/PropertyConnection.vue";
import {removeNodeWithConnections} from "./utils.ts";
import EntityType from "../types/EntityType.ts";
import ConnectionInterfaceType from "../types/ConnectionInterfaceType.ts";
import EntityNodeComponent from "../../components/EntityNode.vue";
import CustomInputControl from "../../components/EntitySelectorInputControl.vue";
import {noEntity} from "./constants.ts";

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
  constructor(public options: InputControlOptions<EntityType>) {
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
    let highestIdCount = 0;
    let increaseVariablePropCounter = false;

    HistoryExtensions.keyboard(history);

    history.addPreset(HistoryPresets.classic.setup());

    let selectedProperty: EntityType = {
        id: "?1",
        label: "Variable",
        description: "",
        prefix: {
            uri: "",
            abbreviation: "",
        },
    };
    let selectedIndividual: EntityType = {
        id: "?1",
        label: "Variable",
        description: "",
        prefix: {
            uri: "",
            abbreviation: "",
        },
    };

    function SelectableConnectionBind(props: { data: Schemes["Connection"] }) {
        const id = props.data.id;

        // props.data.property = selectedProperty;
        // if (increaseVariablePropCounter) {
        //     increaseVariablePropCounter = false;
        //     if (selectedProperty?.id.startsWith("?")) {
        //         highestIdCount += 1;
        //         props.data.property.id = "?" + highestIdCount;
        //     }
        // }

        // TODO write a function that goes through all variables
        //  and makes it a continuous list
        // e.g. ?1, ?5, ?6 -> ?1, ?2, ?3

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
            onChanged: (value: EntityType) => {
                console.log("sprungmarke Prop changed in EDITOR.TS")
                props.data.property = value;
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


    // this is called when something in the editor happens.
    // you can get a list of event keywords here: https://rete.readthedocs.io/en/latest/Events/
    area.addPipe(async (context) => {
        // this is a workaround to hinder the counter from increasing at every
        // draw method of the editor
        if (context.type === "connectioncreated") {
            increaseVariablePropCounter = true;
        }

        // This matches a Right Mouse button Click
        if (context.type === "contextmenu") {
            const source = context.data.context;
            const event = context.data.event;
            event.preventDefault();
            event.stopPropagation();

            // This methods allows to add a new node with the Right Mouse Button click
            if (source === "root") { // add a new node
                // DEBUG
                // console.log("Add node")

                let displayLabel: string; // this is the label the node will get in the visual editor
                // let isVariableNode = false;

                // check if it is a variable individual
                // if so, find the highest variable id, increment it by one and assign
                // it to the "to be created"-node
                if (selectedIndividual?.id.startsWith("?")) {
                    highestIdCount += 1;
                    // hacky way to make the node instantiation in line (+19) use the correct label, id
                    selectedIndividual.id = "?" + highestIdCount;
                    displayLabel = selectedIndividual.id;
                    // isVariableNode = true;

                } else {
                    displayLabel = (selectedIndividual?.id || "No ID") + ", " + (selectedIndividual?.label || "No Label")
                    const exists = editor.getNodes().find(n => n.label === displayLabel);

                    if (exists) {
                        // DEBUG
                        // console.log("Node already exists", exists.id);
                        alert("This individual already exists. Please reuse the existing individual.");
                        return context;
                    }
                }

                // at this point selectedIndividual.{id,label} contain the correct information
                // but a variable node should have a label with only "?" and the
                // input control should hold the text after the "?"

                const node = new EntityNodeClass(displayLabel, selectedIndividual);

                // DEBUG
                // console.log("Node", node.entity);

                node.addControl(
                    "entityInput",
                    new EntitySelectorInputControl({
                        initial: {id: "", label: "", prefix: {uri: "", abbreviation: ""}, description: ""},
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

            if(vueCallback){
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
        setSelectedProperty: (property: EntityType) => {
            selectedProperty = property
        },
        setSelectedIndividual: (individual: EntityType) => {
            selectedIndividual = individual;
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
