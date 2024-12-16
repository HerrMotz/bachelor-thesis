const deepCopy = (object: object) => {
    return JSON.parse(JSON.stringify(object))
}

export {deepCopy}