global with sharing class ExtractStringsFromRecords {
    /**
     * Extracts specific field values as strings from a list of records
     * Inputs:
     *   List<SObject> collection
     *   String fieldName
     * Outputs:
     *   List<String> values
     */
    @InvocableMethod(
        label='Extracts specific field values as strings from a list of records'
        category='Collections'
    )
    global static List<OutputParameters> bulkInvoke(
        List<InputParameters> inputs
    ) {
        List<OutputParameters> outputs = new List<OutputParameters>();
        for (InputParameters input : inputs) {
            outputs.add(invoke(input));
        }
        return outputs;
    }

    private static OutputParameters invoke(InputParameters input) {
        // Get inputs
        List<SObject> collection = input.collection;
        String fieldName = input.fieldName;
        // Extract field values
        List<String> values = new List<String>();
        for (SObject record : collection) {
            String fieldValue = String.valueOf(record.get(fieldName));
            values.add(fieldValue);
        }
        // Remove duplicates
        if (input.removeDuplicates) {
            values = new List<String>(new Set<String>(values));
        }
        // Join values
        String joinedValues = String.join(values, input.joinDelimiter);
        // Return output
        OutputParameters output = new OutputParameters();
        output.values = values;
        output.joinedValues = joinedValues;
        return output;
    }

    /**
     * Wrapper class for input parameters
     */
    global class InputParameters {
        @InvocableVariable(required=true)
        global List<SObject> collection;
        @InvocableVariable(label='Field name' required=true)
        global String fieldName;
        @InvocableVariable(label='Remove duplicates')
        global Boolean removeDuplicates = false;
        @InvocableVariable(label='Join delimiter')
        global String joinDelimiter = ',';
    }

    /**
     * Wrapper class for output parameters
     */
    global class OutputParameters {
        @InvocableVariable
        global List<String> values;
        @InvocableVariable(label='Joined values')
        global String joinedValues;
    }
}
