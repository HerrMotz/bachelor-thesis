<template>
  <EntitySelector type="item" language="en"
                  @pointerdown.stop=""
                  @dblclick.stop=""
                  @selected-entity="(prop) => {value = prop; data.options.change(value)}"
  />
</template>

<script>
import EntitySelector from "./EntitySelector.vue";

export default {
  components: {EntitySelector},
  props: ['data'],
  data() {
    return {
      value: this.data.options.initial
    }
  },
  created() {},
}
</script>