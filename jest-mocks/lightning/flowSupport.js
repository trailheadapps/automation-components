export const FlowAttributeChangeEventName = 'lightning__flowattributechange';

export class FlowAttributeChangeEvent extends CustomEvent {
    constructor(attributeName, attributeValue) {
        super(FlowAttributeChangeEventName, {
            composed: true,
            cancelable: true,
            bubbles: true,
            detail: {
                attributeName,
                attributeValue
            }
        });
    }
}
