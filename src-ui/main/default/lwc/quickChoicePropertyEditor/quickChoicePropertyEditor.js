/**
 * This component is a Custom Property Editor for the Quick Choice Flow Screen Component
 */
import { LightningElement, api } from 'lwc';

const DISPLAY_MODE_OPTIONS = [
    { label: 'Cards', value: 'cards' },
    { label: 'Picklist', value: 'picklist' },
    { label: 'Radio Buttons', value: 'radio' }
];
const INPUT_SOURCE_OPTIONS = [
    { label: 'List', value: 'list' },
    { label: 'Picklist', value: 'picklist' }
];

export default class QuickChoiceEditor extends LightningElement {
    displayModeOptions = DISPLAY_MODE_OPTIONS;
    inputSourceOptions = INPUT_SOURCE_OPTIONS;
    _inputVariables = [];

    @api builderContext;
    @api
    get inputVariables() {
        return this._inputVariables;
    }
    set inputVariables(variables) {
        this._inputVariables = variables || [];
    }

    @api
    validate() {
        const validity = [];
        // Check validity of all inputs
        const inputCmps = this.template.querySelectorAll(
            'lightning-input, lightning-radio-group, lightning-slider, c-flow-combobox'
        );
        inputCmps.forEach((inputCmp) => {
            inputCmp.reportValidity();
            if (!inputCmp.checkValidity()) {
                validity.push({
                    key: inputCmp.label,
                    errorString: `Value for '${inputCmp.label}' is invalid.`
                });
            }
        });
        // Check format for qualified field API Name
        const errorString = this.validateQualifiedPicklistFieldName();
        if (errorString) {
            validity.push({
                key: 'Qualified Picklist Field Name',
                errorString
            });
        }
        return validity;
    }

    getInputVariableValue(varName) {
        const param = this._inputVariables.find(({ name }) => name === varName);
        return param && param.value;
    }

    getInputVariableValueDataType(varName) {
        const param = this._inputVariables.find(({ name }) => name === varName);
        return param && param.valueDataType;
    }

    setInputVariableValue(varName, valueDataType, value) {
        // Clone input variables to avoid proxy issues when modifying object properties
        const variables = JSON.parse(JSON.stringify(this._inputVariables));
        // Prepare updated variable
        const updatedVariable = {
            name: varName,
            value,
            valueDataType
        };
        // Search for existing variable to replace
        const index = variables.findIndex(({ name }) => name === varName);
        // Save updated variable
        if (index === -1) {
            variables.push(updatedVariable);
        } else {
            variables[index] = updatedVariable;
        }
        this._inputVariables = variables;
    }

    handleChange(event) {
        const { name } = event.target;
        const { type } = event.target.dataset;
        const value = this.getValueFromChangeEvent(event);
        this.setInputVariableValue(name, type, value);
        this.propagateChangeToConfigEditor(name, type, value);
    }

    handleFlowComboboxChange(event) {
        const { id, newValueDataType, newValue } = event.detail;
        this.setInputVariableValue(id, newValueDataType, newValue);
        this.propagateChangeToConfigEditor(id, newValueDataType, newValue);
    }

    handleQualifiedPicklistFieldNameChange(event) {
        this.handleFlowComboboxChange(event);
        this.validateQualifiedPicklistFieldName();
    }

    getValueFromChangeEvent(event) {
        const { tagName, type } = event.target;
        let value;
        if (
            tagName === 'LIGHTNING-RADIO-GROUP' ||
            tagName === 'LIGHTNING-SLIDER'
        ) {
            value = event.detail.value;
        } else if (tagName === 'LIGHTNING-INPUT' && type === 'checkbox') {
            value = event.target.checked;
        } else if (tagName === 'LIGHTNING-INPUT' && type === 'text') {
            value = event.target.value;
        } else {
            throw new Error(
                `Unhandled input type in change handler: tagName=${tagName} type=${type}`
            );
        }
        return value;
    }

    propagateChangeToConfigEditor(name, type, value) {
        const detail = {
            name,
            newValue: value,
            newValueDataType: type
        };
        const valueChangedEvent = new CustomEvent(
            'configuration_editor_input_value_changed',
            {
                bubbles: true,
                cancelable: false,
                composed: true,
                detail
            }
        );
        this.dispatchEvent(valueChangedEvent);
    }

    validateQualifiedPicklistFieldName() {
        let error = null;
        if (
            this.qualifiedPicklistFieldName !== '' &&
            !/.\../.test(this.qualifiedPicklistFieldName)
        ) {
            error = `Value is not a qualified field API name.`;
            const input = this.template.querySelector(
                '.qualifiedPicklistFieldName'
            );
            input?.setCustomValidity(error);
        }
        return error;
    }

    get label() {
        return this.getInputVariableValue('label');
    }
    get labelValueType() {
        return this.getInputVariableValueDataType('label');
    }

    get value() {
        return this.getInputVariableValue('value');
    }
    get valueValueType() {
        return this.getInputVariableValueDataType('value');
    }

    get choiceLabels() {
        return this.getInputVariableValue('choiceLabels');
    }
    get choiceLabelsValueType() {
        return this.getInputVariableValueDataType('choiceLabels');
    }

    get choiceValues() {
        return this.getInputVariableValue('choiceValues');
    }
    get choiceValuesValueType() {
        return this.getInputVariableValueDataType('choiceValues');
    }

    get choiceIcons() {
        return this.getInputVariableValue('choiceIcons');
    }
    get choiceIconsValueType() {
        return this.getInputVariableValueDataType('choiceIcons');
    }

    get qualifiedPicklistFieldName() {
        return this.getInputVariableValue('qualifiedPicklistFieldName');
    }
    get qualifiedPicklistFieldNameValueType() {
        return this.getInputVariableValueDataType('qualifiedPicklistFieldName');
    }

    get recordTypeId() {
        return this.getInputVariableValue('recordTypeId');
    }
    get recordTypeIdValueType() {
        return this.getInputVariableValueDataType('recordTypeIdValueType');
    }

    get required() {
        return this.getInputVariableValue('required');
    }

    get displayMode() {
        return this.getInputVariableValue('displayMode');
    }

    get inputSource() {
        return this.getInputVariableValue('inputSource');
    }

    get numberOfColumns() {
        return this.getInputVariableValue('numberOfColumns');
    }

    get isCards() {
        return this.displayMode === 'cards';
    }

    get isPicklistInputSource() {
        return this.inputSource === 'picklist';
    }

    get isListInputSource() {
        return this.inputSource === 'list';
    }
}
