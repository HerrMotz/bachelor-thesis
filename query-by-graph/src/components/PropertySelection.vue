<script setup lang="ts">

// mock property numbers array like P160, P141, etc.
import {defineEmits} from "vue";

const properties = [
  { id: "P160", label: "Ausbildende Institution" },
  { id: "P141", label: "Vater" },
  { id: "P31", label: "Property 31" },
  { id: "P279", label: "Property 279" },
];

const emit = defineEmits(['selectedProperty']);

emit('selectedProperty', properties[0]);

function emitSelectedProperty(event) {
  emit('selectedProperty', properties[event.target.value]);
}

</script>

<template>
  <div>
    <h4 class="">Property Selection</h4>
    <!-- Dropdown menu with label and description, save the selected value -->
    <select @change="emitSelectedProperty($event)"  class="mt-2 block rounded-md border-0 py-1.5 pl-3 pr-10 text-gray-900 ring-1 ring-inset ring-gray-300 focus:ring-2 focus:ring-indigo-600 sm:text-sm sm:leading-6">
      <option v-for="(property, index) in properties" :key="index" :value="index">
        {{ property.id }} - {{ property.label }}
      </option>
    </select>
  </div>
</template>

<style scoped>

</style>