<template>
  <div style="visibility: hidden">
    <span class="label link node"></span>
  </div>
  <div ref="graphContainer" class="graph-container" style="border: 2pt solid black"></div>
</template>

<script>
import * as d3 from "d3";

export default {
  name: "NetworkVisualiser",
  data() {
    return {
      width: 800,
      height: 600,
      nodes: [
        { id: 1, label: "Node 1" },
        { id: 2, label: "Node 2" },
        { id: 3, label: "Node 3" },
        { id: 4, label: "Node 4" },
        { id: 5, label: "Node 5" },
      ],
      links: [
        { source: 1, target: 2 },
        { source: 1, target: 3 },
        { source: 2, target: 4 },
        { source: 3, target: 5 },
      ],
    };
  },
  mounted() {
    this.createForceGraph();
  },
  methods: {
    createForceGraph() {
      const svg = d3
          .select(this.$refs.graphContainer)
          .append("svg")
          .attr("width", this.width)
          .attr("height", this.height);

      const simulation = d3
          .forceSimulation(this.nodes)
          .force("link", d3.forceLink(this.links).id((d) => d.id).distance(100))
          .force("charge", d3.forceManyBody().strength(-200))
          .force("center", d3.forceCenter(this.width / 2, this.height / 2));

      const link = svg
          .selectAll(".link")
          .data(this.links)
          .enter()
          .append("line")
          .attr("class", "link")
          .attr("stroke", "#999")
          .attr("stroke-width", 1.5);

      const node = svg
          .selectAll(".node")
          .data(this.nodes)
          .enter()
          .append("circle")
          .attr("class", "node")
          .attr("r", 10)
          .attr("fill", "#69b3a2")
          .call(
              d3
                  .drag()
                  .on("start", dragstarted)
                  .on("drag", dragged)
                  .on("end", dragended)
          );

      const label = svg
          .selectAll(".label")
          .data(this.nodes)
          .enter()
          .append("text")
          .attr("class", "label")
          .attr("dy", -10)
          .attr("text-anchor", "middle")
          .text((d) => d.label);

      simulation.on("tick", () => {
        link
            .attr("x1", (d) => d.source.x)
            .attr("y1", (d) => d.source.y)
            .attr("x2", (d) => d.target.x)
            .attr("y2", (d) => d.target.y);

        node
            .attr("cx", (d) => d.x)
            .attr("cy", (d) => d.y);

        label
            .attr("x", (d) => d.x)
            .attr("y", (d) => d.y);
      });

      function dragstarted(event, d) {
        // if (!event.active) simulation.alphaTarget(0.3).restart();
        // d.fx = d.x;
        // d.fy = d.y;
      }

      function dragged(event, d) {
        // d.fx = event.x;
        // d.fy = event.y;
      }

      function dragended(event, d) {
        // if (!event.active) simulation.alphaTarget(0);
        // d.fx = null;
        // d.fy = null;
      }
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
  stroke-width: 1.5px;
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
</style>
