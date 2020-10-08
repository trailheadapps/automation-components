import { LightningElement, wire, api, track } from 'lwc';
import { getObjectInfo } from 'lightning/uiObjectInfoApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import {
    DEFAULTS,
    TYPE_ICONS,
    TYPE_DESCRIPTORS,
    formatValue,
    isReference,
    getDataType,
    removeFormatting,
    escapeRegExp
} from 'c/flowComboboxUtils';
import UserPreferencesShowCityToGuestUsers from '@salesforce/schema/User.UserPreferencesShowCityToGuestUsers';

export default class FlowCombobox extends LightningElement {
    @api name;
    @api label;
    @api required = false;
    @api builderContextFilterType;
    @api builderContextFilterCollectionBoolean;

    _dataType;
    _value;
    @track allOptions;
    @track _options = [];
    _mergeFields = [];
    _selectedObjectType;
    _selectedFieldPath;
    _selectedIconName;
    _builderContext;
    _staticOptions;

    hasError = false;
    isMenuOpen = false;
    isDataSelected = false;
    isDataModified = false;
    isSelfEvent = false;
    key = 0;

    @api
    get staticOptions() {
        return this._staticOptions;
    }

    set staticOptions(value) {
        this._staticOptions = value;
        this.processOptions();
    }

    @api
    get value() {
        return this._value;
    }

    set value(value) {
        this.isDataSelected = !!value;
        if (isReference(value)) {
            this._dataType = getDataType(value);
            this._value = removeFormatting(value);

            // TODO: find icon
        } else {
            this._value = value;
        }
        this.determineSelectedType();
    }

    @api
    get valueType() {
        return this._dataType;
    }

    set valueType(value) {
        if (!this._dataType) {
            if (value) {
                this._dataType = value;
            } else {
                this._dataType = DEFAULTS.TYPE_STRING;
            }
        }
    }

    @api get builderContext() {
        return this._builderContext;
    }

    set builderContext(value) {
        this._builderContext = value;
        this._mergeFields = this.generateMergeFieldsFromBuilderContext(
            this._builderContext
        );
        if (!this._selectedObjectType) {
            this.setOptions(this._mergeFields);
            this.determineSelectedType();
        }
    }

    @api
    reportValidity() {
        if (this.hasError) {
            return false;
        }
        if (this.required && !this.isDataSelected) {
            return false;
        }
        return true;
    }

    @wire(getObjectInfo, { objectApiName: '$_selectedObjectType' })
    _getObjectInfo({ error, data }) {
        if (error) {
            const title = `Error while retrieving ${this._selectedObjectType} SObject info for flow combobox`;
            dispatchEvent(
                new ShowToastEvent({
                    title,
                    message: error.body ? error.body : error,
                    variant: 'error'
                })
            );
            console.error(title, JSON.stringify(error));
            this.setOptions([]);
        } else if (data) {
            const options = Object.keys(data.fields).map((curField) => {
                const field = data.fields[curField];
                const type =
                    field.dataType === 'Reference' ? 'SObject' : field.dataType;
                const objectType = field.referenceToInfos.length
                    ? field.referenceToInfos[0].apiName
                    : null;

                return {
                    type,
                    label: field.label,
                    value: field.apiName,
                    isCollection: false,
                    objectType,
                    optionIcon: TYPE_ICONS[type],
                    isObject: type === 'SObject',
                    displayType: type === 'SObject' ? objectType : type,
                    key: DEFAULTS.KEY_PREFIX + this.key++,
                    flowType: DEFAULTS.TYPE_REFERENCE
                };
            });
            this.setOptions([{ type: `${data.label} Fields`, options }]);
        }
    }

    // LIFECYLE HOOKS

    connectedCallback() {
        document.addEventListener('click', this.handleWindowClick.bind(this));
    }

    disconnectedCallback() {
        document.removeEventListener(
            'click',
            this.handleWindowClick.bind(this)
        );
    }

    // PRIVATE HELPER FUNCTIONS

    setOptions(value) {
        this._options = value;
        this.allOptions = JSON.parse(JSON.stringify(this._options));
        this.processOptions();
    }

