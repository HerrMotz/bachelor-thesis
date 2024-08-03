<template>
  <div style="visibility: hidden">
    <span class="label link node new-link"></span>
  </div>
  <PropertySelection @selected-property="setSelectedProperty" />
  <div ref="graphContainer" class="graph-container" style="border: 2pt solid black"></div>
  LOL {{selectedProperty}}

  <button @click="moveNodesAround">Randomise node position</button>
</template>

<script>
import * as d3 from "d3";
import PropertySelection from "./PropertySelection.vue";

export default {
  name: "NetworkVisualiser",
  components: {PropertySelection},
  data() {
    return {
      width: 800,
      height: 600,
      nodes: [
        { id: 1, label: "?1" },
        { id: 2, label: "Q21880" },
        { id: 3, label: "?3" },
        { id: 4, label: "?4" },
      ],
      links: [
        { source: 1, target: 2, label: "P160" },
        { source: 1, target: 3, label: "P141" },
        { source: 3, target: 4, label: "P160" },
      ],
      newLink: null,
      startNode: null,
      nodeRadius: 30, // Radius of the nodes
      multipleOfNodeRadius: 40,
      stroke: 5,
      selectedProperty: null,
    };
  },
  mounted() {
    this.createForceGraph();
  },
  methods: {
    moveNodesAround() {
      this.nodes.forEach((node) => {
        node.x = this.width / 2 + (Math.random() - 0.5) * 100;
        node.y = this.height / 2 + (Math.random() - 0.5) * 100;
      });
      this.updateGraph();
    },

    setSelectedProperty(value) {
      console.log(value)
      this.selectedProperty = value;
    },

    addNewConnection(d1, d2) {
      console.log("add new connection between", d1, "and", d2);
      this.links.push({source: d1.id, target: d2.id, label: this.selectedProperty.label});
      this.updateGraph();
    },

    removeConnection(sourceId, targetId) {
      console.log("remove connection between", sourceId, "and", targetId);
      this.links = this.links.filter(
          (link) =>
              !(link.source.id === sourceId && link.target.id === targetId) &&
              !(link.source.id === targetId && link.target.id === sourceId)
      );
      this.updateGraph();
    },

    createForceGraph() {
      const svg = d3
          .select(this.$refs.graphContainer)
          .append("svg")
          .attr("width", this.width)
          .attr("height", this.height);

      // Initialize node positions
      this.nodes.forEach((node) => {
        node.x = this.width / 2 + (Math.random() - 0.5) * 100;
        node.y = this.height / 2 + (Math.random() - 0.5) * 100;
      });

      const simulation = d3
          .forceSimulation(this.nodes)
          .force(
              "link",
              d3.forceLink(this.links).id((d) => d.id).distance(300)
          )
          .force("charge", d3.forceManyBody().strength(-100))
          .force("center", d3.forceCenter(this.width / 2, this.height / 2));

      let link = svg
          .selectAll(".link")
          .data(this.links)
          .enter()
          .append("line")
          .attr("class", "link")
          .attr("stroke", "#999")
          .attr("stroke-width", this.stroke)
          .on("click", (event, d) => {
            this.removeConnection(d.source.id, d.target.id);
          })
          .on("mouseover", function (event, d) {
            d3.select(this).attr("stroke", "red");
          })
          .on("mouseout", function (event, d) {
            d3.select(this).attr("stroke", "#999");
          });

      let linkLabel = svg
          .selectAll(".link-label")
          .data(this.links)
          .enter()
          .append("text")
          .attr("class", "link-label")
          .attr("dy", -5)
          .attr("text-anchor", "middle")
          .text((d) => d.label);

      let node = svg
          .selectAll(".node")
          .data(this.nodes)
          .enter()
          .append("circle")
          .attr("class", "node")
          .attr("r", this.nodeRadius)
          .attr("fill", "#69b3a2")
          .call(
              d3
                  .drag()
                  .on("start", dragstarted)
                  .on("drag", dragged)
                  .on("end", dragended)
          );

      let label = svg
          .selectAll(".label")
          .data(this.nodes)
          .enter()
          .append("text")
          .attr("class", "label")
          .attr("dy", 5)
          .attr("text-anchor", "middle")
          .text((d) => d.label);

      simulation.on("tick", () => {
        link
            .attr("x1", (d) => d.source.x)
            .attr("y1", (d) => d.source.y)
            .attr("x2", (d) => d.target.x)
            .attr("y2", (d) => d.target.y);

        linkLabel
            .attr("x", (d) => (d.source.x + d.target.x) / 2)
            .attr("y", (d) => (d.source.y + d.target.y) / 2);

        node
            .attr("cx", (d) => {
              // Constrain the node positions within the boundaries
              d.x = Math.max(
                  this.multipleOfNodeRadius,
                  Math.min(this.width - this.nodeRadius, d.x)
              );
              return d.x;
            })
            .attr("cy", (d) => {
              d.y = Math.max(
                  this.multipleOfNodeRadius,
                  Math.min(this.height - this.nodeRadius, d.y)
              );
              return d.y;
            });

        label.attr("x", (d) => d.x).attr("y", (d) => d.y);
      });

      const vm = this;

      function dragstarted(event, d) {
        // Remember the start node
        vm.startNode = d;
        // Start drawing a line
        vm.newLink = svg
            .append("line")
            .attr("class", "new-link")
            .attr("stroke", "#999")
            .attr("stroke-width", this.stroke)
            .attr("x1", d.x)
            .attr("y1", d.y)
            .attr("x2", d.x)
            .attr("y2", d.y);
      }

      function dragged(event, d) {
        // Redraw the line to the current position
        if (vm.newLink) {
          vm.newLink.attr("x2", event.x).attr("y2", event.y);
        }
      }

      function dragended(event, d) {
        // Check if the drag ends within a node radius of another node
        const targetNode = vm.nodes.find(
            (node) =>
                node !== vm.startNode &&
                Math.abs(node.x - event.x) <= vm.nodeRadius &&
                Math.abs(node.y - event.y) <= vm.nodeRadius
        );

        if (targetNode) {
          vm.addNewConnection(vm.startNode, targetNode);
        }
        // Delete the temporary line
        if (vm.newLink) {
          vm.newLink.remove();
          vm.newLink = null;
        }
        vm.startNode = null;
      }

      this.updateGraph = function () {
        link = link.data(this.links, (d) => `${d.source.id}-${d.target.id}`);
        link.exit().remove();

        link = link
            .enter()
            .append("line")
            .attr("class", "link")
            .attr("stroke", "#999")
            .attr("stroke-width", this.stroke)
            .merge(link)
            .on("click", (event, d) => {
              this.removeConnection(d.source.id, d.target.id);
            })
            .on("mouseover", function (event, d) {
              d3.select(this).attr("stroke", "red");
            })
            .on("mouseout", function (event, d) {
              d3.select(this).attr("stroke", "#999");
            });

        linkLabel = linkLabel.data(this.links, (d) => `${d.source.id}-${d.target.id}`);
        linkLabel.exit().remove();

        linkLabel = linkLabel
            .enter()
            .append("text")
            .attr("class", "link-label")
            .attr("dy", -5)
            .attr("text-anchor", "middle")
            .merge(linkLabel)
            .text((d) => d.label);

        node = node.data(this.nodes, (d) => d.id);
        node.exit().remove();

        node = node
            .enter()
            .append("circle")
            .attr("class", "node")
            .attr("r", this.nodeRadius)
            .attr("fill", "#69b3a2")
            .merge(node)
            .call(
                d3
                    .drag()
                    .on("start", dragstarted)
                    .on("drag", dragged)
                    .on("end", dragended)
            );

        label = label.data(this.nodes, (d) => d.id);
        label.exit().remove();

        label = label
            .enter()
            .append("text")
            .attr("class", "label")
            .attr("dy", -10)
            .attr("text-anchor", "middle")
            .merge(label)
            .text((d) => d.label);

        simulation.nodes(this.nodes);
        simulation.force("link").links(this.links);
        simulation.alpha(1).restart();
      };
    },
  },
};
</script>

<style scoped>
.graph-container {
  display: flex;
  justify-content: center;
  align-items: center;
}

.node {
  cursor: pointer;
  stroke: #fff;
  stroke-width: 5px;
}

.link {
  stroke: #999;
  stroke-opacity: 0.6;
}

.label {
  font-family: Arial, sans-serif;
  font-size: 12px;
  color: white;
  pointer-events: none;
}

.link-label {
  font-family: Arial, sans-serif;
  font-size: 10px;
  color: white;
  pointer-events: none;
}

.new-link {
  stroke: #ff0000;
  stroke-dasharray: 5, 5;
}
</style>
