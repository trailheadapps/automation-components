global class ExecuteSOQLQuery {
    /**
     * Executes a SOQL query
     * Inputs:
     *   String query
     * Outputs:
     *   List<SObject> records
     */
    @InvocableMethod(label='Executes a SOQL query' category='Data')
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
        List<SObject> records = Database.query(input.query);
        // Return output
        OutputParameters output = new OutputParameters();
        output.records = records;
        return output;
    }

    /**
     * Wrapper class for input parameters
     */
    global class InputParameters {
        @InvocableVariable(required=true)
        global String query;
    }

    /**
     * Wrapper class for output parameters
     */
    global class OutputParameters {
        @InvocableVariable
        public List<SObject> records;
    }
}
