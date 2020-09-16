import { createElement } from 'lwc';
import { FlowAttributeChangeEventName } from 'lightning/flowSupport';
import QuickChoice from 'c/quickChoice';
import { registerApexTestWireAdapter } from '@salesforce/sfdx-lwc-jest';
import { getPicklistValues } from 'lightning/uiObjectInfoApi';

// Register as Apex wire adapter. Some tests verify that provisioned values trigger desired behavior
const getPicklistValuesAdapter = registerApexTestWireAdapter(getPicklistValues);

const SAMPLE_VALUES = ['a', 'b', 'c'];
const SAMPLE_ICONS = ['standard:account', 'standard:address', 'standard:app'];
const SAMPLE_PICKLIST_FIELD_NAME = 'Opportunity.StageName';
const MASTER_RECORD_TYPE_ID = '012000000000000AAA';
const MOCK_RECORD_TYPE_ID = 'mockRecordTypeId';

describe('c-quick-choice', () => {
    afterEach(() => {
        // The JSDOM instance is shared across test cases in a single file so reset the DOM
        while (document.body.firstChild) {
            document.body.removeChild(document.body.firstChild);
        }
        // Prevent data saved on mocks from leaking between tests
        jest.clearAllMocks();
    });

    describe('rendering', () => {
        it('renders picklist', () => {
            // Create initial element
            const element = createElement('c-quick-choice', {
                is: QuickChoice
            });
            element.displayMode = 'picklist';
            element.inputSource = 'list';
            element.choiceValues = SAMPLE_VALUES;
            document.body.appendChild(element);

            const comboboxElement = element.shadowRoot.querySelector(
                'lightning-combobox'
            );
            expect(comboboxElement).not.toBeNull();
        });

        it('renders radio', () => {
            // Create initial element
            const element = createElement('c-quick-choice', {
                is: QuickChoice
            });
            element.displayMode = 'radio';
            element.inputSource = 'list';
            element.choiceValues = SAMPLE_VALUES;
            document.body.appendChild(element);

            const radioGroupElement = element.shadowRoot.querySelector(
                'lightning-radio-group'
            );
            expect(radioGroupElement).not.toBeNull();
        });

        it('renders cards with the rigth initial value', () => {
            // Create initial element
            const element = createElement('c-quick-choice', {
                is: QuickChoice
            });
            element.displayMode = 'cards';
            element.inputSource = 'list';
            element.choiceValues = SAMPLE_VALUES;
            element.value = SAMPLE_VALUES[0];
            document.body.appendChild(element);

            const cardElements = element.shadowRoot.querySelectorAll(
                '.slds-visual-picker'
            );
            expect(cardElements.length).toBe(SAMPLE_VALUES.length);

            const checkedElement = element.shadowRoot.querySelector(
                `[data-id="${SAMPLE_VALUES[0]}"]`
            );
            expect(checkedElement.value).toBe(SAMPLE_VALUES[0]);
        });
    });

    describe('events', () => {
        it('fires a FlowAttributeChangeEvent when selection changes', () => {
            // Create initial element
            const element = createElement('c-quick-choice', {
                is: QuickChoice
            });
            element.displayMode = 'cards';
            element.inputSource = 'list';
            element.choiceValues = SAMPLE_VALUES;
            document.body.appendChild(element);

            const mockEventHandler = jest.fn();
            element.addEventListener(
                FlowAttributeChangeEventName,
                mockEventHandler
            );

            const radioElement = element.shadowRoot.querySelector('input');
            radioElement.click();

            // Return a promise to wait for any asynchronous DOM updates. Jest
            // will automatically wait for the Promise chain to complete before
            // ending the test and fail the test if the promise rejects.
            return Promise.resolve().then(() => {
                // Check if flow attribute change event has been fired
                expect(mockEventHandler).toHaveBeenCalled();
                expect(
                    mockEventHandler.mock.calls[0][0].detail.attributeName
                ).toBe('value');
                expect(
                    mockEventHandler.mock.calls[0][0].detail.attributeValue
                ).toBe(SAMPLE_VALUES[0]);
            });
        });
    });

    describe('validation', () => {
        it('validate when required value is present', () => {
            // Create initial element
            const element = createElement('c-quick-choice', {
                is: QuickChoice
            });
            element.required = true;
            element.displayMode = 'picklist';
            element.inputSource = 'list';
            element.choiceValues = SAMPLE_VALUES;
            element.value = SAMPLE_VALUES[0];
            document.body.appendChild(element);

            const validation = element.validate();

            expect(validation.isValid).toBeTruthy();
        });

        it('fails to validate when required value is missing', () => {
            // Create initial element
            const element = createElement('c-quick-choice', {
                is: QuickChoice
            });
            element.required = true;
            element.displayMode = 'picklist';
            element.inputSource = 'list';
            element.choiceValues = SAMPLE_VALUES;
            document.body.appendChild(element);

            const validation = element.validate();

            expect(validation.isValid).toBeFalsy();
        });
    });

    describe('@wire getPicklistValues data', () => {
        it('calls wire with default record type', () => {
            // Create initial element
            const element = createElement('c-quick-choice', {
                is: QuickChoice
            });
            element.displayMode = 'picklist';
            element.inputSource = 'picklist';
            element.qualifiedPicklistFieldName = SAMPLE_PICKLIST_FIELD_NAME;
            document.body.appendChild(element);

            // Return a promise to wait for any asynchronous DOM updates. Jest
            // will automatically wait for the Promise chain to complete before
            // ending the test and fail the test if the promise rejects.
            return Promise.resolve().then(() => {
                // Get the config of the last wire call
                const config = getPicklistValuesAdapter.getLastConfig();

                // Inspect filter parameters
                expect(config).not.toBe(null);
                expect(config.recordTypeId).toBe(MASTER_RECORD_TYPE_ID);
                expect(config.fieldApiName).toBe(SAMPLE_PICKLIST_FIELD_NAME);
            });
        });

        it('calls wire with specific record type', () => {
            // Create initial element
            const element = createElement('c-quick-choice', {
                is: QuickChoice
            });
            element.displayMode = 'picklist';
            element.inputSource = 'picklist';
            element.qualifiedPicklistFieldName = SAMPLE_PICKLIST_FIELD_NAME;
            element.recordTypeId = MOCK_RECORD_TYPE_ID;
            document.body.appendChild(element);

            // Return a promise to wait for any asynchronous DOM updates. Jest
            // will automatically wait for the Promise chain to complete before
            // ending the test and fail the test if the promise rejects.
            return Promise.resolve().then(() => {
                // Get the config of the last wire call
                const config = getPicklistValuesAdapter.getLastConfig();

                // Inspect filter parameters
                expect(config).not.toBe(null);
                expect(config.recordTypeId).toBe(MOCK_RECORD_TYPE_ID);
                expect(config.fieldApiName).toBe(SAMPLE_PICKLIST_FIELD_NAME);
            });
        });
    });

    it('is accessible in picklist mode', () => {
        const element = createElement('c-quick-choice', {
            is: QuickChoice
        });

        element.displayMode = 'picklist';
        element.inputSource = 'list';
        element.choiceValues = SAMPLE_VALUES;
        document.body.appendChild(element);

        return Promise.resolve().then(() => expect(element).toBeAccessible());
    });

    it('is accessible in radio mode', () => {
        const element = createElement('c-quick-choice', {
            is: QuickChoice
        });

        element.displayMode = 'radio';
        element.inputSource = 'list';
        element.choiceValues = SAMPLE_VALUES;
        document.body.appendChild(element);

        return Promise.resolve().then(() => expect(element).toBeAccessible());
    });

    it('is accessible in cards mode without icons', () => {
        const element = createElement('c-quick-choice', {
            is: QuickChoice
        });

        element.required = true;
        element.displayMode = 'cards';
        element.inputSource = 'list';
        element.choiceValues = SAMPLE_VALUES;
        document.body.appendChild(element);

        return Promise.resolve().then(() => expect(element).toBeAccessible());
    });

    it('is accessible in cards mode with icons', () => {
        const element = createElement('c-quick-choice', {
            is: QuickChoice
        });

        element.required = true;
        element.displayMode = 'cards';
        element.inputSource = 'list';
        element.choiceValues = SAMPLE_VALUES;
        element.choiceIcons = SAMPLE_ICONS;
        document.body.appendChild(element);

        return Promise.resolve().then(() => expect(element).toBeAccessible());
    });
});
