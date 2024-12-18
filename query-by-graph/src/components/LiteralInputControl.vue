<template>
    <div>
      <input
        type="text"
        v-model="value"
        @input="onInput"
        class="rounded-md border-0 bg-white py-1.5 pl-3 pr-12 text-gray-900 shadow-sm focus:ring-2 focus:ring-inset focus:ring-indigo-600 sm:text-sm sm:leading-6"
      />
    </div>
  </template>
  
  <script>
  export default {
    props: ['data'],
    data() {
      return {
        value: this.data.options.initial || '',
      };
    },
    methods: {
      onInput(event) {
        this.value = event.target.value;
        this.data.options.change(this.value);
      },
    },
  };
  </script>