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

        System.assertEquals(inputs.size(), outputs.size());
        List<Account> dedupedList = outputs[0].collection;
        System.assertEquals(
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
        System.assertEquals(2, dedupedList.size());
        System.assertEquals(accounts[0].Name, dedupedList[0].Name);
        System.assertEquals(accounts[2].Name, dedupedList[1].Name);
    }

    @isTest
    global static void invoke_fails_with_unknown_field() {
        DedupeRecordList.InputParameters input = new DedupeRecordList.InputParameters();
        input.collection = SampleDataFactory.SAMPLE_ACCOUNTS;
        input.fieldName = 'Unkown';

        try {
            DedupeRecordList.invoke(input);
            System.assert(false, 'Expected InvocableException');
        } catch (DedupeRecordList.InvocableException e) {
            System.assert(e.getMessage().contains('Failed to read'));
        }
    }
}
