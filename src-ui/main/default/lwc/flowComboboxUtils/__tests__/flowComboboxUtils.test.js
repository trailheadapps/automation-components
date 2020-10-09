import {
    DEFAULTS,
    formatValue,
    isReference,
    getDataType,
    removeFormatting
} from 'c/flowComboboxUtils';

const MOCK_FORMATTED = '{!myVar}';
const MOCK_UNFORMATTED = 'myVar';

describe('c-flow-combobox-utils', () => {
    afterEach(() => {
        // Prevent data saved on mocks from leaking between tests
        jest.clearAllMocks();
    });

    it('formats value when reference is detected', () => {
        const formatted = formatValue(MOCK_FORMATTED);
        expect(formatted).toBe(MOCK_FORMATTED);
    });

    it('formats value when reference is specified', () => {
        const formatted = formatValue(
            MOCK_UNFORMATTED,
            DEFAULTS.TYPE_REFERENCE
        );
        expect(formatted).toBe(MOCK_FORMATTED);
    });

    it('formats value when not a reference', () => {
        const formatted = formatValue(MOCK_UNFORMATTED, DEFAULTS.TYPE_STRING);
        expect(formatted).toBe(MOCK_UNFORMATTED);
    });

    it('removes formatting with formatted value', () => {
        const formatted = removeFormatting(MOCK_FORMATTED);
        expect(formatted).toBe(MOCK_UNFORMATTED);
    });

    it('removes formatting with unformatted value', () => {
        const formatted = removeFormatting(MOCK_UNFORMATTED);
        expect(formatted).toBe(MOCK_UNFORMATTED);
    });

    it('removes formatting with no value', () => {
        const formatted = removeFormatting(null);
        expect(formatted).toBeNull();
    });

    it('gets data type with unformatted value', () => {
        const formatted = getDataType(MOCK_UNFORMATTED);
        expect(formatted).toBe(DEFAULTS.TYPE_STRING);
    });

    it('gets data type with formatted value', () => {
        const formatted = getDataType(MOCK_FORMATTED);
        expect(formatted).toBe(DEFAULTS.TYPE_REFERENCE);
    });

    it('is reference with formatted value', () => {
        const isRef = isReference(MOCK_FORMATTED);
        expect(isRef).toBeTruthy();
    });

    it('is reference with unformatted value', () => {
        const isRef = isReference(MOCK_UNFORMATTED);
        expect(isRef).toBeFalsy();
    });

    it('is reference with no value', () => {
        const isRef = isReference(null);
        expect(isRef).toBeFalsy();
    });
});
