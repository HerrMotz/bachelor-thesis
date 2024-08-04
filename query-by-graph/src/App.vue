<script setup lang="ts">
import { onMounted, ref } from 'vue';
import { createEditor } from "./editor.ts";

import EntityType from "./types/EntityType.ts";

import EntitySelector from "./components/EntitySelector.vue";
import Button from "./components/Button.vue";

const editor = ref<Promise<Editor> | null>(null);  // Define the type of editor as Promise<Editor> | null
const rete = ref();

onMounted(() => {
  if (rete.value) {
    editor.value = createEditor(rete.value);
  }
});

// mock property numbers array like P160, P141, etc.
const mockProperties = [
  { id: "P160", label: "Ausbildende Institution" },
  { id: "P141", label: "Vater" },
  { id: "P31", label: "Property 31" },
  { id: "P279", label: "Property 279" },
];

const mockIndividuals = [
  {id: "21880", label: "Universität Jena"},
  {id: "Q5879", label: "Johann Wolfgang von Goethe"},
  {id: "Q123", label: "Individual 123"},
]

interface Editor {
  removeSelectedConnection: () => void;
  setSelectedProperty: (property: EntityType) => void;
  setSelectedIndividual: (property: EntityType) => void;
}
</script>

<template>
  <div class="h-screen min-h-screen place-items-center bg-white px-6 pb-24 pt-12 sm:pb-32 sm:pt-12 lg:px-8">
    <div class="text-3xl text-center mb-10 font-bold">Query by Graph</div>
    <div class="flex w-full min-h-full bg-amber-100 rounded-2xl" style="height: 100%; min-height: 100%;">
      <div class="w-4/5 min-h-full p-4 bg-amber-50">
        <h2 class="text-xl font-semibold mb-4">Visual Query Builder</h2>
        <div ref="rete" style="height: calc(100% - 44px);"></div>
      </div>
      <div v-if="editor" class="w-1/5 flex-col flex gap-6 min-h-full p-4">
        <h2 class="text-xl font-semibold">Toolbox</h2>

        <div class="flex-col flex gap-2">
          <h4 class="font-semibold">Create Individual</h4>
          <EntitySelector :entities="mockIndividuals" @selected-entity="(prop: EntityType) => { // why the hell is this necessary in TypeScript with Vue3 D':
              if (editor) {
                editor.then((e: Editor) => e.setSelectedIndividual(prop));
              }
            }" class="bg-amber-300 rounded-2xl p-2">
            Individual Selector
          </EntitySelector>
        </div>

        <div class="flex-col flex gap-2">
          <h4 class="font-semibold">Create connection</h4>
          <EntitySelector :entities="mockProperties" @selected-entity="(prop: EntityType) => { // why the hell is this necessary in TypeScript with Vue3 D':
              if (editor) {
                editor.then((e: Editor) => e.setSelectedProperty(prop));
              }
            }" class="bg-amber-300 rounded-2xl p-2">
            Property Selector
          </EntitySelector>
          <p class="text-gray-600 text-sm hover:text-gray-900 transition-all">
            <em>Hint:</em>
            After selecting the appropriate property, add a new connection by clicking
            an output connector (right side) and then an input connector (left side) of an
            individual.
          </p>
        </div>
        <div class="flex-col flex gap-2">
          <h4 class="font-semibold">Delete connections</h4>
          <Button
              @click="() => { // why the hell is this necessary in TypeScript with Vue3 D':
              if (editor) {
                editor.then((e: Editor) => e.removeSelectedConnection());
              }
            }">
            Delete selected
          </Button>
          <p class="text-gray-600 text-sm hover:text-gray-900 transition-all">
            <em>Hint:</em>
            Select a connection by clicking on it and then click the button above to delete it.
            This only works when at least one connection is selected (red).
          </p>
        </div>
      </div>
    </div>
  </div>
</template>
