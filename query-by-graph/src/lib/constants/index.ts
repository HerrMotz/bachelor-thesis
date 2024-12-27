import {WikibaseDataSource} from "../types/WikibaseDataSource.ts";

const wikiDataDataSource: WikibaseDataSource = {
    name: "WikiData",
    uri: "https://www.wikidata.org/w/api.php",
    preferredLanguages: ['en'],
    itemPrefix: {
        uri: "http://www.wikidata.org/entity/",
        abbreviation: "wd"
    },
    propertyPrefix: {
        uri: "http://www.wikidata.org/prop/direct/",
        abbreviation: "wdt"
    },
    queryService: "https://query.wikidata.org/ ",
}

const factGridDataSource: WikibaseDataSource = {
    name: "FactGrid",
    uri: "https://database.factgrid.de/w/api.php",
    preferredLanguages: ['de'],
    itemPrefix: {
        uri: "https://database.factgrid.de/entity/",
        abbreviation: "fg"
    },
    propertyPrefix: {
        uri: "https://database.factgrid.de/prop/direct/",
        abbreviation: "fgt"
    },
    queryService: "https://database.factgrid.de/query/",
}

const testinstanceSource: WikibaseDataSource = {
    name: "Test Instance",
    uri: "https://daniels-test-instance.wikibase.cloud/",
    preferredLanguages: ['en'],
    itemPrefix: {
        uri: "https://daniels-test-instance.wikibase.cloud/entity/",
        abbreviation: "ti"
    },
    propertyPrefix: {
        uri: "https://daniels-test-instance.wikibase.cloud/prop/direct/",
        abbreviation: "tt"
    },
    queryService: "https://daniels-test-instance.wikibase.cloud/query/",
}

const noDataSource: WikibaseDataSource = {
    name: "",
    uri: "",
    preferredLanguages: [],
    propertyPrefix: {
        uri: "",
        abbreviation: ""
    },
    itemPrefix: {
        uri: "",
        abbreviation: ""
    },
    queryService: "",
}

export {wikiDataDataSource,factGridDataSource,testinstanceSource,noDataSource}