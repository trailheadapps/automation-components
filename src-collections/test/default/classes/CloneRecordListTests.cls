@isTest(isParallel=true)
global class CloneRecordListTests {
    @isTest
    global static void bulkInvoke_works() {
        CloneRecordList.InputParameters input = new CloneRecordList.InputParameters();
        input.collection = SampleDataFactory.SAMPLE_ACCOUNTS;
        List<CloneRecordList.InputParameters> inputs = new List<CloneRecordList.InputParameters>{
            input
        };

        List<CloneRecordList.OutputParameters> outputs = CloneRecordList.bulkInvoke(
            inputs
        );

        Assert.areEqual(inputs.size(), outputs.size());
        Assert.areEqual(
            SampleDataFactory.SAMPLE_ACCOUNTS.size(),
            outputs[0].collection.size()
        );
        Account inputAcc = (Account) inputs[0].collection[0];
        Account outputAcc = (Account) outputs[0].collection[0];
        Assert.areEqual(inputAcc.Name, outputAcc.Name);
    }
}
