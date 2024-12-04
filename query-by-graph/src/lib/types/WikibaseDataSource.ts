interface WikibaseDataSource {
    name: string;
    url: string,
    preferredLanguages: string[],
    propertyPrefix: {
        url: string,
        abbreviation: string
    },
    entityPrefix: {
        url: string,
        abbreviation: string
    }
}

export default WikibaseDataSource;
