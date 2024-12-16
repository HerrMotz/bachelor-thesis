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
    }
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
    }
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
    }
}

export {wikiDataDataSource,factGridDataSource,noDataSource}