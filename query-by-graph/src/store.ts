import { ref } from 'vue';
import WikibaseDataSource from "./lib/types/WikibaseDataSource.ts";
import {wikiDataDataSource} from "./lib/constants";


export const selectedDataSource = ref<WikibaseDataSource>(
        wikiDataDataSource
);