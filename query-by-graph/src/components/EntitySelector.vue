<script setup lang="ts">
import {queryWikidata, WikiDataEntity, WikiDataApiResponse} from "../lib/wikidata/queryDataService.ts";

const props = defineProps({
  language: {type: String, required: true},
  type: {type: String, required: true}, // will be passed to the wikidata query, can be e.g. "item" or "property"
});

// my local data type contains an ID and a label
// where the ID is the P or Q number
// and the label describes the entity

// so the wikidataentity.display.label.value is what I am looking for.

const emit = defineEmits<{
  selectedEntity: [EntityType] // named tuple syntax
}>();

import {ref} from 'vue'
import {CheckIcon, ChevronUpDownIcon} from '@heroicons/vue/20/solid'
import {
  Combobox,
  ComboboxButton,
  ComboboxInput,
  ComboboxLabel,
  ComboboxOption,
  ComboboxOptions,
} from '@headlessui/vue'
import EntityType from "../lib/types/EntityType.ts";

const variableEntity = { // EntityType
  id: '?',
  label: 'Variable',
  description: 'Variable Entity',
  prefix: {
    uri: "",
    abbreviation: "",
  },
};

const queriedEntities = ref([
  variableEntity,
]);

const selectedEntity = ref(variableEntity);
emit("selectedEntity", variableEntity);

function displayValue(entity: unknown): string {
  if (typeof entity === 'object' && entity !== null && 'label' in entity) {
    return (entity as { label: string }).label;
  } else {
    return 'No label';
  }
}

function queryHelper(query: string) {
  queryWikidata({
    language: props.language,
    uselang: props.language,
    type: props.type,
    search: query
  }).then((data: WikiDataApiResponse) => {
    queriedEntities.value = data.search.map((entity: WikiDataEntity) => {
      return { // EntityType
        id: entity.id,
        label: entity.display.label.value,
        description: entity.display.description.value,
        prefix: {
          uri: entity.concepturi,
          abbreviation: "wd",
        }
      }
    }).concat([variableEntity]);
  }).catch(reason => {
    console.error(reason);
  });
}

function eventEmitEntityHelper(entity: EntityType) {
  console.log("Emit event");
  selectedEntity.value = entity;
  emit('selectedEntity', entity);
}
</script>

<template>
  <div>
    <h4 class="">
      <slot></slot>
    </h4>
    <Combobox as="div" :model-value="selectedEntity" @update:modelValue="($event) => eventEmitEntityHelper($event)">
      <ComboboxLabel class="block text-sm font-medium leading-6 text-gray-900"></ComboboxLabel>
      <div class="relative mt-2">
        <ComboboxInput
            class="w-full rounded-md border-0 bg-white py-1.5 pl-3 pr-12 text-gray-900 shadow-sm ring-1 ring-inset ring-gray-300 focus:ring-2 focus:ring-inset focus:ring-indigo-600 sm:text-sm sm:leading-6"
            @change="queryHelper($event.target.value)"
            @blur="queryHelper('')"
            :display-value="displayValue"
        />
        <ComboboxButton class="absolute inset-y-0 right-0 flex items-center rounded-r-md px-2 focus:outline-none">
          <ChevronUpDownIcon class="h-5 w-5 text-gray-400" aria-hidden="true"/>
        </ComboboxButton>

        <ComboboxOptions v-if="queriedEntities.length > 0"
                         class="absolute z-10 mt-1 max-h-60 w-full overflow-auto rounded-md bg-white py-1 text-base shadow-lg ring-1 ring-black ring-opacity-5 focus:outline-none sm:text-sm">
          <ComboboxOption v-for="entity in queriedEntities" :key="entity.id" :value="entity" as="template"
                          v-slot="{ active, selected }">
            <li :class="['relative cursor-default select-none py-2 pl-3 pr-9', active ? 'bg-indigo-600 text-white' : 'text-gray-900']">
              <div class="flex">
              <span :class="['truncate', selected && 'font-semibold']">
                {{ entity.id }}
              </span>
                <span :class="['ml-2 truncate text-gray-500', active ? 'text-indigo-200' : 'text-gray-500']">
                {{ entity.label }}
              </span>
              </div>

              <span v-if="selected"
                    :class="['absolute inset-y-0 right-0 flex items-center pr-4', active ? 'text-white' : 'text-indigo-600']">
              <CheckIcon class="h-5 w-5" aria-hidden="true"/>
            </span>
            </li>
          </ComboboxOption>
        </ComboboxOptions>
      </div>
    </Combobox>
  </div>
</template>

<style scoped>

</style>
