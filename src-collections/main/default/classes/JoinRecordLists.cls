global with sharing class JoinRecordLists {
    /**
     * Joins two record lists
     * Inputs:
     *   List<SObject> collection1
     *   List<SObject> collection2
     * Outputs:
     *   List<SObject> collection
     */
    @InvocableMethod(label='Joins two record lists' category='Collections')
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
        List<SObject> collection1 = input.collection1;
        List<SObject> collection2 = input.collection2;
        // Join the collections
        List<SObject> jointCollection = new List<SObject>();
        jointCollection.addAll(collection1);
        jointCollection.addAll(collection2);
        // Return output
        OutputParameters output = new OutputParameters();
        output.collection = jointCollection;
        return output;
    }

    /**
     * Wrapper class for input parameters
     */
    global class InputParameters {
        @InvocableVariable(required=true)
        global List<SObject> collection1;
        @InvocableVariable(required=true)
        global List<SObject> collection2;
    }

    /**
     * Wrapper class for output parameters
     */
    global class OutputParameters {
        @InvocableVariable
        global List<SObject> collection;
    }
}
