<template>
  <div class="grid grid-flow-row auto-rows-max min-h-full place-items-center bg-white px-6 py-24 sm:py-32 lg:px-8">
    <div class="bg-amber-700 text-4xl">asjdlkajshdlkjahsldkjhasds</div>
    <div class="rete" ref="rete"></div>
    <div>s</div>
  </div>
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
  width: 80vw;
  height: 80vh;
  border: black 2px solid;
}

</style>
