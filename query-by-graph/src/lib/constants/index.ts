import WikibaseDataSource from "../types/WikibaseDataSource.ts";

const wikiDataDataSource: WikibaseDataSource = {
    name: "WikiData",
    url: "https://www.wikidata.org/w/api.php",
    preferredLanguages: ['en'],
    entityPrefix: {
        url: "http://www.wikidata.org/entity/",
        abbreviation: "wd"
    },
    propertyPrefix: {
        url: "http://www.wikidata.org/prop/direct/",
        abbreviation: "wdt"
    },
    queryService: "https://query.wikidata.org/ ",
}

const factGridDataSource: WikibaseDataSource = {
    name: "FactGrid",
    url: "https://database.factgrid.de/w/api.php",
    preferredLanguages: ['de'],
    entityPrefix: {
        url: "https://database.factgrid.de/entity/",
        abbreviation: "fg"
    },
    propertyPrefix: {
        url: "https://database.factgrid.de/prop/direct/",
        abbreviation: "fgt"
    },
    queryService: "https://database.factgrid.de/query/",
}

const testinstanceSource: WikibaseDataSource = {
    name: "Test Instance",
    url: "https://daniels-test-instance.wikibase.cloud/",
    preferredLanguages: ['en'],
    entityPrefix: {
        url: "https://daniels-test-instance.wikibase.cloud/entity/",
        abbreviation: "ti"
    },
    propertyPrefix: {
        url: "https://daniels-test-instance.wikibase.cloud/prop/direct/",
        abbreviation: "tt"
    },
    queryService: "https://daniels-test-instance.wikibase.cloud/query/",
}

const noDataSource: WikibaseDataSource = {
    name: "",
    url: "",
    preferredLanguages: [],
    propertyPrefix: {
        url: "",
        abbreviation: ""
    },
    entityPrefix: {
        url: "",
        abbreviation: ""
    },
    queryService: "",
}

export {wikiDataDataSource,factGridDataSource,testinstanceSource,noDataSource}