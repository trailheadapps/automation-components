@isTest(isParallel=true)
global class FormatStringListAsCsvTests {
    private static final String CSV = 'one,two,three';
    private static final String DSV = 'one.two.three';
    private static final String[] STRINGS_VALUES = new List<String>{
        'one',
        'two',
        'three'
    };

    @isTest
    global static void bulkInvoke_works_with_default_params() {
        FormatStringListAsCsv.InputParameters input = new FormatStringListAsCsv.InputParameters();
        input.strings = STRINGS_VALUES;
        List<FormatStringListAsCsv.InputParameters> inputs = new List<FormatStringListAsCsv.InputParameters>{
            input
        };

        List<FormatStringListAsCsv.OutputParameters> outputs = FormatStringListAsCsv.bulkInvoke(
            inputs
        );

        Assert.areEqual(1, outputs.size());
        Assert.areEqual(CSV, outputs[0].csvString);
    }

    @isTest
    global static void bulkInvoke_works_with_dot_separator() {
        FormatStringListAsCsv.InputParameters input = new FormatStringListAsCsv.InputParameters();
        input.strings = STRINGS_VALUES;
        input.separator = '.';
        List<FormatStringListAsCsv.InputParameters> inputs = new List<FormatStringListAsCsv.InputParameters>{
            input
        };

        List<FormatStringListAsCsv.OutputParameters> outputs = FormatStringListAsCsv.bulkInvoke(
            inputs
        );

        Assert.areEqual(1, outputs.size());
        Assert.areEqual(DSV, outputs[0].csvString);
    }
}
