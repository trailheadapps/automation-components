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
        // Return output
        OutputParameters output = new OutputParameters();
        output.values = values;
        return output;
    }

    /**
     * Wrapper class for input parameters
     */
    global class InputParameters {
        @InvocableVariable(required=true)
        global List<SObject> collection;
        @InvocableVariable(required=true)
        global String fieldName;
    }

    /**
     * Wrapper class for output parameters
     */
    global class OutputParameters {
        global OutputParameters() {
            values = new List<String>();
        }
        @InvocableVariable
        global List<String> values;
    }
}
