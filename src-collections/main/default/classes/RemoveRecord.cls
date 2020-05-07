global with sharing class RemoveRecord {
    /**
     * Removes the record at a specific index in a list
     * Inputs:
     *   List<SObject> collection
     *   Integer index
     * Outputs:
     *   List<SObject> collection
     */
    @InvocableMethod(
        label='Removes the record at a specific index in a list'
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
        Integer index = input.index;
        // Removes record
        collection.remove(index);
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
