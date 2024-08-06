import { createApp } from 'vue'
import './style.css'
import App from './App.vue'

import hljs from 'highlight.js/lib/core';
// @ts-ignore
import hljsDefineSparql from './lib/highlight/sparql.js';
import hljsVuePlugin from "./lib/highlight/component.ts";

hljs.registerLanguage('sparql', hljsDefineSparql);

const app = createApp(App)
app.use(hljsVuePlugin)
app.mount('#app')
