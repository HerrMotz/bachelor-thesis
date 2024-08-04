<template>
  <svg width="250" height="250" xmlns="http://www.w3.org/2000/svg">
    <path :d="path" />
    <g>
      <rect :x="centerX" :y="centerY" :width="rectLength" height="40" fill="white" stroke="black"></rect>
      <text :x="centerX+12" :y="centerY+25">{{data.id}}</text>
    </g>
  </svg>
</template>

<script>
import { defineComponent } from 'vue'

export default defineComponent({
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
    stroke: red;
    pointer-events: auto;
  }
}
</style>