@isTest(isParallel=true)
global class ExecuteSOQLQueryTests {
    @isTest
    global static void bulkInvoke_works() {
        Account acc = new Account(Name = 'Sample');
        insert acc;

        ExecuteSOQLQuery.InputParameters input = new ExecuteSOQLQuery.InputParameters();
        input.query = 'SELECT Name FROM Account';
        List<ExecuteSOQLQuery.InputParameters> inputs = new List<ExecuteSOQLQuery.InputParameters>{
            input
        };

        List<ExecuteSOQLQuery.OutputParameters> outputs = ExecuteSOQLQuery.bulkInvoke(
            inputs
        );

        Assert.areEqual(1, outputs.size());
        List<Account> accounts = (List<Account>) outputs[0].records;
        Assert.areEqual(1, accounts.size());
        Assert.areEqual(acc.Name, accounts[0].Name);
    }
}
