interface EntityType {
    id: string,
    label: string,
    description: string,
    prefix: {
       uri: string,
       abbreviation: string,
    },
}

export default EntityType;
