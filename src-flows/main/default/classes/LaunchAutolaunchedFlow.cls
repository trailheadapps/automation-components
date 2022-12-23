global class LaunchAutolaunchedFlow {
    /**
     * Launches an Autolaunched Flow with up to 3 parameters
     * Inputs:
     *   String flowApiName
     *   String namespace
     *   String param1Name
     *   String param1Value
     *   String param2Name
     *   String param2Value
     *   String param3Name
     *   String param3Value
     * Outputs:
     *   Boolean isSuccess
     *   String errorMessage
     */
    @InvocableMethod(label='Launches an Autolauched Flow' category='Flows')
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
        try {
            // Prepare flow parameters
            Map<String, String> flowParams = new Map<String, String>();
            generateFlowParam(
                input.param1Name,
                input.param1Value,
                1,
                flowParams
            );
            generateFlowParam(
                input.param2Name,
                input.param2Value,
                2,
                flowParams
            );
            generateFlowParam(
                input.param3Name,
                input.param3Value,
                3,
                flowParams
            );
            // Start flow interview
            if (!Test.isRunningTest()) {
                Flow.Interview newInterview = Flow.Interview.createInterview(
                    input.namespace,
                    input.flowApiName,
                    flowParams
                );
                newInterview.start();
            }
            output.isSuccess = true;
        } catch (Exception e) {
            output.isSuccess = false;
            output.errorMessage = e.getMessage();
        }
        return output;
    }

    private static void generateFlowParam(
        String name,
        String value,
        Integer index,
        Map<String, String> flowParams
    ) {
        // If name or value is present but the other is null, throw error
        if (name != null && value == null) {
            throw new InvocableException(
                'Parameter ' + index + ' does not have a value assigned'
            );
        } else if (name == null && value != null) {
            throw new InvocableException(
                'You did not specify a name for parameter ' + index
            );
        }
        // If neither are present, skip parameter
        if (name == null && value == null) {
            return;
        }
        // Add parameter to list
        flowParams.put(name, value);
    }

    global class InvocableException extends Exception {
    }

    /**
     * Wrapper class for input parameters
     */
    global class InputParameters {
        @InvocableVariable(label='Flow API Name' required=true)
        global String flowApiName;
        @InvocableVariable
        global String namespace;
        @InvocableVariable
        public String param1Name;
        @InvocableVariable
        public String param1Value;
        @InvocableVariable
        public String param2Name;
        @InvocableVariable
        public String param2Value;
        @InvocableVariable
        public String param3Name;
        @InvocableVariable
        public String param3Value;
    }

    /**
     * Wrapper class for output parameters
     */
    global class OutputParameters {
        @InvocableVariable
        global Boolean isSuccess;
        @InvocableVariable
        global String errorMessage;
    }
}
