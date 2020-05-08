import { LightningElement, api, wire } from 'lwc';
import { FlowAttributeChangeEvent } from 'lightning/flowSupport';
import { getPicklistValues } from 'lightning/uiObjectInfoApi';
import FORM_FACTOR from '@salesforce/client/formFactor';

// Import component templates
import templateCards from './quickChoiceCards.html';
import templatePicklist from './quickChoicePicklist.html';
import templateRadio from './quickChoiceRadio.html';

const DISPLAY_MODE_CARDS = 'cards';
const DISPLAY_MODE_PICKLIST = 'picklist';
const DISPLAY_MODE_RADIO = 'radio';

const MASTER_RECORD_TYPE_ID = '012000000000000AAA'; // Fallback if recordTypeId is not provided

/**
 * Displays a list of choices to the user in a variety of formats (picklist, radio, cards).
 * Derived from Eric Smith's (https://ericsplayground.wordpress.com/) work
 */
export default class QuickChoice extends LightningElement {
    @api value;
    @api label;
    @api choiceLabels;
    @api choiceValues;
    @api displayMode = 'picklist'; // cards, picklist, radio
    @api inputSource = 'list'; // list, picklist
    @api required = false;

    // Picklist input specific settings
    @api recordTypeId;
    @api qualifiedPicklistFieldName;

    // Cards display specific settings
    @api numberOfColumns; // 1(default) or 2
    @api choiceIcons;

    options = [];
    _recordTypeId;

    render() {
        // Select the appropriate template for current display mode
        switch (this.displayMode.toLowerCase()) {
            case DISPLAY_MODE_CARDS:
                return templateCards;
            case DISPLAY_MODE_PICKLIST:
                return templatePicklist;
            case DISPLAY_MODE_RADIO:
                return templateRadio;
            default:
                throw new Error(
                    `Unsupported display mode for ${this.label}: ${this.displayMode}`
                );
        }
    }

    @wire(getPicklistValues, {
        recordTypeId: '$_recordTypeId',
        fieldApiName: '$qualifiedPicklistFieldName'
    })
    loadPicklistValues({ error, data }) {
        if (error) {
            console.error(
                'getPicklistValues wire service returned error: ',
                JSON.stringify(error)
            );
            throw new Error(
                `Failed to retrieve picklist values for ${this.label}`
            );
        } else if (data) {
            const icons = this.choiceIcons
                ? this.choiceIcons
                : new Array(data.values.length);
            // Load values from picklist field
            let options;
            if (this.isCards()) {
                // Keep labels empty for cards since values === labels
                options = data.values.map((option, index) => ({
                    value: option.value,
                    iconName: icons[index]
                }));
            } else {
                options = data.values.map((option, index) => ({
                    value: option.value,
                    label: option.label,
                    iconName: icons[index]
                }));
            }
            // Add a 'none' option when selection is not required
            if (!this.required) {
                if (this.isCards()) {
                    options.unshift({
                        label: '-- None --',
                        value: '',
                        iconName: 'standard:empty'
                    });
                } else {
                    options.unshift({ label: '-- None --', value: '' });
                }
            }
            this.options = options;
        }
    }

    @api
    validate() {
        // If the component is invalid, return the isValid parameter as false and return an error message.
        if (this.required && !this.value) {
            return {
                isValid: false,
                errorMessage: `Make a selection in '${this.label}' to continue`
            };
        }
        return { isValid: true };
    }

    connectedCallback() {
        const inputSource = this.inputSource
            ? this.inputSource.toLowerCase()
            : undefined;
        switch (inputSource) {
            // Data is provided by user
            case 'list':
                {
                    let labels;
                    if (this.isCards()) {
                        // Use provided labels for cards or keep empty labels
                        labels = this.choiceLabels
                            ? this.choiceLabels
                            : new Array(this.choiceValues.length);
                    } else {
                        // Use values as labels if no labels are provided
                        labels = this.choiceLabels
                            ? this.choiceLabels
                            : this.choiceValues;
                    }
                    const icons = this.choiceIcons
                        ? this.choiceIcons
                        : new Array(this.choiceValues.length);
                    this.options = this.choiceValues.map((value, index) => ({
                        value,
                        label: labels[index],
                        iconName: icons[index]
                    }));
                }
                break;

            // Data is loaded via UI API wire
            case 'picklist':
                this._recordTypeId = this.recordTypeId
                    ? this.recordTypeId
                    : MASTER_RECORD_TYPE_ID;
                break;

            default: {
                const errorMessage = `Invalid input source for '${this.label}': ${this.inputSource}`;
                // eslint-disable-next-line no-alert
                alert(errorMessage);
                throw new Error(errorMessage);
            }
        }
    }

    errorCallback(error, stack) {
        console.error(
            `Sub component of '${this.label}' failed to render: `,
            stack
        );
        console.error(JSON.stringify(error, null, 2));
    }

    renderedCallback() {
        // Select initial card value
        if (this.isCards() && this.value) {
            const selectedCardElement = this.template.querySelector(
                `[data-id="${this.value}"]`
            );
            if (selectedCardElement) {
                selectedCardElement.checked = true;
            }
        }
    }

    handleChange(event) {
        const selectedValue = this.isCards()
            ? event.target.value
            : event.detail.value;
        const attributeChangeEvent = new FlowAttributeChangeEvent(
            'value',
            selectedValue
        );
        this.dispatchEvent(attributeChangeEvent);
    }

    isCards() {
        return this.displayMode.toLowerCase() === DISPLAY_MODE_CARDS;
    }

    get hasIcons() {
        return this.choiceIcons;
    }

    get columnClass() {
        // Force single column display for cards on mobile
        const isDualColumns =
            FORM_FACTOR === 'Small' ? false : this.numberOfColumns;
        return isDualColumns
            ? 'slds-col slds-size_1-of-2 slds-var-m-bottom_x-small'
            : 'slds-col slds-size_1-of-1 slds-var-m-bottom_x-small';
    }
}
