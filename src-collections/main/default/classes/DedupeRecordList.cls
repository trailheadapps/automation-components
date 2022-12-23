global with sharing class DedupeRecordList {
    /**
     * Builds a list of records with unique field values
     * Inputs:
     *   List<SObject> collection
     *   String fieldName
     * Outputs:
     *   List<SObject> collection
     */
    @InvocableMethod(
        label='Builds a list of records with unique field values'
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

    @TestVisible
    private static OutputParameters invoke(InputParameters input) {
        Map<String, SObject> recordMap = new Map<String, SObject>();
        for (SObject record : input.collection) {
            try {
                String fieldValue = String.valueOf(record.get(input.fieldName));
                if (fieldValue != null && !recordMap.containsKey(fieldValue)) {
                    recordMap.put(fieldValue, record);
                }
            } catch (Exception e) {
                throw new InvocableException(
                    'Failed to read value from ' + input.fieldName + ' field',
                    e
                );
            }
        }
        OutputParameters output = new OutputParameters();
        output.collection = recordMap.values();
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
        @InvocableVariable
        global List<SObject> collection;
    }

    global class InvocableException extends Exception {
    }
}
