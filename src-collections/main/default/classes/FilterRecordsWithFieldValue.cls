global with sharing class FilterRecordsWithFieldValue {
    /**
     * Filters a list of records with a field matching a value
     * Inputs:
     *   List<SObject> collection
     *   String fieldName
     *   String fieldValue
     * Outputs:
     *   List<SObject> collection
     *   Integer totalRecordCount
     *   Integer filteredRecordCount
     */
    @InvocableMethod(
        label='Filters a list of records with a field matching a value'
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
        String targetFieldValue = input.fieldValue;
        // Filter records
        List<SObject> filteredCollection = new List<SObject>();
        for (SObject record : collection) {
            String fieldValue = String.valueOf(record.get(fieldName));
            if (fieldValue == targetFieldValue) {
                filteredCollection.add(record);
            }
        }
        // Return output
        OutputParameters output = new OutputParameters();
        output.collection = filteredCollection;
        output.totalRecordCount = collection.size();
        output.filteredRecordCount = filteredCollection.size();
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
        @InvocableVariable(required=true)
        global String fieldValue;
    }

    /**
     * Wrapper class for output parameters
     */
    global class OutputParameters {
        @InvocableVariable
        global List<SObject> collection;
        @InvocableVariable
        global Integer totalRecordCount;
        @InvocableVariable
        global Integer filteredRecordCount;
    }
}
