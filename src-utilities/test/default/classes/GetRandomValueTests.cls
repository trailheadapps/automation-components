@isTest(isParallel=true)
global class GetRandomValueTests {
    @isTest
    global static void bulkInvoke_works_with_number_no_range() {
        GetRandomValue.InputParameters input = new GetRandomValue.InputParameters();
        input.randomType = GetRandomValue.TYPE_NUMBER;
        List<GetRandomValue.InputParameters> inputs = new List<GetRandomValue.InputParameters>{
            input
        };

        List<GetRandomValue.OutputParameters> outputs = GetRandomValue.bulkInvoke(
            inputs
        );

        System.assertEquals(1, outputs.size());
        GetRandomValue.OutputParameters output = outputs[0];
        System.assert(output.randomNumber >= 0);
        System.assert(output.randomNumber < 1);
    }

    @isTest
    global static void bulkInvoke_works_with_number_min_only() {
        GetRandomValue.InputParameters input = new GetRandomValue.InputParameters();
        input.randomType = GetRandomValue.TYPE_NUMBER;
        input.minNumber = 666;
        List<GetRandomValue.InputParameters> inputs = new List<GetRandomValue.InputParameters>{
            input
        };

        List<GetRandomValue.OutputParameters> outputs = GetRandomValue.bulkInvoke(
            inputs
        );

        System.assertEquals(1, outputs.size());
        GetRandomValue.OutputParameters output = outputs[0];
        System.assert(output.randomNumber >= 666);
    }

    @isTest
    global static void bulkInvoke_works_with_number_max_only() {
        GetRandomValue.InputParameters input = new GetRandomValue.InputParameters();
        input.randomType = GetRandomValue.TYPE_NUMBER;
        input.maxNumber = 666;
        List<GetRandomValue.InputParameters> inputs = new List<GetRandomValue.InputParameters>{
            input
        };

        List<GetRandomValue.OutputParameters> outputs = GetRandomValue.bulkInvoke(
            inputs
        );

        System.assertEquals(1, outputs.size());
        GetRandomValue.OutputParameters output = outputs[0];
        System.assert(output.randomNumber >= 0);
        System.assert(output.randomNumber < 666);
    }

    @isTest
    global static void bulkInvoke_works_with_number_min_and_max() {
        GetRandomValue.InputParameters input = new GetRandomValue.InputParameters();
        input.randomType = GetRandomValue.TYPE_NUMBER;
        input.minNumber = 3;
        input.maxNumber = 4;
        List<GetRandomValue.InputParameters> inputs = new List<GetRandomValue.InputParameters>{
            input
        };

        List<GetRandomValue.OutputParameters> outputs = GetRandomValue.bulkInvoke(
            inputs
        );

        System.assertEquals(1, outputs.size());
        GetRandomValue.OutputParameters output = outputs[0];
        System.assert(output.randomNumber >= 3);
        System.assert(output.randomNumber < 4);
    }

    @isTest
    global static void bulkInvoke_works_with_boolean() {
        GetRandomValue.InputParameters input = new GetRandomValue.InputParameters();
        input.randomType = GetRandomValue.TYPE_BOOLEAN;
        List<GetRandomValue.InputParameters> inputs = new List<GetRandomValue.InputParameters>{
            input
        };

        List<GetRandomValue.OutputParameters> outputs = GetRandomValue.bulkInvoke(
            inputs
        );

        System.assertEquals(1, outputs.size());
        GetRandomValue.OutputParameters output = outputs[0];
        System.assertNotEquals(null, output.randomBoolean);
    }

    @isTest
    global static void bulkInvoke_fails_when_invalid_type() {
        GetRandomValue.InputParameters input = new GetRandomValue.InputParameters();
        input.randomType = 'invalidType';
        List<GetRandomValue.InputParameters> inputs = new List<GetRandomValue.InputParameters>{
            input
        };

        try {
            GetRandomValue.bulkInvoke(inputs);
            System.assert(false, 'Expected InvocableException');
        } catch (GetRandomValue.InvocableException e) {
            System.assertEquals(
                'Unsupported type: invalidType',
                e.getMessage()
            );
        }
    }
}
