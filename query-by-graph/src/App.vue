<template>
  <div class="rete" ref="rete"></div>
</template>

<script>
import { defineComponent } from 'vue'
import { createEditor } from './editor'

export default defineComponent({
  mounted(){
    createEditor(this.$refs.rete)
  }
})
</script>

<style lang="scss">
body {
  margin: 0;
}
.rete {
  width: 100vw;
  height: 100vh;
}

</style>
