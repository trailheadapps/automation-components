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
        System.assertEquals(' _S0S_ ', context.outputString);
        System.assertEquals(origin, context.replacements.get('_S0S_'));
        System.assertEquals(value, context.referencesString.get('_S0S_'));
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
        System.assertEquals(' _B0B_ ', context.outputString);
        System.assertEquals(origin, context.replacements.get('_B0B_'));
        System.assertEquals(value, context.referencesBoolean.get('_B0B_'));
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
        System.assertEquals(' _D0D_ ', context.outputString);
        System.assertEquals(origin, context.replacements.get('_D0D_'));
        System.assertEquals(value, context.referencesDecimal.get('_D0D_'));
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
        System.assertEquals(' _T0T_ ', context.outputString);
        System.assertEquals(origin, context.replacements.get('_T0T_'));
        System.assertEquals(value, context.referencesDateTime.get('_T0T_'));
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
        System.assertEquals(' _N0N_ ', context.outputString);
        System.assertEquals(origin, context.replacements.get('_N0N_'));
        System.assertEquals('_N0N_', context.referencesNull.iterator().next());
    }
}
