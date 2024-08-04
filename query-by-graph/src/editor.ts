import {NodeEditor, GetSchemes, ClassicPreset} from "rete";
import {AreaPlugin, AreaExtensions} from "rete-area-plugin";
import {
    ConnectionPlugin,
    Presets as ConnectionPresets
} from "rete-connection-plugin";
import {VuePlugin, Presets, VueArea2D} from "rete-vue-plugin";
import {h} from "vue";
import CustomConnection from "./components/CustomConnection.vue";
import {removeNodeWithConnections} from "./utils.ts";

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

    function SelectableConnectionBind(props: { data: Schemes["Connection"] }) {
        const id = props.data.id;
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

    connection.addPreset(ConnectionPresets.classic.setup());

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

    const b = new ClassicPreset.Node("Uni Jena, Q21880");
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
        removeSelected: async () => {
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
        destroy: () => area.destroy()
    };
}
