@isTest(isParallel=true)
global class DedupeRecordListTests {
    @isTest
    global static void bulkInvoke_works_with_unique_values() {
        DedupeRecordList.InputParameters input = new DedupeRecordList.InputParameters();
        input.collection = SampleDataFactory.SAMPLE_ACCOUNTS;
        input.fieldName = 'Name';
        List<DedupeRecordList.InputParameters> inputs = new List<DedupeRecordList.InputParameters>{
            input
        };

        List<DedupeRecordList.OutputParameters> outputs = DedupeRecordList.bulkInvoke(
            inputs
        );

        Assert.areEqual(inputs.size(), outputs.size());
        List<Account> dedupedList = outputs[0].collection;
        Assert.areEqual(
            SampleDataFactory.SAMPLE_ACCOUNTS.size(),
            dedupedList.size()
        );
    }

    @isTest
    global static void invoke_works_with_duplicates() {
        List<Account> accounts = new List<Account>{
            new Account(Name = 'a1', TickerSymbol = 'A'),
            new Account(Name = 'a2', TickerSymbol = 'A'),
            new Account(Name = 'a3', TickerSymbol = 'B')
        };
        DedupeRecordList.InputParameters input = new DedupeRecordList.InputParameters();
        input.collection = accounts;
        input.fieldName = 'TickerSymbol';

        DedupeRecordList.OutputParameters output = DedupeRecordList.invoke(
            input
        );

        List<Account> dedupedList = output.collection;
        Assert.areEqual(2, dedupedList.size());
        Assert.areEqual(accounts[0].Name, dedupedList[0].Name);
        Assert.areEqual(accounts[2].Name, dedupedList[1].Name);
    }

    @isTest
    global static void invoke_fails_with_unknown_field() {
        DedupeRecordList.InputParameters input = new DedupeRecordList.InputParameters();
        input.collection = SampleDataFactory.SAMPLE_ACCOUNTS;
        input.fieldName = 'Unkown';

        try {
            DedupeRecordList.invoke(input);
            Assert.fail('Expected InvocableException');
        } catch (DedupeRecordList.InvocableException e) {
            Assert.isTrue(e.getMessage().contains('Failed to read'));
        }
    }
}
