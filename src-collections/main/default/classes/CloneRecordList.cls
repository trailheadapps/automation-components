global with sharing class CloneRecordList {
    /**
     * Clones a list of records
     * Inputs:
     *   List<SObject> collection
     * Outputs:
     *   List<SObject> collection
     */
    @InvocableMethod(label='Clones a list of records' category='Collections')
    global static List<OutputParameters> bulkInvoke(
        List<InputParameters> inputs
    ) {
        List<OutputParameters> outputs = new List<OutputParameters>();
        for (InputParameters input : inputs) {
            OutputParameters output = new OutputParameters();
            output.collection = input.collection.clone();
            outputs.add(output);
        }
        return outputs;
    }

    /**
     * Wrapper class for input parameters
     */
    global class InputParameters {
        @InvocableVariable(required=true)
        global List<SObject> collection;
    }

    /**
     * Wrapper class for output parameters
     */
    global class OutputParameters {
        @InvocableVariable
        global List<SObject> collection;
    }
}
