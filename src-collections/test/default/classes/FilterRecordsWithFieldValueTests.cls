@isTest(isParallel=true)
global class FilterRecordsWithFieldValueTests {
    @isTest
    global static void bulkInvoke_works() {
        FilterRecordsWithFieldValue.InputParameters input = new FilterRecordsWithFieldValue.InputParameters();
        input.collection = SampleDataFactory.SAMPLE_ACCOUNTS;
        input.fieldName = 'Name';
        input.fieldValue = SampleDataFactory.ACCOUNT_NAME + 1;
        List<FilterRecordsWithFieldValue.InputParameters> inputs = new List<FilterRecordsWithFieldValue.InputParameters>{
            input
        };

        List<FilterRecordsWithFieldValue.OutputParameters> outputs = FilterRecordsWithFieldValue.bulkInvoke(
            inputs
        );

        Assert.areEqual(inputs.size(), outputs.size());
        Assert.areEqual(1, outputs[0].collection.size());
        Account acc = (Account) outputs[0].collection[0];
        Assert.areEqual(SampleDataFactory.ACCOUNT_NAME + 1, acc.Name);
        Assert.areEqual(1, outputs[0].filteredRecordCount);
        Assert.areEqual(2, outputs[0].totalRecordCount);
        Assert.areEqual(1, outputs[0].filteredRecordCount);
    }
}
