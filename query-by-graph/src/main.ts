import { createApp } from 'vue'
import './style.css'
import App from './App.vue'

import hljs from 'highlight.js/lib/core';
import javascript from 'highlight.js/lib/languages/javascript';
import hljsVuePlugin from "./lib/highlight/component.ts";

hljs.registerLanguage('javascript', javascript);

const app = createApp(App)
app.use(hljsVuePlugin)
app.mount('#app')
