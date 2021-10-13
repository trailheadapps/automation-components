@isTest(isParallel=true)
global class AggregateRecordListTests {
    @isTest
    global static void bulkInvoke_works_with_sum() {
        AggregateRecordList.InputParameters input = getInput('sum');
        List<AggregateRecordList.InputParameters> inputs = new List<AggregateRecordList.InputParameters>{
            input
        };

        List<AggregateRecordList.OutputParameters> outputs = AggregateRecordList.bulkInvoke(
            inputs
        );

        System.assertEquals(inputs.size(), outputs.size());
        System.assertEquals(
            SampleDataFactory.GLOBAL_EMPLOYEE_COUNT,
            outputs[0].decimalResult
        );
        System.assertEquals(
            String.valueOf(SampleDataFactory.GLOBAL_EMPLOYEE_COUNT),
            outputs[0].stringResult
        );
    }

    @isTest
    global static void invoke_works_with_average() {
        AggregateRecordList.InputParameters input = getInput('average');

        AggregateRecordList.OutputParameters output = AggregateRecordList.invoke(
            input
        );

        System.assertEquals(
            SampleDataFactory.GLOBAL_EMPLOYEE_AVERAGE,
            output.decimalResult
        );
    }

    @isTest
    global static void invoke_works_with_average_and_empty_collection() {
        AggregateRecordList.InputParameters input = new AggregateRecordList.InputParameters();
        input.collection = new List<Account>();
        input.fieldName = 'NumberOfEmployees';
        input.operation = 'average';

        AggregateRecordList.OutputParameters output = AggregateRecordList.invoke(
            input
        );

        System.assertEquals(0, output.decimalResult);
    }

    @isTest
    global static void invoke_works_with_min() {
        AggregateRecordList.InputParameters input = getInput('min');

        AggregateRecordList.OutputParameters output = AggregateRecordList.invoke(
            input
        );

        System.assertEquals(
            SampleDataFactory.GLOBAL_EMPLOYEE_MIN,
            output.decimalResult
        );
    }

    @isTest
    global static void invoke_works_with_max() {
        AggregateRecordList.InputParameters input = getInput('max');
        input.collection = SampleDataFactory.SAMPLE_ACCOUNTS2;

        AggregateRecordList.OutputParameters output = AggregateRecordList.invoke(
            input
        );

        System.assertEquals(
            SampleDataFactory.GLOBAL_EMPLOYEE_MAX,
            output.decimalResult
        );
    }

    @isTest
    global static void invoke_works_with_null_values_with_default() {
        AggregateRecordList.InputParameters input = getInput('sum');
        input.collection.add(new Account(Name = 'account3'));
        input.defaultValueForNullFields = 100;

        AggregateRecordList.OutputParameters output = AggregateRecordList.invoke(
            input
        );

        System.assertEquals(
            SampleDataFactory.GLOBAL_EMPLOYEE_COUNT + 100,
            output.decimalResult
        );
    }

    @isTest
    global static void invoke_fails_with_null_values_without_default() {
        AggregateRecordList.InputParameters input = getInput('sum');
        input.collection.add(new Account(Name = 'account3'));

        try {
            AggregateRecordList.invoke(input);
            System.assert(false, 'Expected InvocableException');
        } catch (AggregateRecordList.InvocableException e) {
            System.assert(e.getMessage().contains('No default value'));
        }
    }

    @isTest
    global static void invoke_fails_with_unsupported_operation() {
        AggregateRecordList.InputParameters input = getInput('unsupported');

        try {
            AggregateRecordList.invoke(input);
            System.assert(false, 'Expected InvocableException');
        } catch (AggregateRecordList.InvocableException e) {
            System.assert(e.getMessage().contains('Unsupported operation'));
        }
    }

    @isTest
    global static void invoke_fails_with_non_decimal_field() {
        AggregateRecordList.InputParameters input = new AggregateRecordList.InputParameters();
        input.collection = SampleDataFactory.SAMPLE_ACCOUNTS;
        input.fieldName = 'Name';
        input.operation = 'sum';

        try {
            AggregateRecordList.invoke(input);
            System.assert(false, 'Expected InvocableException');
        } catch (AggregateRecordList.InvocableException e) {
            System.assert(e.getMessage().contains('Failed to convert Name'));
        }
    }

    static AggregateRecordList.InputParameters getInput(String operation) {
        AggregateRecordList.InputParameters input = new AggregateRecordList.InputParameters();
        input.collection = SampleDataFactory.SAMPLE_ACCOUNTS;
        input.fieldName = 'NumberOfEmployees';
        input.operation = operation;
        return input;
    }
}