    getTypeOption(value) {
        if (value) {
            const parentVar = value.split('.')[0];
            if (parentVar && this._mergeFields && this._mergeFields.length) {
                for (let i = 0; i < this._mergeFields.length; i++) {
                    const localOption = this._mergeFields[i].options.find(
                        (curTypeOption) => {
                            const result =
                                curTypeOption.value.toLowerCase() ===
                                    parentVar.toLowerCase() ||
                                curTypeOption.value.toLowerCase() ===
                                    value.toLowerCase();
                            return result;
                        }
                    );
                    if (localOption) {
                        return localOption;
                    }
                }
            }
        }
        return undefined;
    }

    determineSelectedType() {
        if (this._value && this.allOptions) {
            const valParts = this._value
                .replace(/[^a-zA-Z0-9._-]/g, '')
                .split('.');
            if (valParts.length > 1) {
                for (let optionGroup of this.allOptions) {
                    const selectedOption = optionGroup.options.find(
                        (option) => option.value === valParts[0]
                    );
                    if (selectedOption) {
                        this._selectedObjectType = selectedOption.displayType;
                        valParts.pop();
                        this._selectedFieldPath = valParts.join('.');
                        break;
                    }
                }
            }
        }
    }

    generateMergeFieldsFromBuilderContext(builderContext) {
        const optionsByType = {};
        TYPE_DESCRIPTORS.forEach((typeDescriptor) => {
            const curType = typeDescriptor.apiName;
            const typeParts = curType.split('.');
            let typeOptions = [];

            if (typeParts.length && builderContext[typeParts[0]]) {
                let objectToExamine = builderContext;
                let parentNodeLabel = '';
                typeParts.forEach((curTypePart) => {
                    if (objectToExamine[curTypePart]) {
                        objectToExamine = objectToExamine[curTypePart].map(
                            (curItem) => {
                                parentNodeLabel = curItem.label
                                    ? curItem.label
                                    : curItem.name;
                                return {
                                    ...curItem,
                                    varApiName: curItem.name,
                                    varLabel: parentNodeLabel
                                };
                            }
                        );
                    } else {
                        if (Array.isArray(objectToExamine)) {
                            let allObjectToExamine = [];
                            objectToExamine.forEach((curObjToExam) => {
                                if (curObjToExam.storeOutputAutomatically) {
                                    //TODO: Uncomment when it is clear how to get output parameters from actions and flow screens
                                    // allObjectToExamine.push({
                                    //     varApiName: curObjToExam.name,
                                    //     varLabel: curObjToExam.label
                                    // });
                                } else {
                                    allObjectToExamine = [
                                        ...allObjectToExamine,
                                        ...curObjToExam[curTypePart].map(
                                            (curItem) => {
                                                return {
                                                    ...curItem,
                                                    varApiName: `${curObjToExam.name}.${curItem.name}`,
                                                    varLabel: `${
                                                        curObjToExam.label
                                                            ? curObjToExam.label
                                                            : parentNodeLabel
                                                    }: ${curItem.name}`
                                                };
                                            }
                                        )
                                    ];
                                }
                            });
                            objectToExamine = allObjectToExamine;
                        }
                    }
                });
                const localType = TYPE_DESCRIPTORS.find(
                    (curTypeDescriptor) => curTypeDescriptor.apiName === curType
                );

                const curTypeOptions = this.getOptionLines(
                    objectToExamine,
                    'varLabel',
                    'varApiName',
                    'dataType',
                    localType.isCollectionField
                        ? localType.isCollectionField
                        : 'isCollection',
                    localType.objectTypeField
                        ? localType.objectTypeField
                        : 'objectType',
                    localType
                );
                if (curTypeOptions.length) {
                    typeOptions = [...typeOptions, ...curTypeOptions];
                }
                if (typeOptions.length) {
                    if (optionsByType[localType.label]) {
                        optionsByType[localType.label] = [
                            ...optionsByType[localType.label],
                            ...typeOptions
                        ];
                    } else {
                        optionsByType[localType.label] = typeOptions;
                    }
                }
            }
        });
        return Object.keys(optionsByType).map((type) => {
            return { type, options: optionsByType[type] };
        });
    }

