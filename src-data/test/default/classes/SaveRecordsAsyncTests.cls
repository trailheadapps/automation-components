@isTest(isParallel=true)
global class SaveRecordsAsyncTests {
    @isTest
    global static void bulkInvoke_works() {
        Account acc = new Account(Name = 'Sample');
        List<Account> accounts = new List<Account>();
        accounts.add(acc);

        SaveRecordsAsync.InputParameters input = new SaveRecordsAsync.InputParameters();
        input.records = accounts;
        List<SaveRecordsAsync.InputParameters> inputs = new List<SaveRecordsAsync.InputParameters>{
            input
        };

        List<SaveRecordsAsync.OutputParameters> outputs = SaveRecordsAsync.bulkInvoke(
            inputs
        );

        Assert.areEqual(1, outputs.size());
        Id jobId = outputs[0].jobId;
        Assert.isNotNull(jobId);
    }

    @isTest
    global static void UpsertRecordsQueueable_execute_works() {
        Account acc = new Account(Name = 'Mock');
        List<Account> accounts = new List<Account>();
        accounts.add(acc);

        Test.startTest();
        SaveRecordsAsync.UpsertRecordsQueueable job = new SaveRecordsAsync.UpsertRecordsQueueable(
            accounts
        );
        job.execute(null);
        Test.stopTest();

        Account[] newAccounts = [SELECT Name FROM Account];
        Assert.areEqual(1, newAccounts.size());
    }
}
