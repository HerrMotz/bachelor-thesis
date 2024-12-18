<template>
    <div class="node" :class="{ selected: data?.selected }" :style="nodeStyles">
      <div class="p-2">
        <h1 class="text-3xl text-white font-bold">{{ data?.label }}</h1>
      </div>
      <div class="control">
        <Ref :emit="emit" :data="{ type: 'control', payload: controls.literalInput }" />
      </div>
      <div class="input">
        <Ref
          class="input-socket"
          :emit="emit"
          :data="{ type: 'socket', side: 'input', key: 'i0', nodeId: data?.id, payload: inputs.i0.socket }"
        />
      </div>
      <div class="output">
        <Ref
          class="output-socket"
          :emit="emit"
          :data="{ type: 'socket', side: 'output', key: 'o0', nodeId: data?.id, payload: outputs.o0.socket }"
        />
      </div>
    </div>
  </template>
  
  <script lang="ts">
  import { defineComponent, computed } from 'vue';
  import { Ref } from 'rete-vue-plugin';
  
  export default defineComponent({
    props: {
      data: Object,
      emit: Function,
      seed: String,
    },
    setup(props) {
      const nodeStyles = computed(() => ({
        width: Number.isFinite(props.data?.width) ? `${props.data?.width}px` : '',
        height: Number.isFinite(props.data?.height) ? `${props.data?.height}px` : '',
      }));
  
      const controls = props.data?.controls;
      const outputs = props.data?.outputs;
      const inputs = props.data?.inputs;
  
      return {
        nodeStyles,
        controls,
        outputs,
        inputs,
      };
    },
    components: {
      Ref,
    },
  });
  </script>

<style lang="scss" scoped>
@use "sass:math";
$node-width: 300px;
$socket-margin: 6px;
$socket-size: 16px;

.node {
  background: #acbcff;
  border: 2px solid grey;
  border-radius: 10px;
  cursor: pointer;
  box-sizing: border-box;
  width: $node-width;
  height: auto;
  padding-bottom: 6px;
  position: relative;
  user-select: none;

  &:hover {
    background: #9bacfb;
  }

  &.selected {
    color: black;
    border-color: red;
    background: #ffcf00;
  }

  .title {
    color: white;
    font-family: sans-serif;
    font-size: 18px;
    padding: 8px;
  }

  .output {
    text-align: right;
  }

  .input {
    text-align: left;
  }

  .output-socket {
    text-align: right;
    margin-right: -18px;
    display: inline-block;
  }

  .input-socket {
    text-align: left;
    margin-left: -18px;
    display: inline-block;
  }

  .input-title,
  .output-title {
    vertical-align: middle;
    color: white;
    display: inline-block;
    font-family: sans-serif;
    font-size: 14px;
    margin: $socket-margin;
    line-height: $socket-size;
  }

  .input-control {
    z-index: 1;
    width: calc(100% - #{$socket-size + 2*$socket-margin});
    vertical-align: middle;
    display: inline-block;
  }

  .control {
    padding: $socket-margin math.div($socket-size, 2) + $socket-margin;
  }
}
</style>