    getOptionLines(
        objectArray,
        labelField,
        valueField,
        typeField,
        isCollectionField,
        objectTypeField,
        typeDescriptor
    ) {
        return objectArray.map((object) => {
            const type = this.getTypeByDescriptor(
                object[typeField],
                typeDescriptor
            );
            const label = object[labelField]
                ? object[labelField]
                : object[valueField];
            const isCollection =
                typeDescriptor.apiName === DEFAULTS.TYPE_RECORD_LOOKUP
                    ? !object[isCollectionField]
                    : !!object[isCollectionField];
            const isObject =
                type === DEFAULTS.TYPE_SOBJECT ||
                typeDescriptor.apiName === DEFAULTS.TYPE_RECORD_LOOKUP;
            let displayType =
                type === DEFAULTS.TYPE_SOBJECT ? object[objectTypeField] : type;
            if (isCollection) {
                displayType += '[]';
            }
            return {
                type,
                label,
                value: object[valueField],
                isCollection,
                objectType: object[objectTypeField],
                optionIcon: TYPE_ICONS[type],
                isObject,
                displayType,
                key: DEFAULTS.KEY_PREFIX + this.key++,
                flowType: DEFAULTS.TYPE_REFERENCE
            };
        });
    }

    getTypeByDescriptor(objectFieldType, typeDescriptor) {
        if (!typeDescriptor) {
            return DEFAULTS.TYPE_STRING;
        } else if (typeDescriptor.apiName === DEFAULTS.TYPE_RECORD_LOOKUP) {
            return DEFAULTS.TYPE_SOBJECT;
        }
        return objectFieldType ? objectFieldType : DEFAULTS.TYPE_STRING;
    }

    doOpenObject(event, value, objectType) {
        event.stopPropagation();
        this._selectedFieldPath =
            (this._selectedFieldPath ? this._selectedFieldPath + '.' : '') +
            value;
        this._value = `${this._selectedFieldPath}.`;
        this._selectedObjectType = objectType;
    }

    dispatchValueChangedEvent() {
        const valueChangedEvent = new CustomEvent('valuechanged', {
            detail: {
                id: this.name,
                newValue: this._value ? this._value : '',
                newValueDataType: this._dataType
            }
        });
        this.dispatchEvent(valueChangedEvent);
    }

    resetData() {
        this._value = '';
        this.resetTypeOptions();
        this.closeOptionDialog();
    }

    resetTypeOptions() {
        this.isDataModified = true;
        this._selectedFieldPath = '';
        this._selectedObjectType = null;
        this._selectedIconName = null;
        this._dataType = DEFAULTS.TYPE_STRING;
        this.setOptions(this._mergeFields);
    }

    openOptionDialog() {
        this.isMenuOpen = true;
    }

    closeOptionDialog(setValueInput) {
        if (this._value) {
            this.isDataSelected = true;
        }
        this.isMenuOpen = false;

        if (setValueInput) {
            this.setValueInput();
        }

        if (this.isDataModified) {
            this.dispatchValueChangedEvent();
            this.isDataModified = false;
        }
    }

    processOptions(searchString) {
        let searchRegExp, cleanSearchRegExp;
        if (searchString) {
            const searchParts = searchString.split('.');
            const searchTerm = searchParts[searchParts.length - 1];
            searchRegExp = RegExp(escapeRegExp(searchTerm), 'i');
            cleanSearchRegExp = RegExp(
                escapeRegExp(searchTerm.replace(/\W/g, '')),
                'i'
            );
        }

        this._options = [];
        if (this.allOptions && this.allOptions.length) {
            this.allOptions.forEach((curOption) => {
                let localOptions = curOption.options;

                // Filter options based on type
                if (this.builderContextFilterType) {
                    localOptions = localOptions.filter(
                        (option) =>
                            option.displayType ===
                                this.builderContextFilterType ||
                            (option.type === 'SObject' &&
                                !this.builderContextFilterCollectionBoolean)
                    );
                }

                // Filter options that are collections
                if (this.builderContextFilterCollectionBoolean) {
                    localOptions = localOptions.filter(
                        (option) =>
                            option.isCollection ===
                            this.builderContextFilterCollectionBoolean
                    );
                }

                // Filter options with search string
                if (searchRegExp) {
                    localOptions = localOptions.filter(
                        (option) =>
                            searchRegExp.test(option.label) ||
                            cleanSearchRegExp.test(option.value)
                    );
                }

                if (localOptions.length) {
                    this._options.push({
                        ...curOption,
                        ...{
                            options: localOptions
                        }
                    });
                }
            });
        }

        if (this._staticOptions && this._staticOptions.length) {
            this._options.push({
                type: 'OBJECT FIELDS',
                options: this._staticOptions.map((option) => {
                    return {
                        type: DEFAULTS.TYPE_STRING,
                        label: option.label,
                        value: option.value,
                        isCollection: false,
                        objectType: DEFAULTS.TYPE_STRING,
                        optionIcon: 'utility:text',
                        isObject: false,
                        displayType: DEFAULTS.TYPE_STRING,
                        key: DEFAULTS.KEY_PREFIX + this.key++,
                        flowType: DEFAULTS.TYPE_STRING
                    };
                })
            });
        }
    }

