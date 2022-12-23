@isTest(isParallel=true)
global class JoinRecordListsTests {
    private final static Integer INDEX = 1;

    @isTest
    global static void bulkInvoke_works() {
        JoinRecordLists.InputParameters input = new JoinRecordLists.InputParameters();
        input.collection1 = SampleDataFactory.SAMPLE_ACCOUNTS;
        input.collection2 = SampleDataFactory.SAMPLE_ACCOUNTS2;
        List<JoinRecordLists.InputParameters> inputs = new List<JoinRecordLists.InputParameters>{
            input
        };

        List<JoinRecordLists.OutputParameters> outputs = JoinRecordLists.bulkInvoke(
            inputs
        );

        Integer totalRecords =
            SampleDataFactory.SAMPLE_ACCOUNTS.size() +
            SampleDataFactory.SAMPLE_ACCOUNTS2.size();
        Assert.areEqual(inputs.size(), outputs.size());
        Assert.areEqual(outputs[0].collection.size(), totalRecords);
        Account acc = (Account) outputs[0].collection[2];
        Assert.areEqual(SampleDataFactory.ACCOUNT_NAME + 3, acc.Name);
    }
}
