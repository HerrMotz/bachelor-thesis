<script setup lang="ts">

// mock property numbers array like P160, P141, etc.
import {defineEmits} from "vue";

const properties = [
  { id: 1, label: "P160", description: "Ausbildende Institution" },
  { id: 2, label: "P141", description: "Vater" },
  { id: 3, label: "P31", description: "Property 31" },
  { id: 4, label: "P279", description: "Property 279" },
];

const emit = defineEmits(['selectedProperty']);

emit('selectedProperty', properties[0]);

function emitSelectedProperty(event) {
  console.log("here is a log")
  console.log(properties[event.target.value])
  emit('selectedProperty', properties[event.target.value]);
}

</script>

<template>
  <div style="margin-bottom: 50px;">
    <h4 style="margin-bottom: 0">Property Selection</h4>
    <!-- Dropdown menu with label and description, save the selected value -->
    <select @change="emitSelectedProperty($event)">
      <option v-for="(property, index) in properties" :key="index" :value="index">
        {{ property.label }} - {{ property.description }}
      </option>
    </select>
  </div>
</template>

<style scoped>

</style>