    setValueInput() {
        const valueInput = this.template.querySelector('.value-input');
        if (valueInput) {
            this.hasError = false;
            this._value = removeFormatting(valueInput.value);
            if (isReference(valueInput.value)) {
                const typeOption = this.getTypeOption(this._value);
                if (!typeOption) {
                    this.hasError = true;
                }
                this._dataType = DEFAULTS.TYPE_REFERENCE;
            } else {
                this._dataType = DEFAULTS.TYPE_STRING;
            }
        }
    }

    // EVENT HANDLERS

    handleOpenObject(event) {
        const { optionValue, objectType } = event.currentTarget.dataset;
        this.doOpenObject(event, optionValue, objectType);
    }

    handleOptionClick(event) {
        const {
            value,
            objectType,
            flowType,
            iconName
        } = event.currentTarget.dataset;
        if (this.value && this.value.endsWith(value) && objectType) {
            this.doOpenObject(event, value, objectType);
        } else {
            this._dataType = flowType;
            this._value = this._selectedFieldPath
                ? `${this._selectedFieldPath}.${value}`
                : value;
            this.isDataModified = true;
            this.hasError = false;
            this.closeOptionDialog();
        }
        this._selectedIconName = iconName;
    }

    handleWindowClick(event) {
        if (!event.path.includes(this.template.host) && !this.isSelfEvent) {
            this.closeOptionDialog(true);
        }
        this.isSelfEvent = false;
    }

    handleOpenOptions() {
        this.isSelfEvent = true;
        if (this.isMenuOpen) {
            this.isDataSelected = false;
            this._value = formatValue(this._value, this._dataType);
        } else {
            this.openOptionDialog();
        }
    }

    handleOpenEditDialog(event) {
        event.stopPropagation();
        this.handleOpenOptions();
    }

    handleCloseOptions() {
        this.closeOptionDialog();
    }

    handleSearchField(event) {
        const { value } = event.target;
        this._dataType = getDataType(value);
        if (!value || !value.includes('.')) {
            this.resetTypeOptions();
            this.setOptions(this._mergeFields);
        }
        this.isDataModified = true;
        this.isDataSelected = false;

        this.processOptions(value);
        if (this.allOptions.length) {
            this.openOptionDialog();
        }
    }

    handleSearchKeyUp(event) {
        if (event.key === 'Enter' || event.key === 'Tab') {
            // Toggle menu
            if (this.isMenuOpen) {
                this.closeOptionDialog(true);
            } else {
                this.openOptionDialog();
            }
        }
    }

    handleKeyDown(event) {
        if (
            this.isMenuOpen &&
            (event.key === 'Tab' || event.key === 'Escape')
        ) {
            this.closeOptionDialog(true);
            if (event.key === 'Escape') {
                event.stopPropagation();
            }
        }
    }

    // TEMPLATE GETTERS

    get displayPill() {
        return (
            this.isDataSelected && this._dataType === DEFAULTS.TYPE_REFERENCE
        );
    }

    get pillIcon() {
        // Use icon from selection (more accurate for object fields)
        if (this._selectedIconName) {
            return this._selectedIconName;
        }

        // Find icon if data was loaded with a selection
        const searchValue = this._selectedFieldPath
            ? this._selectedFieldPath
            : this._value;
        let iconName = 'utility:text';
        for (let optionGroup of this._mergeFields) {
            const selectedOption = optionGroup.options.find(
                (option) => option.value === searchValue
            );
            if (selectedOption) {
                iconName = selectedOption.optionIcon;
                break;
            }
        }
        return iconName;
    }

    get formElementClass() {
        return this.hasError
            ? 'slds-form-element slds-has-error'
            : 'slds-form-element';
    }

    get dropdownClass() {
        return `slds-combobox slds-dropdown-trigger slds-dropdown-trigger_click ${
            this.isMenuOpen ? 'slds-is-open' : ''
        }`;
    }
}
