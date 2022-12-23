@isTest(isParallel=true)
global class UpdateRecordListWithMapTests {
    private final static String UPDATE_SETTINGS = '{ "NumberOfEmployees" : 1, "Rating" : "Hot" }';

    @isTest
    global static void bulkInvoke_works() {
        UpdateRecordListWithMap.InputParameters input = new UpdateRecordListWithMap.InputParameters();
        input.collection = SampleDataFactory.SAMPLE_ACCOUNTS;
        input.keyValuePairs = UPDATE_SETTINGS;
        List<UpdateRecordListWithMap.InputParameters> inputs = new List<UpdateRecordListWithMap.InputParameters>{
            input
        };

        List<UpdateRecordListWithMap.OutputParameters> outputs = UpdateRecordListWithMap.bulkInvoke(
            inputs
        );

        Assert.areEqual(inputs.size(), outputs.size());
        Assert.areEqual(2, outputs[0].collection.size());
        Account acc = (Account) outputs[0].collection[0];
        Assert.areEqual(SampleDataFactory.ACCOUNT_NAME + 1, acc.Name);
        Assert.areEqual(1, acc.NumberOfEmployees);
        Assert.areEqual('Hot', acc.Rating);
    }

    @isTest
    global static void bulkInvoke_fails_when_invalid_json() {
        UpdateRecordListWithMap.InputParameters input = new UpdateRecordListWithMap.InputParameters();
        input.collection = SampleDataFactory.SAMPLE_ACCOUNTS;
        input.keyValuePairs = 'invalidJSON';
        List<UpdateRecordListWithMap.InputParameters> inputs = new List<UpdateRecordListWithMap.InputParameters>{
            input
        };
        try {
            UpdateRecordListWithMap.bulkInvoke(inputs);
            Assert.fail('Expected InvalidKeyValuePairsException');
        } catch (UpdateRecordListWithMap.InvalidKeyValuePairsException e) {
            Assert.isTrue(e.getMessage().contains('Failed to parse'));
        }
    }
}
