@isTest(isParallel=true)
global class LaunchAutolaunchedFlowTests {
    private static final String FLOW_API_NAME = 'MockFlow';
    private static final String FLOW_INPUT_OPERATION = 'operation';
    private static final String FLOW_INPUT_A = 'inputA';
    private static final String FLOW_INPUT_B = 'inputB';
    private static final String FLOW_OUTPUT = 'output';

    @isTest
    global static void bulkInvoke_works_with_no_params() {
        LaunchAutolaunchedFlow.InputParameters input = new LaunchAutolaunchedFlow.InputParameters();
        input.flowApiName = FLOW_API_NAME;
        List<LaunchAutolaunchedFlow.InputParameters> inputs = new List<LaunchAutolaunchedFlow.InputParameters>{
            input
        };

        List<LaunchAutolaunchedFlow.OutputParameters> outputs = LaunchAutolaunchedFlow.bulkInvoke(
            inputs
        );

        System.assertEquals(1, outputs.size());
        LaunchAutolaunchedFlow.OutputParameters output = outputs[0];
        System.assertEquals(null, output.errorMessage);
        System.assert(output.isSuccess);
    }

    @isTest
    global static void bulkInvoke_works_with_three_params() {
        LaunchAutolaunchedFlow.InputParameters input = new LaunchAutolaunchedFlow.InputParameters();
        input.flowApiName = FLOW_API_NAME;
        input.param1Name = FLOW_INPUT_OPERATION;
        input.param1Value = 'substract';
        input.param2Name = FLOW_INPUT_A;
        input.param2Value = '8';
        input.param3Name = FLOW_INPUT_B;
        input.param3Value = '2';
        List<LaunchAutolaunchedFlow.InputParameters> inputs = new List<LaunchAutolaunchedFlow.InputParameters>{
            input
        };

        List<LaunchAutolaunchedFlow.OutputParameters> outputs = LaunchAutolaunchedFlow.bulkInvoke(
            inputs
        );

        System.assertEquals(1, outputs.size());
        LaunchAutolaunchedFlow.OutputParameters output = outputs[0];
        System.assertEquals(null, output.errorMessage);
        System.assert(output.isSuccess);
    }

    @isTest
    global static void bulkInvoke_fails_when_param_name_is_missing() {
        LaunchAutolaunchedFlow.InputParameters input = new LaunchAutolaunchedFlow.InputParameters();
        input.flowApiName = FLOW_API_NAME;
        input.param1Value = 'value';
        List<LaunchAutolaunchedFlow.InputParameters> inputs = new List<LaunchAutolaunchedFlow.InputParameters>{
            input
        };

        List<LaunchAutolaunchedFlow.OutputParameters> outputs = LaunchAutolaunchedFlow.bulkInvoke(
            inputs
        );

        System.assertEquals(1, outputs.size());
        LaunchAutolaunchedFlow.OutputParameters output = outputs[0];
        System.assert(!output.isSuccess);
        System.assert(
            output.errorMessage.contains(
                'You did not specify a name for parameter'
            )
        );
    }

    @isTest
    global static void bulkInvoke_fails_when_param_value_is_missing() {
        LaunchAutolaunchedFlow.InputParameters input = new LaunchAutolaunchedFlow.InputParameters();
        input.flowApiName = FLOW_API_NAME;
        input.param1Name = FLOW_INPUT_OPERATION;
        List<LaunchAutolaunchedFlow.InputParameters> inputs = new List<LaunchAutolaunchedFlow.InputParameters>{
            input
        };

        List<LaunchAutolaunchedFlow.OutputParameters> outputs = LaunchAutolaunchedFlow.bulkInvoke(
            inputs
        );

        System.assertEquals(1, outputs.size());
        LaunchAutolaunchedFlow.OutputParameters output = outputs[0];
        System.assert(!output.isSuccess);
        System.assert(
            output.errorMessage.contains('does not have a value assigned')
        );
    }
}
