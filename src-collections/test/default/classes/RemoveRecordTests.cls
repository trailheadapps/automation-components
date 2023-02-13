@isTest(isParallel=true)
global class RemoveRecordTests {
    private final static Integer REMOVE_INDEX = 1;

    @isTest
    global static void bulkInvoke_works() {
        RemoveRecord.InputParameters input = new RemoveRecord.InputParameters();
        input.collection = SampleDataFactory.SAMPLE_ACCOUNTS;
        input.index = REMOVE_INDEX;
        List<RemoveRecord.InputParameters> inputs = new List<RemoveRecord.InputParameters>{
            input
        };

        List<RemoveRecord.OutputParameters> outputs = RemoveRecord.bulkInvoke(
            inputs
        );

        Assert.areEqual(inputs.size(), outputs.size());
        Assert.areEqual(
            SampleDataFactory.SAMPLE_ACCOUNTS.size() - 1,
            outputs[0].collection.size()
        );
        Account acc = (Account) outputs[0].collection[0];
        Assert.areEqual(SampleDataFactory.ACCOUNT_NAME + 1, acc.Name);
    }
}
