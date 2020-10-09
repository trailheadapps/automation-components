const REFERENCE_REFEX = /^\{!(.*)\}$/;

const DEFAULTS = {
    TYPE_STRING: 'String',
    TYPE_REFERENCE: 'reference',
    TYPE_SOBJECT: 'SObject',
    TYPE_RECORD_LOOKUP: 'recordLookups',
    KEY_PREFIX: 'flowCombobox-'
};

const TYPE_ICONS = {
    String: 'utility:text',
    Boolean: 'utility:check',
    Date: 'utility:date_input',
    DateTime: 'utility:date_time',
    Number: 'utility:number_input',
    Int: 'utility:number_input',
    Double: 'utility:number_input',
    Picklist: 'utility:picklist',
    TextArea: 'utility:textarea',
    Phone: 'utility:phone_portrait',
    Address: 'utility:location',
    Currency: 'utility:currency_input',
    Url: 'utility:link',
    SObject: 'utility:sobject',
    reference: 'utility:merge_field'
};

const TYPE_DESCRIPTORS = [
    {
        apiName: 'variables',
        label: 'Variables',
        dataType: 'dataType',
        objectTypeField: 'objectType'
    },
    {
        apiName: 'constants',
        label: 'Global Constants',
        dataType: DEFAULTS.TYPE_STRING
    },
    {
        apiName: 'textTemplates',
        label: 'Variables',
        dataType: DEFAULTS.TYPE_STRING
    },
    {
        apiName: 'stages',
        label: 'Variables',
        dataType: DEFAULTS.TYPE_STRING
    },
    // {apiName: 'screens.fields', label: 'Screen Components', dataType: DEFAULTS.TYPE_STRING},
    // {
    //     apiName: 'screens.fields.inputParameters',
    //     label: 'Screen Components',
    //     dataType: DEFAULTS.TYPE_STRING
    // },
    {
        apiName: DEFAULTS.TYPE_RECORD_LOOKUP,
        label: 'Variables',
        dataType: 'SObject',
        objectTypeField: 'object',
        isCollectionField: 'getFirstRecordOnly'
    },
    {
        apiName: 'formulas',
        label: 'Formulas',
        dataType: DEFAULTS.TYPE_STRING
    }
    // {apiName: 'actionCalls.inputParameters', label: 'Variables', dataType: DEFAULTS.TYPE_STRING},
    // {apiName: 'actionCalls.outputParameters', label: 'Variables', dataType: DEFAULTS.TYPE_STRING},
    // {apiName: 'apexPluginCalls', label: 'Variables', dataType: DEFAULTS.TYPE_STRING},
];

const isReference = (value) => {
    if (value) {
        return REFERENCE_REFEX.test(value.trim());
    }
    return false;
};

const getDataType = (value) => {
    return isReference(value) ? DEFAULTS.TYPE_REFERENCE : DEFAULTS.TYPE_STRING;
};

const formatValue = (value, dataType) => {
    if (isReference(value)) {
        return value;
    }
    return dataType === DEFAULTS.TYPE_REFERENCE ? `{!${value}}` : value;
};

const removeFormatting = (value) => {
    if (value) {
        const trimmedValue = value.trim();
        const match = REFERENCE_REFEX.exec(trimmedValue);
        return match ? match[1] : trimmedValue;
    }
    return value;
};

const escapeRegExp = (string) => {
    return string.replace(/[.*+\-?^${}()|[\]\\]/g, '\\$&');
};

export {
    TYPE_ICONS,
    TYPE_DESCRIPTORS,
    DEFAULTS,
    isReference,
    formatValue,
    getDataType,
    removeFormatting,
    escapeRegExp
};
