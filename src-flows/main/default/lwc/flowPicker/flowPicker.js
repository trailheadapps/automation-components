import { LightningElement, api, wire } from 'lwc';
import getFlowNames from '@salesforce/apex/FlowPickerController.getFlowNames';
import { FlowAttributeChangeEvent } from 'lightning/flowSupport';

/**
 * This component requires that the Flow_Picker permission set be assigned to the end user
 */
export default class FlowPicker extends LightningElement {
    @api label = 'Select a Flow';
    @api selectedFlowApiName;
    @api showActiveFlowsOnly = false;
    @api searchString;
    @api required = false;
    @api showWhichFlowTypes = 'Flow,AutolaunchedFlow';
    @api placeholder = '- Select a Flow -';
    @api componentWidth = '12';

    flowDefinitions = [];

    @wire(getFlowNames, { filterParams: '$filters' })
    loadFlowNames({ error, data }) {
        if (error) {
            console.error(error.body.message);
        } else if (data) {
            this.flowDefinitions = data.map((flow) => ({
                value: flow.ApiName,
                label: flow.Label
            }));
        }
    }

    handleChange(event) {
        this.dispatchEvent(
            new FlowAttributeChangeEvent(
                'selectedFlowApiName',
                event.detail.value
            )
        );
    }

    /**
     * Exposes Flow API Name to a calling Aura component
     */
    @api
    flowApiName() {
        return this.selectedFlowApiName;
    }

    /**
     * Flow calls this method to validate component input
     */
    @api
    validate() {
        if (this.required && !this.selectedFlowApiName) {
            return {
                isValid: false,
                errorMessage: 'Complete this field.'
            };
        }
        return { isValid: true };
    }

    get componentClasses() {
        return `slds-size_${this.componentWidth}-of-12 slds-form-element`;
    }

    get filters() {
        const filters = [];
        // Filter on specific flow types
        if (this.showWhichFlowTypes) {
            filters.push({
                key: 'ProcessType',
                value: this.showWhichFlowTypes
            });
        }
        // Filter on active versions only
        if (this.showActiveFlowsOnly) {
            filters.push({
                key: '!ActiveVersionId',
                value: null
            });
        }
        // Add filter for Search String
        if (this.searchString) {
            filters.push({
                key: 'Label',
                value: `%${this.searchString}%`
            });
        }
        return filters;
    }
}
