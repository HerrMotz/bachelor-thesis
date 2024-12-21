import EntityType from "../types/EntityType.ts";
import {noDataSource} from "../constants";
import {deepCopy} from "../utils";
import {selectedDataSource} from "../../store.ts";

const variableEntity: EntityType = { // EntityType
    id: '?',
    label: 'Variable',
    description: 'Variable Entity',
    prefix: {
        uri: "",
        abbreviation: "",
    },
    dataSource: noDataSource,
    isLiteral: false
};

const variableEntityConstructor = (name: string): EntityType => {
    const newVariable = deepCopy(variableEntity);
    newVariable.id = "?"+name;
    newVariable.dataSource = selectedDataSource.value;
    return newVariable;
}

const literalEntityConstructor = (name: string): EntityType => { 
    const newLiteral = deepCopy(variableEntity);
    newLiteral.id = "?"+name;
    newLiteral.label = "Literal";
    newLiteral.description = "Literal value";
    newLiteral.isLiteral = true;
    newLiteral.dataSource = selectedDataSource.value;
    return newLiteral;
};

const noEntity: EntityType = {
    id: '',
    label: '',
    description: '',
    prefix: {
        uri: "",
        abbreviation: "",
    },
    dataSource: noDataSource,
    isLiteral: false
};

export {noEntity, variableEntity, variableEntityConstructor, literalEntityConstructor}