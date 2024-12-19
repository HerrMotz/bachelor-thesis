import WikibaseDataSource from "./WikibaseDataSource";

interface EntityType {
    id: string,
    label: string,
    description: string,
    prefix: {
       uri: string,
       abbreviation: string,
    };
    dataSource: WikibaseDataSource;
    isLiteral?: boolean;
}

export default EntityType;
