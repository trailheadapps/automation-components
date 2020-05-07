@isTest(isParallel=true)
global class ExtractStringsFromRecordsTests {
    @isTest
    global static void bulkInvoke_works() {
        ExtractStringsFromRecords.InputParameters input = new ExtractStringsFromRecords.InputParameters();
        input.collection = SampleDataFactory.SAMPLE_ACCOUNTS;
        input.fieldName = 'Name';
        List<ExtractStringsFromRecords.InputParameters> inputs = new List<ExtractStringsFromRecords.InputParameters>{
            input
        };

        List<ExtractStringsFromRecords.OutputParameters> outputs = ExtractStringsFromRecords.bulkInvoke(
            inputs
        );

        System.assertEquals(inputs.size(), outputs.size());
        System.assertEquals(
            SampleDataFactory.SAMPLE_ACCOUNTS.size(),
            outputs[0].values.size()
        );
        String value = outputs[0].values[0];
        System.assertEquals(SampleDataFactory.ACCOUNT_NAME + 1, value);
    }
}
