@isTest(isParallel=true)
global class GetRecordAtIndexTests {
    private final static Integer INDEX = 1;

    @isTest
    global static void bulkInvoke_works() {
        GetRecordAtIndex.InputParameters input = new GetRecordAtIndex.InputParameters();
        input.collection = SampleDataFactory.SAMPLE_ACCOUNTS;
        input.index = INDEX;
        List<GetRecordAtIndex.InputParameters> inputs = new List<GetRecordAtIndex.InputParameters>{
            input
        };

        List<GetRecordAtIndex.OutputParameters> outputs = GetRecordAtIndex.bulkInvoke(
            inputs
        );

        System.assertEquals(inputs.size(), outputs.size());
        Account acc = (Account) outputs[0].record;
        System.assertEquals(SampleDataFactory.ACCOUNT_NAME + 2, acc.Name);
    }
}
