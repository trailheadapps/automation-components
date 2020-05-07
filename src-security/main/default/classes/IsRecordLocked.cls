global class IsRecordLocked {
    /**
     * Checks if a record is locked
     * Inputs:
     *   Id recordId
     * Outputs:
     *   Boolean isLocked
     */
    @InvocableMethod(label='Checks if a record is locked' category='Security')
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
        output.isLocked = Approval.isLocked(input.recordId);
        return output;
    }

    /**
     * Wrapper class for input parameters
     */
    global class InputParameters {
        @InvocableVariable(required=true)
        global Id recordId;
    }

    /**
     * Wrapper class for output parameters
     */
    global class OutputParameters {
        @InvocableVariable
        global Boolean isLocked;
    }
}
