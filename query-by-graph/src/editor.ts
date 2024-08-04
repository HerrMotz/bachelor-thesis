import { NodeEditor, GetSchemes, ClassicPreset } from "rete";
import { AreaPlugin, AreaExtensions } from "rete-area-plugin";
import {
    ConnectionPlugin,
    Presets as ConnectionPresets
} from "rete-connection-plugin";
import { VuePlugin, Presets, VueArea2D } from "rete-vue-plugin";
import CustomConnection from "./components/CustomConnection.vue";

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

    AreaExtensions.selectableNodes(area, AreaExtensions.selector(), {
        accumulating: AreaExtensions.accumulateOnCtrl()
    });

    render.addPreset(Presets.classic.setup({
        customize: {
            connection() {
                return CustomConnection;
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
        new ClassicPreset.InputControl("text", { initial: "hello" })
    );
    a.addOutput("a", new ClassicPreset.Output(socket));
    await editor.addNode(a);

    const b = new ClassicPreset.Node("Uni Jena, Q21880");
    b.addControl(
        "b",
        new ClassicPreset.InputControl("text", { initial: "hello" })
    );
    b.addInput("b", new ClassicPreset.Input(socket));
    await editor.addNode(b);

    await area.translate(b.id, { x: 520, y: 0 });

    await editor.addConnection(new ClassicPreset.Connection(a, "a", b, "b"));

    AreaExtensions.zoomAt(area, editor.getNodes());

    return () => area.destroy();
}
