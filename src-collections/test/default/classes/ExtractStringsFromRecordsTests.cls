@isTest(isParallel=true)
global class ExtractStringsFromRecordsTests {
    private static final List<Account> SAMPLE_ACCOUNTS = new List<Account>{
        new Account(Name = 'A1', AccountNumber = 'A'),
        new Account(Name = 'A2', AccountNumber = 'A'),
        new Account(Name = 'B1', AccountNumber = 'B')
    };

    private static final List<String> ACCOUNT_NUMBERS = new List<String>{
        'A',
        'A',
        'B'
    };
    private static final List<String> UNIQUE_ACCOUNT_NUMBERS = new List<String>{
        'A',
        'B'
    };
    private static final String DELIMITER = '-TEST-';

    @isTest
    global static void bulkInvoke_works() {
        ExtractStringsFromRecords.InputParameters input = new ExtractStringsFromRecords.InputParameters();
        input.collection = SAMPLE_ACCOUNTS;
        input.fieldName = 'AccountNumber';
        List<ExtractStringsFromRecords.InputParameters> inputs = new List<ExtractStringsFromRecords.InputParameters>{
            input
        };

        List<ExtractStringsFromRecords.OutputParameters> outputs = ExtractStringsFromRecords.bulkInvoke(
            inputs
        );

        System.assertEquals(ACCOUNT_NUMBERS, outputs[0].values);
        System.assertEquals(
            String.join(ACCOUNT_NUMBERS, ','),
            outputs[0].joinedValues
        );
    }

    @isTest
    global static void bulkInvoke_works_without_duplicates() {
        ExtractStringsFromRecords.InputParameters input = new ExtractStringsFromRecords.InputParameters();
        input.collection = SAMPLE_ACCOUNTS;
        input.fieldName = 'AccountNumber';
        input.removeDuplicates = true;
        List<ExtractStringsFromRecords.InputParameters> inputs = new List<ExtractStringsFromRecords.InputParameters>{
            input
        };

        List<ExtractStringsFromRecords.OutputParameters> outputs = ExtractStringsFromRecords.bulkInvoke(
            inputs
        );

        System.assertEquals(UNIQUE_ACCOUNT_NUMBERS, outputs[0].values);
    }

    @isTest
    global static void bulkInvoke_works_with_custom_delimiter() {
        ExtractStringsFromRecords.InputParameters input = new ExtractStringsFromRecords.InputParameters();
        input.collection = SAMPLE_ACCOUNTS;
        input.fieldName = 'AccountNumber';
        input.joinDelimiter = DELIMITER;
        List<ExtractStringsFromRecords.InputParameters> inputs = new List<ExtractStringsFromRecords.InputParameters>{
            input
        };

        List<ExtractStringsFromRecords.OutputParameters> outputs = ExtractStringsFromRecords.bulkInvoke(
            inputs
        );

        System.assertEquals(
            String.join(ACCOUNT_NUMBERS, DELIMITER),
            outputs[0].joinedValues
        );
    }
}
