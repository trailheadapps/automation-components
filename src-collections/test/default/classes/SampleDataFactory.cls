@isTest(isParallel=true)
global class SampleDataFactory {
    // ACCOUNTS
    global final static String ACCOUNT_NAME = 'Sample Account';

    global final static List<Account> SAMPLE_ACCOUNTS = new List<Account>{
        new Account(Name = ACCOUNT_NAME + 1, NumberOfEmployees = 20),
        new Account(Name = ACCOUNT_NAME + 2, NumberOfEmployees = 10)
    };

    global final static List<Account> SAMPLE_ACCOUNTS2 = new List<Account>{
        new Account(Name = ACCOUNT_NAME + 3),
        new Account(Name = ACCOUNT_NAME + 4)
    };

    // TASKS
    global final static String TASK_NAME = 'Sample Task';

    global final static List<Task> SAMPLE_TASKS = new List<Task>{
        new Task(
            Subject = TASK_NAME + 1,
            ActivityDate = Date.today(),
            Priority = 'High'
        ),
        new Task(
            Subject = TASK_NAME + 2,
            ActivityDate = Date.today().addDays(1),
            Priority = 'Normal'
        )
    };
}
