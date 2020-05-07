global class SetRecordLock {
    /**
     * Locks or unlocks a record
     * Inputs:
     *   Id recordId
     *   Boolean isLocked
     * Outputs:
     *   Boolean isSuccess
     *   String errorMessage
     */
    @InvocableMethod(label='Locks or unlocks a record' category='Security')
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
        try {
            if (input.isLocked) {
                Approval.LockResult result = Approval.lock(input.recordId);
                return processResult(result.isSuccess(), result.getErrors());
            } else {
                Approval.UnlockResult result = Approval.unlock(input.recordId);
                return processResult(result.isSuccess(), result.getErrors());
            }
        } catch (Exception e) {
            OutputParameters output = new OutputParameters();
            output.isSuccess = false;
            output.errorMessage = e.getMessage();
            return output;
        }
    }

    @TestVisible
    private static OutputParameters processResult(
        Boolean isSuccess,
        List<Database.Error> errors
    ) {
        OutputParameters output = new OutputParameters();
        output.isSuccess = isSuccess;
        if (!isSuccess) {
            String errorString = '';
            for (Database.Error err : errors) {
                if (errorString.length() > 0) {
                    errorString += '\n';
                }
                errorString +=
                    'Error ' +
                    err.getStatusCode() +
                    ': ' +
                    err.getMessage();
            }
            output.errorMessage = errorString;
        }
        return output;
    }

    /**
     * Wrapper class for input parameters
     */
    global class InputParameters {
        @InvocableVariable(required=true)
        global Id recordId;
        @InvocableVariable
        global Boolean isLocked;
    }

    /**
     * Wrapper class for output parameters
     */
    global class OutputParameters {
        @invocableVariable
        global Boolean isSuccess;
        @invocableVariable
        global String errorMessage;
    }
}
