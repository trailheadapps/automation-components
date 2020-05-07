global class GenerateFlowLink {
    /**
     * Generates a Flow start link with up to 3 parameters.
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
     *   String flowLink
     */
    @InvocableMethod(
        label='Generates a Flow start link with up to 3 parameters'
        category='Flows'
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
        // Build flow base URL
        String flowLink = Url.getOrgDomainUrl().toExternalForm() + '/flow/';
        if (!String.isBlank(input.namespace)) {
            flowLink += input.namespace + '/';
        }
        flowLink += input.flowApiName;
        // Prepare flow parameters
        Map<String, String> flowParams = new Map<String, String>();
        generateFlowParam(input.param1Name, input.param1Value, 1, flowParams);
        generateFlowParam(input.param2Name, input.param2Value, 2, flowParams);
        generateFlowParam(input.param3Name, input.param3Value, 3, flowParams);
        // Build flow URL with parameters
        System.PageReference pageReference = new System.PageReference(flowLink);
        pageReference.getParameters().putAll(flowParams);
        flowLink = pageReference.getUrl();
        // Return output
        OutputParameters output = new OutputParameters();
        output.flowLink = flowLink;
        return output;
    }

    private static void generateFlowParam(
        String name,
        String value,
        Integer index,
        Map<String, String> flowParams
    ) {
        // If name or value is present but the other is null, throw error
        // If name or value is present but the other is null, throw error
        if (name != null && value == null) {
            throw new InvocableException(
                'Parameter ' +
                index +
                ' does not have a value assigned'
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
        global String flowLink;
    }
}
