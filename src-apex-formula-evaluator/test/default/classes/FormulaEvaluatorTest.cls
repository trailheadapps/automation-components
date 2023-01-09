@isTest
global with sharing class FormulaEvaluatorTest {
    @IsTest
    static void parseFormulaTest() {
        Opportunity opp = new Opportunity();
        opp.Name = 'Test Opportunity';
        opp.Amount = 15000.05;
        opp.CloseDate = Date.today().addDays(-30);
        opp.StageName = 'Prospecting';
        opp.IsPrivate = false;

        insert opp;

        List<ContextWrapper> context = new List<ContextWrapper>();
        context.add(new ContextWrapper('$Record', opp.Id));
        context.add(new ContextWrapper('itemOne', '30'));
        context.add(new ContextWrapper('itemTwo', '45'));
        String stringContext = JSON.serialize(context);

        Assert.areEqual(
            '1',
            FormulaEvaluator.parseFormula('POW(1,2)', stringContext)
        );
        Assert.areEqual(
            '2',
            FormulaEvaluator.parseFormula('MAX(1,2)', stringContext)
        );
        Assert.areEqual(
            '1',
            FormulaEvaluator.parseFormula('MIN(1,2)', stringContext)
        );
        Assert.areEqual(
            '1',
            FormulaEvaluator.parseFormula('MOD(1,2)', stringContext)
        );
        Assert.areEqual(
            '1',
            FormulaEvaluator.parseFormula('ABS(1)', stringContext)
        );
        Assert.areEqual(
            '1',
            FormulaEvaluator.parseFormula('FLOOR(1)', stringContext)
        );
        Assert.areEqual(
            '1',
            FormulaEvaluator.parseFormula('SQRT(1)', stringContext)
        );
        Assert.areEqual(
            '0',
            FormulaEvaluator.parseFormula('ACOS(1)', stringContext)
        );
        Assert.areEqual(
            '2',
            FormulaEvaluator.parseFormula('ASIN(1)', stringContext)
        );
        Assert.areEqual(
            '1',
            FormulaEvaluator.parseFormula('ATAN(1)', stringContext)
        );
        Assert.areEqual(
            '1',
            FormulaEvaluator.parseFormula('COS(1)', stringContext)
        );
        Assert.areEqual(
            '1',
            FormulaEvaluator.parseFormula('SIN(1)', stringContext)
        );
        Assert.areEqual(
            '2',
            FormulaEvaluator.parseFormula('TAN(1)', stringContext)
        );
        Assert.areEqual(
            '2',
            FormulaEvaluator.parseFormula('COSH(1)', stringContext)
        );
        Assert.areEqual(
            '1',
            FormulaEvaluator.parseFormula('SINH(1)', stringContext)
        );
        Assert.areEqual(
            '1',
            FormulaEvaluator.parseFormula('TANH(1)', stringContext)
        );
        Assert.areEqual(
            '3',
            FormulaEvaluator.parseFormula('EXP(1)', stringContext)
        );
        Assert.areEqual(
            '0',
            FormulaEvaluator.parseFormula('LOG(1)', stringContext)
        );
        Assert.areEqual(
            '0',
            FormulaEvaluator.parseFormula('LOG10(1)', stringContext)
        );
        Assert.areEqual(
            '1',
            FormulaEvaluator.parseFormula('SIGNUM(1)', stringContext)
        );
        Assert.areEqual(
            '1',
            FormulaEvaluator.parseFormula('RINT(1)', stringContext)
        );
        Assert.areEqual(
            '1',
            FormulaEvaluator.parseFormula('INTEGER(1)', stringContext)
        );
        Assert.areEqual(
            'true',
            FormulaEvaluator.parseFormula('BOOLEAN(true)', stringContext)
        );
        Assert.areEqual(
            null,
            FormulaEvaluator.parseFormula('TEXT(text)', stringContext)
        );
        Assert.areEqual(
            '1.1',
            FormulaEvaluator.parseFormula('DECIMAL("1.1")', stringContext)
        );
        Assert.areEqual(
            null,
            FormulaEvaluator.parseFormula('INTEGER("1.1")', stringContext)
        );
        Assert.areEqual(
            '2019-12-26 00:00:00',
            FormulaEvaluator.parseFormula(
                'DATETIME("2019-12-26T00:00:00")',
                stringContext
            )
        );
        Assert.areEqual(
            '2019-12-26 00:00:00',
            FormulaEvaluator.parseFormula('DATE(2019,12,26)', stringContext)
        );
        Assert.areEqual(
            null,
            FormulaEvaluator.parseFormula('DATE(2019,"12",26)', stringContext)
        );
        Assert.areEqual(
            null,
            FormulaEvaluator.parseFormula('DATE("2019",12,26)', stringContext)
        );
        Assert.areEqual(
            null,
            FormulaEvaluator.parseFormula('DATE(2019,12,"26")', stringContext)
        );
        Assert.areEqual(
            '2019-12-26 00:00:00',
            FormulaEvaluator.parseFormula(
                'DATETIME(2019,12,26,0,0,0)',
                stringContext
            )
        );
        Assert.areEqual(
            null,
            FormulaEvaluator.parseFormula(
                'DATETIME("2019",12,26,0,0,0)',
                stringContext
            )
        );
        Assert.areEqual(
            null,
            FormulaEvaluator.parseFormula(
                'DATETIME(2019,"12",26,0,0,0)',
                stringContext
            )
        );
        Assert.areEqual(
            null,
            FormulaEvaluator.parseFormula(
                'DATETIME(2019,12,"26",0,0,0)',
                stringContext
            )
        );
        Assert.areEqual(
            '2019-12-26 00:00:00',
            FormulaEvaluator.parseFormula(
                'DATETIME(2019,12,26,"0",0,0)',
                stringContext
            )
        );
        Assert.areEqual(
            '2019-12-26 00:00:00',
            FormulaEvaluator.parseFormula(
                'DATETIME(2019,12,26,0,"0",0)',
                stringContext
            )
        );
        Assert.areEqual(
            '2019-12-26 00:00:00',
            FormulaEvaluator.parseFormula(
                'DATETIME(2019,12,26,0,0,"0")',
                stringContext
            )
        );
        Assert.areEqual(
            '25',
            FormulaEvaluator.parseFormula(
                'DAY(DATETIME(2019,12,26,0,0,0))',
                stringContext
            )
        );
        Assert.areEqual(
            '12',
            FormulaEvaluator.parseFormula(
                'MONTH(DATETIME(2019,12,26,0,0,0))',
                stringContext
            )
        );
        Assert.areEqual(
            '2019',
            FormulaEvaluator.parseFormula(
                'YEAR(DATETIME(2019,12,26,0,0,0))',
                stringContext
            )
        );
        Assert.areEqual(
            '16',
            FormulaEvaluator.parseFormula(
                'HOURS(DATETIME(2019,12,26,0,0,0))',
                stringContext
            )
        );
        Assert.areEqual(
            '0',
            FormulaEvaluator.parseFormula(
                'MINUTES(DATETIME(2019,12,26,0,0,0))',
                stringContext
            )
        );
        Assert.areEqual(
            '0',
            FormulaEvaluator.parseFormula(
                'SECONDS(DATETIME(2019,12,26,0,0,0))',
                stringContext
            )
        );
        Assert.areEqual(
            '2019-12-27 00:00:00',
            FormulaEvaluator.parseFormula(
                'ADDDAYS(DATETIME(2019,12,26,0,0,0),1)',
                stringContext
            )
        );
        Assert.areEqual(
            '2020-01-26 00:00:00',
            FormulaEvaluator.parseFormula(
                'ADDMONTHS(DATETIME(2019,12,26,0,0,0),1)',
                stringContext
            )
        );
        Assert.areEqual(
            '2020-12-26 00:00:00',
            FormulaEvaluator.parseFormula(
                'ADDYEARS(DATETIME(2019,12,26,0,0,0),1)',
                stringContext
            )
        );
        Assert.areEqual(
            '2019-12-26 01:00:00',
            FormulaEvaluator.parseFormula(
                'ADDHOURS(DATETIME(2019,12,26,0,0,0),1)',
                stringContext
            )
        );
        Assert.areEqual(
            '2019-12-26 00:01:00',
            FormulaEvaluator.parseFormula(
                'ADDMINUTES(DATETIME(2019,12,26,0,0,0),1)',
                stringContext
            )
        );
        Assert.areEqual(
            '2019-12-26 00:00:01',
            FormulaEvaluator.parseFormula(
                'ADDSECONDS(DATETIME(2019,12,26,0,0,0),1)',
                stringContext
            )
        );
        Assert.areEqual(
            String.valueOf(opp.Id),
            FormulaEvaluator.parseFormula(
                'CONVERTID("' + opp.Id + '")',
                stringContext
            )
        );
        Assert.areEqual(
            null,
            FormulaEvaluator.parseFormula('CONVERTID("error")', stringContext)
        );
        Assert.areEqual(
            '5',
            FormulaEvaluator.parseFormula('LEN("error")', stringContext)
        );
        Assert.areEqual(
            'false',
            FormulaEvaluator.parseFormula('ISBLANK("error")', stringContext)
        );
        Assert.areEqual(
            'error',
            FormulaEvaluator.parseFormula(
                'SUBSTRING("error","1","text")',
                stringContext
            )
        );
        Assert.areEqual(
            'err',
            FormulaEvaluator.parseFormula('LEFT("error",3)', stringContext)
        );
        Assert.areEqual(
            'or',
            FormulaEvaluator.parseFormula('RIGHT("error",2)', stringContext)
        );
        Assert.areEqual(
            'true',
            FormulaEvaluator.parseFormula(
                'ISPICKVAL("error","error")',
                stringContext
            )
        );
        Assert.areEqual(
            null,
            FormulaEvaluator.parseFormula(
                'CASE("error","error",1,"success",2)',
                stringContext
            )
        );
        Assert.areEqual(
            '1',
            FormulaEvaluator.parseFormula(
                'CASE("error","error",1,"success",2,4)',
                stringContext
            )
        );
        Assert.areEqual(
            'true',
            FormulaEvaluator.parseFormula(
                'CASE("error","error",BOOLEAN("true"),"success",BOOLEAN("true"),BOOLEAN("true"))',
                stringContext
            )
        );
        Assert.areEqual(
            'false',
            FormulaEvaluator.parseFormula('NOT(BOOLEAN("true"))', stringContext)
        );
        Assert.areEqual(
            'true',
            FormulaEvaluator.parseFormula(
                'XOR(BOOLEAN("true"),BOOLEAN("false"))',
                stringContext
            )
        );
        Assert.areEqual(
            'false',
            FormulaEvaluator.parseFormula(
                '(BOOLEAN("true"))&&(BOOLEAN("false"))',
                stringContext
            )
        );
        Assert.areEqual(
            'true',
            FormulaEvaluator.parseFormula(
                '(BOOLEAN("true"))||(BOOLEAN("false"))',
                stringContext
            )
        );
        Assert.areEqual(
            'true',
            FormulaEvaluator.parseFormula(
                '(BOOLEAN("true"))^^(BOOLEAN("false"))',
                stringContext
            )
        );
        Assert.areEqual(
            'false',
            FormulaEvaluator.parseFormula('!(BOOLEAN("true"))', stringContext)
        );
        Assert.areEqual(
            'Test Opportunity',
            FormulaEvaluator.parseFormula('$Record.Name', stringContext),
            'Formula include record'
        );
        Assert.areEqual(
            'Test OpportunityTest',
            FormulaEvaluator.parseFormula(
                '$Record.Name + "Test"',
                stringContext
            ),
            'Formula include record and text'
        );
        Assert.areEqual(
            'Test Opportunity15000.05',
            FormulaEvaluator.parseFormula(
                '$Record.Name + TEXT($Record.Amount)',
                stringContext
            ),
            'Formula include 2 fields from record'
        );
        Assert.areEqual(
            '30',
            FormulaEvaluator.parseFormula('itemOne', stringContext),
            'Formula include static field'
        );
        Assert.areEqual(
            '45',
            FormulaEvaluator.parseFormula('itemTwo', stringContext),
            'Formula include static field'
        );
        Assert.areEqual(
            'false',
            FormulaEvaluator.parseFormula('itemOne > itemTwo', stringContext),
            'Formula include static fields and operator'
        );
        Assert.areEqual(
            'true',
            FormulaEvaluator.parseFormula('itemOne < itemTwo', stringContext),
            'Formula include static fields and operator'
        );
        Assert.areEqual(
            'false',
            FormulaEvaluator.parseFormula('AND(true,false)', stringContext),
            'Formula include "AND" condition'
        );
        Assert.areEqual(
            'true',
            FormulaEvaluator.parseFormula('AND(true,true)', stringContext),
            'Formula include "AND" condition'
        );
        Assert.areEqual(
            'true',
            FormulaEvaluator.parseFormula(
                'IF(15 > 10,true,false)',
                stringContext
            ),
            'Formula include "IF" condition'
        );
        Assert.areEqual(
            '2019-01-01 11:00:15',
            FormulaEvaluator.parseFormula(
                'DATETIME(2019,01,01,11,00,15)',
                stringContext
            ),
            'Formula include datetime'
        );
        Assert.areEqual(
            System.today(),
            Date.valueOf(
                FormulaEvaluator.parseFormula('$TODAY', stringContext)
            ),
            'Formula include $TODAY'
        );
        Assert.isNotNull(
            FormulaEvaluator.parseFormula('$PI', stringContext),
            'Formula include $PI'
        );
        Assert.isNotNull(
            FormulaEvaluator.parseFormula('$E', stringContext),
            'Formula include $E'
        );
        Assert.isNotNull(
            FormulaEvaluator.parseFormula('$RANDOM', stringContext),
            'Formula include $RANDOM'
        );
        Assert.isNotNull(
            FormulaEvaluator.parseFormula('$NOW', stringContext),
            'Formula include $NOW'
        );
        Assert.isNotNull(
            FormulaEvaluator.parseFormula('$Organization.Name', stringContext),
            'Formula include $Organization'
        );
        Assert.areEqual(
            UserInfo.getName(),
            FormulaEvaluator.parseFormula('$User.Name', stringContext),
            'Formula include $User'
        );
        Assert.areEqual(
            UserInfo.getProfileId(),
            FormulaEvaluator.parseFormula('$Profile.Id', stringContext),
            'Formula include $Profile'
        );
        Assert.areEqual(
            null,
            FormulaEvaluator.parseFormula('2019 / test', stringContext),
            'Formula include wrong value'
        );
        Assert.areEqual(
            '20',
            FormulaEvaluator.parseFormula('40 / 2', stringContext),
            'Formula include /'
        );
        Assert.areEqual(
            '180',
            FormulaEvaluator.parseFormula('10 * 18', stringContext),
            'Formula include *'
        );
        Assert.areEqual(
            '18.00',
            FormulaEvaluator.parseFormula('FLOOR(18.12)', stringContext),
            'Formula include FLOOR()'
        );
        Assert.areEqual(
            '256',
            FormulaEvaluator.parseFormula('TEXT(256)', stringContext),
            'Formula convert Integer to String'
        );

        Assert.areEqual(
            '0',
            FormulaEvaluator.parseFormula(
                'FIND($Record.Name,"Test")',
                stringContext
            ),
            'Formula include FIND'
        );
        Assert.areEqual(
            'true',
            FormulaEvaluator.parseFormula(
                'CONTAINS($Record.Name,"Test")',
                stringContext
            ),
            'Formula include CONTAINS'
        );
        Assert.areEqual(
            opp.Name.toLowerCase(),
            FormulaEvaluator.parseFormula('LOWER($Record.Name)', stringContext),
            'Formula LOWER'
        );
        Assert.areEqual(
            opp.Name.toUpperCase(),
            FormulaEvaluator.parseFormula('UPPER($Record.Name)', stringContext),
            'Formula UPPER'
        );
        Assert.areEqual(
            'Test',
            FormulaEvaluator.parseFormula(
                'MID($Record.Name,0,4)',
                stringContext
            ),
            'Formula include MID'
        );
        Assert.areEqual(
            'Test',
            FormulaEvaluator.parseFormula(
                'SUBSTRING($Record.Name,0,4)',
                stringContext
            ),
            'Formula include SUBSTRING'
        );
        Assert.areEqual(
            opp.Name.replace('Test', 'REPLACEMENT'),
            FormulaEvaluator.parseFormula(
                'SUBSTITUTE($Record.Name,"Test","REPLACEMENT")',
                stringContext
            ),
            'Formula SUBSTITUTE'
        );
        Assert.areEqual(
            'TEST  .',
            FormulaEvaluator.parseFormula('TRIM("  TEST  . ")', stringContext),
            'Formula TRIM'
        );
        Assert.areEqual(
            '100',
            FormulaEvaluator.parseFormula('VALUE("100")', stringContext),
            'Formula VALUE'
        );
        Assert.areEqual(
            'Test Opportunity15000.05',
            FormulaEvaluator.parseFormula(
                'CONCATENATE($Record.Name,TEXT($Record.Amount))',
                stringContext
            ),
            'Formula CONCATENATE'
        );
        Assert.areEqual(
            '$Opportunity.Name$Opportunity.Amount',
            FormulaEvaluator.parseFormula(
                'CONCATENATE("$Opportunity.Name","$Opportunity.Amount")',
                stringContext
            ),
            'Formula CONCATENATE "&'
        );
    }

    @isTest
    global static void handleFieldByType_works_with_datetime() {
        String timeString = '2006-5-4 3:2:1';
        String output = FormulaEvaluator.handleFieldByType(
            timeString,
            Schema.DisplayType.DATETIME
        );
        Assert.areEqual('DATETIME(2006,5,4,3,2,1)', output);
    }

    @isTest
    global static void getFieldTypes_works() {
        String objectName = 'Account';
        Set<String> fieldNames = new Set<String>{ 'Name', 'Rating' };
        Map<String, Schema.DisplayType> fieldTypes = FormulaEvaluator.getFieldTypes(
            objectName,
            fieldNames
        );
        Assert.areEqual(Schema.DisplayType.STRING, fieldTypes.get('Name'));
        Assert.areEqual(Schema.DisplayType.PICKLIST, fieldTypes.get('Rating'));
    }

    public class ContextWrapper {
        public String name;
        public String value;

        public ContextWrapper(String name, String value) {
            this.name = name;
            this.value = value;
        }
    }
}
