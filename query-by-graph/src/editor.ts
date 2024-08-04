import {NodeEditor, GetSchemes, ClassicPreset} from "rete";
import {AreaPlugin, AreaExtensions, Area2D} from "rete-area-plugin";
import {
    ConnectionPlugin,
    Presets as ConnectionPresets
} from "rete-connection-plugin";
import {ConnectionPathPlugin} from "rete-connection-path-plugin";
// See https://retejs.org/examples/connection-path
import { curveStep } from "d3-shape";
import {
    HistoryExtensions,
    HistoryPlugin,
    Presets as HistoryPresets
} from "rete-history-plugin";
import {VuePlugin, Presets, VueArea2D} from "rete-vue-plugin";
import {h} from "vue";
import CustomConnection from "./components/CustomConnection.vue";
import {removeNodeWithConnections} from "./utils.ts";
import EntityType from "./types/EntityType.ts";

type Schemes = GetSchemes<
    ClassicPreset.Node,
    ClassicPreset.Connection<ClassicPreset.Node, ClassicPreset.Node>
>;
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

    HistoryExtensions.keyboard(history);

    history.addPreset(HistoryPresets.classic.setup());

    let selectedProperty: EntityType | null = null;
    let selectedIndividual: EntityType | null = null;

    function SelectableConnectionBind(props: { data: Schemes["Connection"] }) {
        const id = props.data.id;

        // TODO keep the existing properties
        //  this is a "might do" feature
        props.data.property = {
            id: selectedProperty?.id || "Nothing",
            label: selectedProperty?.label || "selected"
        }
        const label = "connection";

        // Initialize the custom connection with the custom props
        // and connect it to our editor events
        return h(CustomConnection, {
            ...props, onClick: () => {
                console.log("Selected connection", id)
                selector.add(
                    {
                        id,
                        label,
                        translate() {},
                        unselect() {
                            props.data.selected = false;
                            area.update("connection", id);
                        }
                    },
                    accumulating.active()
                );
                props.data.selected = true;
                area.update("connection", id);
            }
        });
    }

    AreaExtensions.selectableNodes(area, selector, {
        accumulating: accumulating
    });

    render.addPreset(Presets.classic.setup({
        customize: {
            connection() {
                return SelectableConnectionBind;
            }
        }
    }));

    const pathPlugin = new ConnectionPathPlugin<Schemes, Area2D<Schemes>>({
        curve: (c) => c.curve || curveStep,
        // transformer: () => Transformers.classic({ vertical: false }),
        arrow: () => true
    });

    // @ts-ignore
    render.use(pathPlugin);

    connection.addPreset(ConnectionPresets.classic.setup());

    area.addPipe(async (context) => {
        if (context.type === "contextmenu") {
            const source = context.data.context;
            const event = context.data.event;
            event.preventDefault();
            event.stopPropagation();

            if (source === "root") {
                console.log("Add node")
                const node = new ClassicPreset.Node(selectedIndividual?.label || "Nothing");
                node.addOutput("b", new ClassicPreset.Output(socket));
                await editor.addNode(node);
                area.area.setPointerFrom(event);

                await area.translate(node.id, area.area.pointer);
            } else if (source instanceof ClassicPreset.Node) {
                console.log("Remove node", source.id);
                for (const c of editor
                    .getConnections()
                    .filter((c) => c.source === source.id || c.target === source.id)) {
                    await editor.removeConnection(c.id);
                }
                await editor.removeNode(source.id);
            }
        }

        return context;
    });

    editor.use(area);
    area.use(connection);
    area.use(render);

    AreaExtensions.simpleNodesOrder(area);

    const a = new ClassicPreset.Node("?1");
    a.addControl(
        "a",
        new ClassicPreset.InputControl("text", {initial: "hello"})
    );
    a.addOutput("a", new ClassicPreset.Output(socket));
    await editor.addNode(a);

    const b = new ClassicPreset.Node("Universität Jena, Q21880");
    b.addControl(
        "b",
        new ClassicPreset.InputControl("text", {initial: "hello"})
    );
    b.addInput("b", new ClassicPreset.Input(socket));
    await editor.addNode(b);

    await area.translate(b.id, {x: 520, y: 0});

    await editor.addConnection(new ClassicPreset.Connection(a, "a", b, "b"));

    AreaExtensions.zoomAt(area, editor.getNodes());

    return {
        removeSelectedConnection: async () => {
            console.log("TEST")
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
            selectedIndividual = individual
        },
        destroy: () => area.destroy()
    };
}
