import EntityType from "../types/EntityType.ts";

const variableEntity: EntityType = { // EntityType
    id: '?',
    label: 'Variable',
    description: 'Variable Entity',
    prefix: {
        uri: "",
        abbreviation: "",
    },
};

const variableEntityConstructor = (name: string): EntityType => {
    const newVariable = variableEntity;
    newVariable.id = "?"+name;
    return newVariable;
}

const noEntity: EntityType = {
    id: '',
    label: '',
    description: '',
    prefix: {
        uri: "",
        abbreviation: "",
    }
};

export {noEntity, variableEntity, variableEntityConstructor}