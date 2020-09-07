import { createElement } from 'lwc';
import { FlowAttributeChangeEventName } from 'lightning/flowSupport';
import FlowPicker from 'c/flowPicker';
import { registerApexTestWireAdapter } from '@salesforce/sfdx-lwc-jest';
import getFlowNames from '@salesforce/apex/FlowPickerController.getFlowNames';

// Register as Apex wire adapter. Some tests verify that provisioned values trigger desired behavior.
const getFlowNamesAdapter = registerApexTestWireAdapter(getFlowNames);

const FLOW_ATTRIBUTE_NAME = 'selectedFlowApiName';
const FLOW_ATTRIBUTE_VALUE = 'MockFlowAttributeValue';

describe('c-flow-picker', () => {
    afterEach(() => {
        // The jsdom instance is shared across test cases in a single file so reset the DOM
        while (document.body.firstChild) {
            document.body.removeChild(document.body.firstChild);
        }
        // Prevent data saved on mocks from leaking between tests
        jest.clearAllMocks();
    });

    describe('rendering', () => {
        it('renders with the right width', () => {
            // Create initial element
            const element = createElement('c-flow-picker', {
                is: FlowPicker
            });
            element.componentWidth = 5;
            document.body.appendChild(element);

            const wrapperElement = element.shadowRoot.querySelector('div');
            expect(wrapperElement.className).toContain('slds-size_5-of-12');
        });
    });

    describe('events', () => {
        it('fires a FlowAttributeChangeEvent when selection changes', () => {
            // Create initial element
            const element = createElement('c-flow-picker', {
                is: FlowPicker
            });
            document.body.appendChild(element);

            const mockEventHandler = jest.fn();
            element.addEventListener(
                FlowAttributeChangeEventName,
                mockEventHandler
            );

            const comboboxElement = element.shadowRoot.querySelector(
                'lightning-combobox'
            );
            comboboxElement.dispatchEvent(
                new CustomEvent('change', {
                    detail: { value: FLOW_ATTRIBUTE_VALUE },
                    bubbles: true
                })
            );

            // Return a promise to wait for any asynchronous DOM updates. Jest
            // will automatically wait for the Promise chain to complete before
            // ending the test and fail the test if the promise rejects.
            return Promise.resolve().then(() => {
                // Check if flow attribute change event has been fired
                expect(mockEventHandler).toHaveBeenCalled();
                expect(
                    mockEventHandler.mock.calls[0][0].detail.attributeName
                ).toBe(FLOW_ATTRIBUTE_NAME);
                expect(
                    mockEventHandler.mock.calls[0][0].detail.attributeValue
                ).toBe(FLOW_ATTRIBUTE_VALUE);
            });
        });
    });

    describe('validation', () => {
        it('validate when required value is present', () => {
            // Create initial element
            const element = createElement('c-flow-picker', {
                is: FlowPicker
            });
            element.required = true;
            element.selectedFlowApiName = 'mockFlow';
            document.body.appendChild(element);

            const validation = element.validate();

            expect(validation.isValid).toBeTruthy();
        });

        it('fails to validate when required value is missing', () => {
            // Create initial element
            const element = createElement('c-flow-picker', {
                is: FlowPicker
            });
            element.required = true;
            document.body.appendChild(element);

            const validation = element.validate();

            expect(validation.isValid).toBeFalsy();
        });
    });

    describe('@wire getFlowNames data', () => {
        it('calls wire with default filter params', () => {
            // Create initial element
            const element = createElement('c-flow-picker', {
                is: FlowPicker
            });
            document.body.appendChild(element);

            // Return a promise to wait for any asynchronous DOM updates. Jest
            // will automatically wait for the Promise chain to complete before
            // ending the test and fail the test if the promise rejects.
            return Promise.resolve().then(() => {
                // Get the config of the last wire call
                const config = getFlowNamesAdapter.getLastConfig();

                // Inspect filter parameters
                expect(config).not.toBe(null);
                const params = config.filterParams;
                expect(params.length).toBe(1);
                expect(params[0].key).toBe('ProcessType');
                expect(params[0].value).toBe('Flow,AutolaunchedFlow');
            });
        });

        it('calls wire with no filter params', () => {
            // Create initial element
            const element = createElement('c-flow-picker', {
                is: FlowPicker
            });
            element.showWhichFlowTypes = undefined;
            document.body.appendChild(element);

            // Return a promise to wait for any asynchronous DOM updates. Jest
            // will automatically wait for the Promise chain to complete before
            // ending the test and fail the test if the promise rejects.
            return Promise.resolve().then(() => {
                // Get the config of the last wire call
                const config = getFlowNamesAdapter.getLastConfig();

                // Inspect filter parameters
                expect(config).not.toBe(null);
                const params = config.filterParams;
                expect(params.length).toBe(0);
            });
        });

        it('calls wire with all filter params', () => {
            // Create initial element
            const element = createElement('c-flow-picker', {
                is: FlowPicker
            });
            element.showWhichFlowTypes = 'MockFlowType';
            element.showActiveFlowsOnly = true;
            element.searchString = 'mockSearchValue';
            document.body.appendChild(element);

            // Return a promise to wait for any asynchronous DOM updates. Jest
            // will automatically wait for the Promise chain to complete before
            // ending the test and fail the test if the promise rejects.
            return Promise.resolve().then(() => {
                // Get the config of the last wire call
                const config = getFlowNamesAdapter.getLastConfig();

                // Inspect filter parameters
                expect(config).not.toBe(null);
                const params = config.filterParams;
                expect(params.length).toBe(3);
                expect(params[0].key).toBe('ProcessType');
                expect(params[0].value).toBe('MockFlowType');
                expect(params[1].key).toBe('!ActiveVersionId');
                expect(params[1].value).toBe(null);
                expect(params[2].key).toBe('Label');
                expect(params[2].value).toBe('%mockSearchValue%');
            });
        });
    });

    it('is accessible', () => {
        const element = createElement('c-flow-picker', {
            is: FlowPicker
        });
        element.componentWidth = 5;
        document.body.appendChild(element);

        return Promise.resolve().then(() => expect(element).toBeAccessible());
    });
});
