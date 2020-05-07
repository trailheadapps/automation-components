@isTest(isParallel=true)
global class EvaluateFormulaTests {
    private final static String ACCOUNT_NAME = 'Sample account';
    private final static List<Account> SAMPLE_ACCOUNTS = new List<Account>{
        new Account(Name = ACCOUNT_NAME + 1, NumberOfEmployees = 20),
        new Account(Name = ACCOUNT_NAME + 2, NumberOfEmployees = 10)
    };

    private final static String FORMULA =
        '$Record.Name == "' +
        ACCOUNT_NAME +
        1 +
        '"';

    @isTest
    global static void bulkInvoke_works() {
        List<Account> sampleAccounts = SAMPLE_ACCOUNTS;
        insert sampleAccounts;

        List<FormulaEvaluator.ContextWrapper> context = new List<FormulaEvaluator.ContextWrapper>();
        context.add(
            new FormulaEvaluator.ContextWrapper('$Record', sampleAccounts[0].Id)
        );
        String stringContext = JSON.serialize(context);

        EvaluateFormula.InputParameters input = new EvaluateFormula.InputParameters();
        input.formula = FORMULA;
        input.context = stringContext;
        List<EvaluateFormula.InputParameters> inputs = new List<EvaluateFormula.InputParameters>{
            input
        };

        List<EvaluateFormula.OutputParameters> outputs = EvaluateFormula.bulkInvoke(
            inputs
        );

        System.assertEquals(inputs.size(), outputs.size());
        System.assertEquals('true', outputs[0].result);
    }
}
