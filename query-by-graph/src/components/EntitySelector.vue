<script setup lang="ts">
import EntityType from "../lib/types/EntityType.ts";

const props = defineProps({
  entities: {type: Array<EntityType>, required: true}
});
const entities = props.entities

const emit = defineEmits<{
  selectedEntity: [{ id: string, label: string }] // named tuple syntax
}>();

emit('selectedEntity', entities[0]);

function emitSelectedEntity(event: Event) {
  const target = (<HTMLInputElement>event.target)
  emit('selectedEntity', entities[parseInt(target?.value)]);
}

</script>

<template>
  <div>
    <h4 class=""><slot></slot></h4>
    <!-- Dropdown menu with label and description, save the selected value -->
    <select @change="emitSelectedEntity($event)" class="mt-2 w-full block rounded-md border-0 py-1.5 pl-3 pr-10 text-gray-900 ring-1 ring-inset ring-gray-300 focus:ring-2 focus:ring-indigo-600 sm:text-sm sm:leading-6">
      <option v-for="(property, index) in entities" :key="index" :value="index">
        {{ property.id }} - {{ property.label }}
      </option>
    </select>
  </div>
</template>

<style scoped>

</style>