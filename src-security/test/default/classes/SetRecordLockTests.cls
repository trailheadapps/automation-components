@isTest(isParallel=true)
global class SetRecordLockTests {
    @isTest
    global static void bulkInvoke_works_lock() {
        Account acc = new Account(Name = 'Sample Account');
        insert acc;

        SetRecordLock.InputParameters input = new SetRecordLock.InputParameters();
        input.recordId = acc.Id;
        input.isLocked = true;
        List<SetRecordLock.InputParameters> inputs = new List<SetRecordLock.InputParameters>{
            input
        };

        List<SetRecordLock.OutputParameters> outputs = SetRecordLock.bulkInvoke(
            inputs
        );

        Assert.areEqual(inputs.size(), outputs.size());
        Assert.isTrue(outputs[0].isSuccess);
    }

    @isTest
    global static void bulkInvoke_works_unlock() {
        Account acc = new Account(Name = 'Sample Account');
        insert acc;
        Approval.lock(acc.Id);

        SetRecordLock.InputParameters input = new SetRecordLock.InputParameters();
        input.recordId = acc.Id;
        input.isLocked = false;
        List<SetRecordLock.InputParameters> inputs = new List<SetRecordLock.InputParameters>{
            input
        };

        List<SetRecordLock.OutputParameters> outputs = SetRecordLock.bulkInvoke(
            inputs
        );

        Assert.areEqual(inputs.size(), outputs.size());
        Assert.isTrue(outputs[0].isSuccess);
    }

    @isTest
    global static void bulkInvoke_fails_when_unkown_recordId() {
        // Testing lock on an unkown record
        SetRecordLock.InputParameters input = new SetRecordLock.InputParameters();
        input.recordId = '0010R00000yvEyRQAU';
        input.isLocked = true;
        List<SetRecordLock.InputParameters> inputs = new List<SetRecordLock.InputParameters>{
            input
        };

        List<SetRecordLock.OutputParameters> outputs = SetRecordLock.bulkInvoke(
            inputs
        );

        Assert.areEqual(inputs.size(), outputs.size());
        Assert.isTrue(!outputs[0].isSuccess);
    }
}
