@isTest(isParallel=true)
global class GenerateFlowLinkTests {
    private static final String FLOW_API_NAME = 'testFlow';
    private static final String FLOW_NAMESPACE = 'ns';
    private static final String FLOW_INPUT_A = 'a';
    private static final String FLOW_INPUT_B = 'b';
    private static final String FLOW_INPUT_C = 'c';

    private static final String URL_NO_PARAMS =
        Url.getOrgDomainUrl().toExternalForm() + '/flow/ns/testFlow';
    private static final String URL_ALL_PARAMS =
        Url.getOrgDomainUrl().toExternalForm() +
        '/flow/ns/testFlow?a=1&b=2&c=3';

    @isTest
    global static void bulkInvoke_works_with_no_params() {
        GenerateFlowLink.InputParameters input = new GenerateFlowLink.InputParameters();
        input.flowApiName = FLOW_API_NAME;
        input.namespace = FLOW_NAMESPACE;
        List<GenerateFlowLink.InputParameters> inputs = new List<GenerateFlowLink.InputParameters>{
            input
        };

        List<GenerateFlowLink.OutputParameters> outputs = GenerateFlowLink.bulkInvoke(
            inputs
        );

        Assert.areEqual(1, outputs.size());
        GenerateFlowLink.OutputParameters output = outputs[0];
        Assert.areEqual(URL_NO_PARAMS, output.flowLink);
    }

    @isTest
    global static void bulkInvoke_works_with_three_params() {
        GenerateFlowLink.InputParameters input = new GenerateFlowLink.InputParameters();
        input.flowApiName = FLOW_API_NAME;
        input.namespace = FLOW_NAMESPACE;
        input.param1Name = FLOW_INPUT_A;
        input.param1Value = '1';
        input.param2Name = FLOW_INPUT_B;
        input.param2Value = '2';
        input.param3Name = FLOW_INPUT_C;
        input.param3Value = '3';
        List<GenerateFlowLink.InputParameters> inputs = new List<GenerateFlowLink.InputParameters>{
            input
        };

        List<GenerateFlowLink.OutputParameters> outputs = GenerateFlowLink.bulkInvoke(
            inputs
        );

        Assert.areEqual(1, outputs.size());
        GenerateFlowLink.OutputParameters output = outputs[0];
        Assert.areEqual(URL_ALL_PARAMS, output.flowLink);
    }

    @isTest
    global static void bulkInvoke_fails_when_param_name_is_missing() {
        GenerateFlowLink.InputParameters input = new GenerateFlowLink.InputParameters();
        input.flowApiName = FLOW_API_NAME;
        input.namespace = FLOW_NAMESPACE;
        input.param1Value = 'value';
        List<GenerateFlowLink.InputParameters> inputs = new List<GenerateFlowLink.InputParameters>{
            input
        };

        try {
            GenerateFlowLink.bulkInvoke(inputs);
            Assert.fail('Expected InvocableException');
        } catch (GenerateFlowLink.InvocableException e) {
            Assert.isTrue(
                e.getMessage()
                    .contains('You did not specify a name for parameter')
            );
        }
    }

    @isTest
    global static void bulkInvoke_fails_when_param_value_is_missing() {
        GenerateFlowLink.InputParameters input = new GenerateFlowLink.InputParameters();
        input.flowApiName = FLOW_API_NAME;
        input.namespace = FLOW_NAMESPACE;
        input.param1Name = FLOW_INPUT_A;
        List<GenerateFlowLink.InputParameters> inputs = new List<GenerateFlowLink.InputParameters>{
            input
        };

        try {
            GenerateFlowLink.bulkInvoke(inputs);
            Assert.fail('Expected InvocableException');
        } catch (GenerateFlowLink.InvocableException e) {
            Assert.isTrue(
                e.getMessage().contains('does not have a value assigned')
            );
        }
    }
}
