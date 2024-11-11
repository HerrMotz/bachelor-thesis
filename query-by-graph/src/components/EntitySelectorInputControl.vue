<template>
  <EntitySelector type="item" language="en"
                  @pointerdown.stop=""
                  @dblclick.stop=""
                  @selected-entity="(prop) => {data.options.change(prop)}"/>
</template>

<script>
import EntitySelector from "./EntitySelector.vue";

export default {
  computed: {
    EntityType() {
      return EntityType
    }
  },
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