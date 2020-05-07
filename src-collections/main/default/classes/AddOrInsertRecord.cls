global with sharing class AddOrInsertRecord {
    /**
     * Adds or inserts a record in a list
     * Inputs:
     *   List<SObject> collection
     *   SObject record
     *   Integer index (optional)
     * Outputs:
     *   List<SObject> collection
     */
    @InvocableMethod(
        label='Adds or inserts a record in a list'
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
        // Get inputs and clone collection
        List<SObject> collection = input.collection.clone();
        SObject record = input.record;
        Integer index = input.index;
        // Add or insert record
        if (index == null || index >= collection.size()) {
            collection.add(record);
        } else {
            collection.add(index, record);
        }
        // Return output
        OutputParameters output = new OutputParameters();
        output.collection = collection;
        return output;
    }

    /**
     * Wrapper class for input parameters
     */
    global class InputParameters {
        @InvocableVariable(required=true)
        global List<SObject> collection;
        @InvocableVariable(required=true)
        global SObject record;
        @InvocableVariable
        global Integer index;
    }

    /**
     * Wrapper class for output parameters
     */
    global class OutputParameters {
        @InvocableVariable
        global List<SObject> collection;
    }
}
