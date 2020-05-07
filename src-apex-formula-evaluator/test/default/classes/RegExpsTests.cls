@isTest(isParallel=true)
global class RegExpsTests {
    @isTest
    global static void clearParentesis_works_with_all() {
        RegExps.ParserContext context = new RegExps.ParserContext(
            '(_N0N_) OR (_N0N_)',
            'outputType',
            1
        );
        RegExps.clearParentesis(context);
        System.assertEquals('_N0N_ OR _N0N_', context.outputString);

        context = new RegExps.ParserContext(
            '(_D0D_) OR (_D0D_)',
            'outputType',
            1
        );
        RegExps.clearParentesis(context);
        System.assertEquals('_D0D_ OR _D0D_', context.outputString);

        context = new RegExps.ParserContext(
            '(_B0B_) OR (_B1B_)',
            'outputType',
            1
        );
        RegExps.clearParentesis(context);
        System.assertEquals('_B0B_ OR _B1B_', context.outputString);

        context = new RegExps.ParserContext(
            '(_S0S_) OR (_S0S_)',
            'outputType',
            1
        );
        RegExps.clearParentesis(context);
        System.assertEquals('_S0S_ OR _S0S_', context.outputString);

        context = new RegExps.ParserContext(
            '(_T0T_) OR (_T0T_)',
            'outputType',
            1
        );
        RegExps.clearParentesis(context);
        System.assertEquals('_T0T_ OR _T0T_', context.outputString);

        context = new RegExps.ParserContext(
            '(invalid) OR (invalid)',
            'outputType',
            1
        );
        RegExps.clearParentesis(context);
        System.assertEquals('(invalid) OR (invalid)', context.outputString);
    }

    @isTest
    global static void clearParentesis_works_with_types() {
        RegExps.ParserContext context = new RegExps.ParserContext(
            '(_N0N_) OR (_N0N_)',
            'outputType',
            1
        );
        RegExps.clearParentesis(context, 'NULL');
        System.assertEquals('_N0N_ OR _N0N_', context.outputString);

        context = new RegExps.ParserContext(
            '(_D0D_) OR (_D0D_)',
            'outputType',
            1
        );
        RegExps.clearParentesis(context, 'NUMBER');
        System.assertEquals('_D0D_ OR _D0D_', context.outputString);

        context = new RegExps.ParserContext(
            '(_B0B_) OR (_B1B_)',
            'outputType',
            1
        );
        RegExps.clearParentesis(context, 'BOOLEAN');
        System.assertEquals('_B0B_ OR _B1B_', context.outputString);

        context = new RegExps.ParserContext(
            '(_S0S_) OR (_S0S_)',
            'outputType',
            1
        );
        RegExps.clearParentesis(context, 'STRING');
        System.assertEquals('_S0S_ OR _S0S_', context.outputString);

        context = new RegExps.ParserContext(
            '(_T0T_) OR (_T0T_)',
            'outputType',
            1
        );
        RegExps.clearParentesis(context, 'DATETIME');
        System.assertEquals('_T0T_ OR _T0T_', context.outputString);
    }

    @isTest
    global static void wrapParentesis_works_with_all() {
        RegExps.ParserContext context = new RegExps.ParserContext(
            '_N0N_',
            'outputType',
            1
        );
        RegExps.wrapParentesis(context, null);
        System.assertEquals('( _N0N_ )', context.outputString);

        context = new RegExps.ParserContext('_D0D_', 'outputType', 1);
        RegExps.wrapParentesis(context, null);
        System.assertEquals('( _D0D_ )', context.outputString);

        context = new RegExps.ParserContext('_B0B_', 'outputType', 1);
        RegExps.wrapParentesis(context, null);
        System.assertEquals('( _B0B_ )', context.outputString);

        context = new RegExps.ParserContext('_S0S_', 'outputType', 1);
        RegExps.wrapParentesis(context, null);
        System.assertEquals('( _S0S_ )', context.outputString);

        context = new RegExps.ParserContext('_T0T_', 'outputType', 1);
        RegExps.wrapParentesis(context, null);
        System.assertEquals('( _T0T_ )', context.outputString);

        context = new RegExps.ParserContext('invalid', 'outputType', 1);
        RegExps.wrapParentesis(context, null);
        System.assertEquals('invalid', context.outputString);
    }

    @isTest
    global static void wrapParentesis_works_with_types() {
        RegExps.ParserContext context = new RegExps.ParserContext(
            '_N0N_',
            'outputType',
            1
        );
        RegExps.wrapParentesis(context, 'NULL');
        System.assertEquals('( _N0N_ )', context.outputString);

        context = new RegExps.ParserContext('_D0D_', 'outputType', 1);
        RegExps.wrapParentesis(context, 'NUMBER');
        System.assertEquals('( _D0D_ )', context.outputString);

        context = new RegExps.ParserContext('_B0B_', 'outputType', 1);
        RegExps.wrapParentesis(context, 'BOOLEAN');
        System.assertEquals('( _B0B_ )', context.outputString);

        context = new RegExps.ParserContext('_S0S_', 'outputType', 1);
        RegExps.wrapParentesis(context, 'STRING');
        System.assertEquals('( _S0S_ )', context.outputString);

        context = new RegExps.ParserContext('_T0T_', 'outputType', 1);
        RegExps.wrapParentesis(context, 'DATETIME');
        System.assertEquals('( _T0T_ )', context.outputString);
    }

    @isTest
    global static void getValueReferenceType_works() {
        System.assertEquals('NULL', RegExps.getValueReferenceType('N'));
        System.assertEquals('NUMBER', RegExps.getValueReferenceType('D'));
        System.assertEquals('BOOLEAN', RegExps.getValueReferenceType('B'));
        System.assertEquals('STRING', RegExps.getValueReferenceType('S'));
        System.assertEquals('DATETIME', RegExps.getValueReferenceType('T'));
        System.assertEquals('NONE', RegExps.getValueReferenceType(' '));
    }

    @isTest
    global static void iterativePlaceholderDiscover_works_with_null() {
        final String TOKEN = '_N0N_';

        RegExps.ParserContext context = new RegExps.ParserContext(
            ' ',
            'outputType',
            1
        );

        context.referencesNULL.add(TOKEN);
        String output = RegExps.iterativePlaceholderDiscover(TOKEN, context);
        System.assertEquals('NULL', output);
    }

    @isTest
    global static void iterativePlaceholderDiscover_works_with_decimal() {
        final String TOKEN = '_D0D_';
        final Decimal VALUE1 = 1.1;
        final String VALUE2 = '1.2';

        RegExps.ParserContext context = new RegExps.ParserContext(
            ' ',
            'outputType',
            1
        );

        context.referencesDecimal.put(TOKEN, VALUE1);
        String output = RegExps.iterativePlaceholderDiscover(TOKEN, context);
        System.assertEquals(String.valueOf(VALUE1), output);

        context.replacements.put(TOKEN, VALUE2);
        output = RegExps.iterativePlaceholderDiscover(TOKEN, context);
        System.assertEquals(VALUE2, output);
    }

    @isTest
    global static void iterativePlaceholderDiscover_works_with_boolean() {
        final String TOKEN = '_B0B_';
        final Boolean VALUE1 = true;
        final String VALUE2 = 'false';

        RegExps.ParserContext context = new RegExps.ParserContext(
            ' ',
            'outputType',
            1
        );

        context.referencesBoolean.put(TOKEN, VALUE1);
        String output = RegExps.iterativePlaceholderDiscover(TOKEN, context);
        System.assertEquals(String.valueOf(VALUE1), output);

        context.replacements.put(TOKEN, VALUE2);
        output = RegExps.iterativePlaceholderDiscover(TOKEN, context);
        System.assertEquals(VALUE2, output);
    }

    @isTest
    global static void iterativePlaceholderDiscover_works_with_string() {
        final String TOKEN = '_S0S_';
        final String VALUE1 = 'sValue1';
        final String VALUE2 = 'sValue2';

        RegExps.ParserContext context = new RegExps.ParserContext(
            ' ',
            'outputType',
            1
        );

        context.referencesString.put(TOKEN, VALUE1);
        String output = RegExps.iterativePlaceholderDiscover(TOKEN, context);
        System.assertEquals(VALUE1, output);

        context.replacements.put(TOKEN, VALUE2);
        output = RegExps.iterativePlaceholderDiscover(TOKEN, context);
        System.assertEquals(VALUE2, output);
    }

    @isTest
    global static void iterativePlaceholderDiscover_works_with_datetime() {
        final String TOKEN = '_T0T_';
        final DateTime VALUE1 = DateTime.now();
        final String VALUE2 = 'mockDate';

        RegExps.ParserContext context = new RegExps.ParserContext(
            ' ',
            'outputType',
            1
        );

        context.referencesDateTime.put(TOKEN, VALUE1);
        String output = RegExps.iterativePlaceholderDiscover(TOKEN, context);
        System.assertEquals(String.valueOf(VALUE1), output);

        context.replacements.put(TOKEN, VALUE2);
        output = RegExps.iterativePlaceholderDiscover(TOKEN, context);
        System.assertEquals(VALUE2, output);
    }

    @isTest
    global static void iterativePlaceholderDiscover_works_with_unknown_tokens() {
        RegExps.ParserContext context = new RegExps.ParserContext(
            ' ',
            'outputType',
            1
        );
        String output = RegExps.iterativePlaceholderDiscover('_T0T_', context);
        System.assertEquals('_T0T_', output);
    }

    @isTest
    global static void evaluateFlowExpressions_fails_when_return_types_dont_match() {
        try {
            RegExps.ParserContext context = new RegExps.ParserContext(
                'IF(_B0B_, _S0S_, _D1D_)',
                'outputType',
                1
            );
            RegExps.evaluateFlowExpressions(context);
            System.assert(false, 'Expected ExpressionParsingException');
        } catch (RegExps.ExpressionParsingException e) {
            System.assert(e.getMessage().contains('Different return types'));
        }
    }

    @isTest
    global static void evaluateFlowExpressions_works_with_null() {
        RegExps.ParserContext context = new RegExps.ParserContext(
            ' IF ( _B0B_ , _N0N_ , _N1N_ ) ',
            'STRING',
            null
        );

        RegExps.evaluateFlowExpressions(context);

        System.assertEquals(' _N0N_ ', context.outputString);
    }

    @isTest
    global static void evaluateFlowExpressions_works_with_string() {
        final String expression = ' IF ( _B0B_ , _S0S_ , _S1S_ ) ';
        final String value1 = 'yes';
        final String value2 = 'no';

        RegExps.ParserContext context = new RegExps.ParserContext(
            expression,
            'STRING',
            null
        );
        context.referencesBoolean.put('_B0B_', true);
        context.referencesString.put('_S0S_', value1);
        context.referencesString.put('_S1S_', value2);

        RegExps.evaluateFlowExpressions(context);

        System.assertEquals(
            value1,
            context.referencesString.get(context.outputString.trim())
        );

        context = new RegExps.ParserContext(expression, 'STRING', null);
        context.referencesBoolean.put('_B0B_', false);
        context.referencesString.put('_S0S_', value1);
        context.referencesString.put('_S1S_', value2);

        RegExps.evaluateFlowExpressions(context);

        System.assertEquals(
            value2,
            context.referencesString.get(context.outputString.trim())
        );
    }

    @isTest
    global static void evaluateFlowExpressions_works_with_decimal() {
        final String expression = ' IF ( _B0B_ , _D0D_ , _D1D_ ) ';
        final Decimal value1 = 1.1;
        final Decimal value2 = 2.2;

        RegExps.ParserContext context = new RegExps.ParserContext(
            expression,
            'NUMBER',
            null
        );
        context.referencesBoolean.put('_B0B_', true);
        context.referencesDecimal.put('_D0D_', value1);
        context.referencesDecimal.put('_D1D_', value2);

        RegExps.evaluateFlowExpressions(context);

        System.assertEquals(
            value1,
            context.referencesDecimal.get(context.outputString.trim())
        );

        context = new RegExps.ParserContext(expression, 'NUMBER', null);
        context.referencesBoolean.put('_B0B_', false);
        context.referencesDecimal.put('_D0D_', value1);
        context.referencesDecimal.put('_D1D_', value2);

        RegExps.evaluateFlowExpressions(context);

        System.assertEquals(
            value2,
            context.referencesDecimal.get(context.outputString.trim())
        );
    }

    @isTest
    global static void evaluateFlowExpressions_works_with_datetime() {
        final String expression = ' IF ( _B0B_ , _T0T_ , _T1T_ ) ';
        final DateTime value1 = DateTime.now();
        final DateTime value2 = value1.addDays(1);

        RegExps.ParserContext context = new RegExps.ParserContext(
            expression,
            'DATETIME',
            null
        );
        context.referencesBoolean.put('_B0B_', true);
        context.referencesDateTime.put('_T0T_', value1);
        context.referencesDateTime.put('_T1T_', value2);

        RegExps.evaluateFlowExpressions(context);

        System.assertEquals(
            value1,
            context.referencesDateTime.get(context.outputString.trim())
        );

        context = new RegExps.ParserContext(expression, 'DATETIME', null);
        context.referencesBoolean.put('_B0B_', false);
        context.referencesDateTime.put('_T0T_', value1);
        context.referencesDateTime.put('_T1T_', value2);

        RegExps.evaluateFlowExpressions(context);

        System.assertEquals(
            value2,
            context.referencesDateTime.get(context.outputString.trim())
        );
    }
}
