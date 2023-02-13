@isTest(isParallel=true)
global class ParseCsvAsStringListTests {
    private static final String CSV = 'one, two , three';
    private static final String DSV = 'one. two . three';
    private static final String[] ITEMS_TRIMMED = new List<String>{
        'one',
        'two',
        'three'
    };
    private static final String[] ITEMS_UNTRIMMED = new List<String>{
        'one',
        ' two ',
        ' three'
    };

    @isTest
    global static void bulkInvoke_works_with_default_params() {
        ParseCsvAsStringList.InputParameters input = new ParseCsvAsStringList.InputParameters();
        input.csvString = CSV;
        List<ParseCsvAsStringList.InputParameters> inputs = new List<ParseCsvAsStringList.InputParameters>{
            input
        };

        List<ParseCsvAsStringList.OutputParameters> outputs = ParseCsvAsStringList.bulkInvoke(
            inputs
        );

        Assert.areEqual(1, outputs.size());
        ParseCsvAsStringList.OutputParameters output = outputs[0];
        String[] strings = output.strings;
        Assert.areEqual(ITEMS_TRIMMED.size(), strings.size());
        for (Integer i = 0; i < ITEMS_TRIMMED.size(); i++) {
            Assert.areEqual(ITEMS_TRIMMED[i], strings[i]);
        }
    }

    @isTest
    global static void bulkInvoke_works_with_dot_separator() {
        ParseCsvAsStringList.InputParameters input = new ParseCsvAsStringList.InputParameters();
        input.csvString = DSV;
        input.separator = '\\.';
        List<ParseCsvAsStringList.InputParameters> inputs = new List<ParseCsvAsStringList.InputParameters>{
            input
        };

        List<ParseCsvAsStringList.OutputParameters> outputs = ParseCsvAsStringList.bulkInvoke(
            inputs
        );

        Assert.areEqual(1, outputs.size());
        ParseCsvAsStringList.OutputParameters output = outputs[0];
        String[] strings = output.strings;
        Assert.areEqual(ITEMS_TRIMMED.size(), strings.size());
        for (Integer i = 0; i < ITEMS_TRIMMED.size(); i++) {
            Assert.areEqual(ITEMS_TRIMMED[i], strings[i]);
        }
    }

    @isTest
    global static void bulkInvoke_works_without_trimming() {
        ParseCsvAsStringList.InputParameters input = new ParseCsvAsStringList.InputParameters();
        input.csvString = CSV;
        input.trimValues = false;
        List<ParseCsvAsStringList.InputParameters> inputs = new List<ParseCsvAsStringList.InputParameters>{
            input
        };

        List<ParseCsvAsStringList.OutputParameters> outputs = ParseCsvAsStringList.bulkInvoke(
            inputs
        );

        Assert.areEqual(1, outputs.size());
        ParseCsvAsStringList.OutputParameters output = outputs[0];
        String[] strings = output.strings;
        Assert.areEqual(ITEMS_UNTRIMMED.size(), strings.size());
        for (Integer i = 0; i < ITEMS_UNTRIMMED.size(); i++) {
            Assert.areEqual(ITEMS_UNTRIMMED[i], strings[i]);
        }
    }
}
