<script setup lang="ts">
import { onMounted, ref} from 'vue';
import {createEditor} from "./lib/rete/editor.ts";

import {graph_to_query_wasm} from "../pkg";

import 'highlight.js/lib/common';

import EntityType from "./lib/types/EntityType.ts";

import EntitySelector from "./components/EntitySelector.vue";
import Button from "./components/Button.vue";
import ConnectionInterfaceType from "./lib/types/ConnectionInterfaceType.ts";
import ClipboardButton from "./components/ClipboardButton.vue";

interface Editor {
  setVueCallback: (callback: (context: any) => void) => void;
  removeSelectedConnections: () => Promise<void>;
  setSelectedProperty: (property: EntityType) => void;
  setSelectedIndividual: (property: EntityType) => void;
  undo: () => void;
  redo: () => void;
  exportConnections: () => ConnectionInterfaceType[];
} 

const editor = ref<Editor>();  // Define the type of editor as Promise<Editor> | null
const rete = ref();

const code = ref("");

onMounted(async () => {
  if (rete.value) {
    editor.value = await createEditor(rete.value);
    editor.value?.setVueCallback((context) => { // add pipe to parent scope
      if (context.type === "connectioncreated" || context.type === "connectionremoved") {
        setTimeout(() => {
          const connections = editor.value!.exportConnections()
          code.value = graph_to_query_wasm(JSON.stringify(connections));
        }, 0);
      }
    });
  }
});

const copyToClipboard = () => {
  navigator.clipboard.writeText(code.value);
}
</script>

<template>
  <div>
    <div class="place-items-center bg-white px-6 pb-24 pt-12 sm:pb-2 sm:pt-12 lg:px-8"
         style="">
      <div class="text-3xl text-center mb-10 font-bold">Query by Graph</div>
      <p class="text-center font-medium text-gray-500 text-sm mb-6" style="min-width: 250px !important; padding: 0 30% 0 30%;">
        This program allows you to build a SPARQL query using visual elements.
        Press RMB on the canvas to create a new individual and LMB on an individual's socket to create a connection.
        You can delete an individual by pressing RMB on it.
      </p>
      <div class="flex w-full bg-amber-100 rounded-2xl" style="">
        <div class="w-4/5 bg-amber-50 rounded-tl-2xl">
          <h2 class="text-xl font-semibold bg-amber-100 p-4">
            <!-- This has the same propeties as the toolbox heading -->
            Visual Query Builder
            <span class="text-sm ml-2 font-medium">
              Each Box is a SPARQL-Individual and each Connection between them is a SPARQL-Property
            </span>
          </h2>
          <div ref="rete" class="h-full"></div>
        </div>
        <div v-if="editor" class="w-1/5 overflow-auto rounded-tr-2xl" style="max-height: 60vh;">
          <h2 class="text-xl font-semibold bg-amber-200 p-4">
            Toolbox
            <span class="text-sm ml-2 font-medium">
              Perform actions on the graph
            </span>
          </h2>
          <div class="flex-col flex gap-6 p-4">
            <div class="flex-col flex gap-2">
              <h4 class="font-semibold">History</h4>
              <div class="flex gap-4">
                <Button class="grow" @click="() => {
                if (editor) {
                  editor.undo();
                }
              }">
                  Undo
                  <kbd
                      class="inline-flex items-center rounded border border-gray-200 px-1 font-sans text-xs text-gray-200">CTRL+Y</kbd>
                </Button>
                <Button class="grow" @click="() => {
                if (editor) {
                  editor.redo();
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
              <EntitySelector language="en" type="item" @selected-entity="(prop: EntityType) => {
                if (editor) {
                  editor.setSelectedIndividual(prop);
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
              <EntitySelector language="en" type="property" @selected-entity="(prop: EntityType) => { 
                if (editor) {
                  editor.setSelectedProperty(prop);
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
                  editor.removeSelectedConnections();
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
              This contains the generated SPARQL code. It is updated with every change in the editor.
          </span>
        </h2>
        <div class="bg-amber-50 flex w-full flex-row">
          <highlightjs class="min-h-20 grow bg-amber-50" language="sparql" :code="code"/>
          <ClipboardButton class="inline-flex mt-4 mr-4" @click="copyToClipboard();" />
        </div>
      </div>

    </div>
    <div>
      <!-- Footer -->
      <div class="text-center text-gray-600 text-sm mb-2">
        <p>
          <a class="underline" href="https://github.com/HerrMotz/bachelor-thesis/">Repository</a> &middot;
          Made with ❤️ by <a class="underline" href="https://www.daniel-motz.de">Daniel Motz</a>
        </p>
      </div>
    </div>
  </div>
</template>
