@isTest(isParallel=true)
global class AddOrInsertRecordTests {
    private final static Integer INSERT_INDEX = 1;

    @isTest
    global static void bulkInvoke_add_works() {
        AddOrInsertRecord.InputParameters input = new AddOrInsertRecord.InputParameters();
        input.collection = SampleDataFactory.SAMPLE_ACCOUNTS;
        input.record = new Account(Name = SampleDataFactory.ACCOUNT_NAME);
        List<AddOrInsertRecord.InputParameters> inputs = new List<AddOrInsertRecord.InputParameters>{
            input
        };

        List<AddOrInsertRecord.OutputParameters> outputs = AddOrInsertRecord.bulkInvoke(
            inputs
        );

        System.assertEquals(inputs.size(), outputs.size());
        System.assertEquals(
            SampleDataFactory.SAMPLE_ACCOUNTS.size() + 1,
            outputs[0].collection.size()
        );
        Account acc = (Account) outputs[0]
            .collection[SampleDataFactory.SAMPLE_ACCOUNTS.size()];
        System.assertEquals(SampleDataFactory.ACCOUNT_NAME, acc.Name);
    }

    @isTest
    global static void bulkInvoke_insert_works() {
        AddOrInsertRecord.InputParameters input = new AddOrInsertRecord.InputParameters();
        input.collection = SampleDataFactory.SAMPLE_ACCOUNTS;
        input.record = new Account(Name = SampleDataFactory.ACCOUNT_NAME);
        input.index = INSERT_INDEX;
        List<AddOrInsertRecord.InputParameters> inputs = new List<AddOrInsertRecord.InputParameters>{
            input
        };

        List<AddOrInsertRecord.OutputParameters> outputs = AddOrInsertRecord.bulkInvoke(
            inputs
        );

        System.assertEquals(inputs.size(), outputs.size());
        System.assertEquals(
            SampleDataFactory.SAMPLE_ACCOUNTS.size() + 1,
            outputs[0].collection.size()
        );
        Account acc = (Account) outputs[0].collection[INSERT_INDEX];
        System.assertEquals(SampleDataFactory.ACCOUNT_NAME, acc.Name);
    }
}
