@isTest(isParallel=true)
global class RegExpsParserContextTests {
    @isTest
    global static void replace_works_with_string() {
        final String origin = 'testString';
        final String value = 'testValue';

        RegExps.ParserContext context = new RegExps.ParserContext(
            ' ' + origin + ' ',
            'outputType',
            1
        );
        context.replace(origin, value);
        Assert.areEqual(' _S0S_ ', context.outputString);
        Assert.areEqual(origin, context.replacements.get('_S0S_'));
        Assert.areEqual(value, context.referencesString.get('_S0S_'));
    }

    @isTest
    global static void replace_works_with_boolean() {
        final String origin = 'testBoolean';
        final Boolean value = false;

        RegExps.ParserContext context = new RegExps.ParserContext(
            ' ' + origin + ' ',
            'outputType',
            1
        );
        context.replace(origin, value);
        Assert.areEqual(' _B0B_ ', context.outputString);
        Assert.areEqual(origin, context.replacements.get('_B0B_'));
        Assert.areEqual(value, context.referencesBoolean.get('_B0B_'));
    }

    @isTest
    global static void replace_works_with_decimal() {
        final String origin = 'testDecimal';
        final Decimal value = 3.14;

        RegExps.ParserContext context = new RegExps.ParserContext(
            ' ' + origin + ' ',
            'outputType',
            1
        );
        context.replace(origin, value);
        Assert.areEqual(' _D0D_ ', context.outputString);
        Assert.areEqual(origin, context.replacements.get('_D0D_'));
        Assert.areEqual(value, context.referencesDecimal.get('_D0D_'));
    }

    @isTest
    global static void replace_works_with_datetime() {
        final String origin = 'testDateTime';
        final DateTime value = DateTime.now();

        RegExps.ParserContext context = new RegExps.ParserContext(
            ' ' + origin + ' ',
            'outputType',
            1
        );
        context.replace(origin, value);
        Assert.areEqual(' _T0T_ ', context.outputString);
        Assert.areEqual(origin, context.replacements.get('_T0T_'));
        Assert.areEqual(value, context.referencesDateTime.get('_T0T_'));
    }

    @isTest
    global static void replace_works_with_null() {
        final String origin = 'testNull';

        RegExps.ParserContext context = new RegExps.ParserContext(
            ' ' + origin + ' ',
            'outputType',
            1
        );
        context.replace(origin);
        Assert.areEqual(' _N0N_ ', context.outputString);
        Assert.areEqual(origin, context.replacements.get('_N0N_'));
        Assert.areEqual('_N0N_', context.referencesNull.iterator().next());
    }
}
