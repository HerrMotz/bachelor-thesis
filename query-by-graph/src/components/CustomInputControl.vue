<template>
  <input
      @pointerdown.stop=""
      @dblclick.stop=""
      @change="data.options.change(value)"
      v-model="value"
  />
  {{value}}
</template>

<script>
export default {
  props: ['data'],
  data() {
    return {
      value: this.data.options.initial
    }
  },
  created() {
    console.log("DATA GOES HERE")
    console.log(this.data)
  },
}
</script>