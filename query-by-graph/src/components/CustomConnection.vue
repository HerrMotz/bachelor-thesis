<template>
  <svg width="250" height="250" xmlns="http://www.w3.org/2000/svg">
    <!-- This highlights the path on selection -->
    <path :d="path" :class="[$props.data.selected ? 'hover:stroke-red-400 stroke-red-500' : 'hover:stroke-blue-400 stroke-blue-600']" />
    <g>
      <!-- This positions the label -->
      <rect :x="centerX" :y="centerY" :width="rectLength" height="40" fill="white" stroke="black"></rect>
      <text :x="centerX+12" :y="centerY+25">{{data.property}}</text>
    </g>
  </svg>
</template>

<script>
import { defineComponent } from 'vue'

// This connection component has the following features:
// - it displays a label in the middle of the connection
// - the label container/border adjusts to the length of the label
// - it can be selected by clicking on it

export default defineComponent({
  name: "CustomConnection",
  props: ['data', 'start', 'end', 'path'],
  computed: {
    rectLength() {
      return this.data.id.length*10;
    },
    centerX() {
      return (this.end.x + this.start.x) / 2 - this.rectLength/2;
    },
    centerY() {
      return (this.end.y + this.start.y) / 2 - 20;
    }
  }
})
</script>

<style lang="scss" scoped>
svg {
  overflow: visible !important;
  position: absolute;
  pointer-events: none;
  width: 9999px;
  height: 9999px;
  path {
    fill: none;
    stroke-width: 5px;
    pointer-events: auto;
  }
}
</style>