global with sharing class GetRecordAtIndex {
    /**
     * Gets a record at a specific index in a list
     * Inputs:
     *   List<SObject> collection
     *   Integer index
     * Outputs:
     *   SObject record
     */
    @InvocableMethod(
        label='Gets a record at a specific index in a list'
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
        OutputParameters output = new OutputParameters();
        output.record = input.collection[input.index];
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
        global SObject record;
    }
}
