<script setup lang="ts">
import {onMounted, ref} from 'vue';
import {createEditor} from "./lib/rete/editor.ts";

import 'highlight.js/lib/common';

import EntityType from "./lib/types/EntityType.ts";

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
  {id: "P160", label: "Ausbildende Institution"},
  {id: "P141", label: "Vater"},
  {id: "P31", label: "Property 31"},
  {id: "P279", label: "Property 279"},
];

const mockIndividuals = [
  {id: "?", label: "Variable Individual"},
  {id: "Q21880", label: "Universität Jena"},
  {id: "Q5879", label: "Johann Wolfgang von Goethe"},
  {id: "Q123", label: "Individual 123"},
]

const mockCode =
    `PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>

SELECT *
WHERE {
  ?entity rdfs:label ?name .
}
LIMIT 20`

interface Editor {
  removeSelectedConnection: () => void;
  setSelectedProperty: (property: EntityType) => void;
  setSelectedIndividual: (property: EntityType) => void;
  undo: () => void;
  redo: () => void;
}
</script>

<template>
  <div>
    <div class="place-items-center bg-white px-6 pb-24 pt-12 sm:pb-32 sm:pt-12 lg:px-8" style="min-height: calc(100vh - 50px)">
      <div class="text-3xl text-center mb-10 font-bold">Query by Graph</div>
      <div class="flex w-full min-h-full bg-amber-100 rounded-2xl" style="min-height: 520px;">
        <div class="w-4/5 min-h-full bg-amber-50">
          <h2 class="text-xl font-semibold bg-amber-100 rounded-tl-2xl p-4">
            <!-- This has the same propeties as the toolbox heading -->
            Visual Query Builder
            <span class="text-sm ml-2 font-medium">
              Each Box is a SPARQL-Individual and each Connection between them is a SPARQL-Property
            </span>
          </h2>
          <div ref="rete" style="height: calc(100% - 44px);"></div>
        </div>
        <div v-if="editor" class="w-1/5 overflow-auto">
          <h2 class="text-xl font-semibold bg-amber-200 rounded-tr-2xl p-4">
            Toolbox
            <span class="text-sm ml-2 font-medium">
              Perform actions on the graph
            </span>
          </h2>
          <div class="flex-col flex gap-6 max-h-full p-4">
            <div class="flex-col flex gap-2">
              <h4 class="font-semibold">History</h4>
              <div class="flex gap-4">
                <Button class="grow" @click="() => { // why the hell is this necessary in TypeScript with Vue3 D':
                if (editor) {
                  editor.then((e: Editor) => e.undo());
                }
              }">
                  Undo
                  <kbd
                      class="inline-flex items-center rounded border border-gray-200 px-1 font-sans text-xs text-gray-200">CTRL+Y</kbd>
                </Button>
                <Button class="grow" @click="() => { // why the hell is this necessary in TypeScript with Vue3 D':
                if (editor) {
                  editor.then((e: Editor) => e.redo());
                }
              }">

                  Redo
                  <kbd
                      class="inline-flex items-center rounded border border-gray-200 px-1 font-sans text-xs text-gray-200">CTRL+Z</kbd>
                </Button>
              </div>
            </div>

            <div class="flex-col flex gap-2">
              <h4 class="font-semibold">Create Individual</h4>
              <EntitySelector :entities="mockIndividuals" @selected-entity="(prop: EntityType) => { // why the hell is this necessary in TypeScript with Vue3 D':
                if (editor) {
                  editor.then((e: Editor) => e.setSelectedIndividual(prop));
                }
              }" class="bg-amber-300 rounded-2xl p-2">
                Individual Selector
              </EntitySelector>
              <p class="text-gray-600 text-sm hover:text-gray-900 transition-all">
                <em>Hint:</em>
                Select an individual below. Then, <b>right-click</b> on the canvas to create a new individual. You can
                <b>delete it</b> by also right-clicking on it.
              </p>
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
              <h4 class="font-semibold">Delete selected connections</h4>
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
      <div class="mt-10">
        <h2 class="text-xl font-semibold bg-amber-100 rounded-t-2xl p-4">
          <!-- This has the same propeties as the toolbox heading -->
          Generated SPARQL Query
          <span class="text-sm ml-2 font-medium">
              This contains the generated SPARQL code from above. It is updated with every change above.
          </span>
        </h2>
        <div class="bg-amber-50">
          <highlightjs class="min-h-20 bg-amber-50" language="sparql" :code="mockCode"/>
        </div>
      </div>

    </div>
    <div>
      <!-- Footer -->
      <div class="text-center text-gray-600 text-sm">
        <p>
          Made with ❤️ by <a href="https://www.daniel-motz.de">Daniel Motz</a>
        </p>
      </div>
    </div>
  </div>
</template>
