<template>
  <div class="h-screen min-h-screen place-items-center bg-white px-6 pb-24 pt-12 sm:pb-32 sm:pt-12 lg:px-8">
    <div class="text-3xl text-center mb-10 font-bold">Query by Graph</div>
    <div class="flex w-full min-h-full bg-amber-100 rounded-2xl" style="height: 100%; min-height: 100%;">
      <div class="w-4/5 min-h-full p-4 bg-amber-50">
        <h2 class="text-xl font-semibold mb-4">Visual Query Builder</h2>
        <div ref="rete" style="height: calc(100% - 44px);" ></div>
      </div>
      <div class="w-1/5 flex-col flex gap-6 min-h-full p-4">
        <h2 class="text-xl font-semibold">Toolbox</h2>
        <div class="flex-col flex gap-2">
          <h4 class="font-semibold">Creating a new connection</h4>
          <PropertySelection @selected-property="selectedProperty" class="bg-amber-300 rounded-2xl p-2" />
          <p class="text-gray-600 text-sm hover:text-gray-900 transition-all">
            <em>Hint:</em>
            After selecting the appropriate property, add a new connection by clicking
            an output connector (right side) and then an input connector (left side) of an
            individual.
          </p>
        </div>
        <div class="flex-col flex gap-2">
          <h4 class="font-semibold">Deleting a connection</h4>
          <Button :disabled="!selectedConnection">
            {{ !!selectedConnection ? 'Delete selected connection' : 'First, select a connection' }}
          </Button>
          <p class="text-gray-600 text-sm hover:text-gray-900 transition-all">
            <em>Hint:</em>
            Select a connection by clicking on it and then click the button above to delete it.
          </p>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import { defineComponent } from 'vue'
import { createEditor } from './editor'
import PropertySelection from "./components/PropertySelection.vue";
import Button from "./components/Button.vue";

export default defineComponent({
  components: {Button, PropertySelection},
  data() {
    return {
      selectedProperty: null,
      selectedConnection: null,
      editor: null,
    }
  },
  mounted(){
    this.editor = createEditor(this.$refs.rete)
  }
})
</script>

<style lang="scss">
body {
  margin: 0;
}

</style>
