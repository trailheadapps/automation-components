global with sharing class UpdateRecordListWithMap {
    /**
     * Updates a record list based on a map
     * Inputs:
     *   List<SObject> collection
     *   String keyValuePairs - Map of new field values in JSON format: { "Rating" : "Hot", "NumberOfEmployees": 1000 }
     * Outputs:
     *   List<SObject> collection
     */
    @InvocableMethod(
        label='Updates a record list based on a map'
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
        // Get inputs and parse keys value pairs
        List<SObject> collection = input.collection;
        Map<String, Object> keyValuePairs;
        try {
            keyValuePairs = (Map<String, Object>) JSON.deserializeUntyped(
                input.keyValuePairs
            );
        } catch (Exception e) {
            throw new InvalidKeyValuePairsException(
                'Failed to parse key value pairs "' +
                    input.keyValuePairs +
                    '" JSON: ' +
                    e.getMessage()
            );
        }

        // Update collection
        Set<String> updateableFields = keyValuePairs.keySet();
        for (SObject record : collection) {
            for (String updateableField : updateableFields) {
                record.put(updateableField, keyValuePairs.get(updateableField));
            }
        }

        // Return output
        OutputParameters output = new OutputParameters();
        output.collection = collection;
        return output;
    }

    global class InvalidKeyValuePairsException extends Exception {
    }

    /**
     * Wrapper class for input parameters
     */
    global class InputParameters {
        @InvocableVariable(required=true)
        global List<SObject> collection;
        @InvocableVariable(required=true)
        global String keyValuePairs;
    }

    /**
     * Wrapper class for output parameters
     */
    global class OutputParameters {
        @InvocableVariable
        global List<SObject> collection;
    }
}
