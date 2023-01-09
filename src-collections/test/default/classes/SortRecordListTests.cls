@isTest(isParallel=true)
global class SortRecordListTests {
    private final static String SORT_NAME_DESC = '[{ "field" : "Name", "direction" : "DESC" }]';
    private final static String SORT_NUM_EMPLOYEES_ASC = '[{ "field" : "NumberOfEmployees", "direction" : "ASC" }]';
    private final static String SORT_DUE_DATE_DESC = '[{ "field" : "ActivityDate", "direction" : "DESC" }]';
    private final static String SORT_PRIORITY_DESC = '[{ "field" : "Priority", "direction" : "DESC" }]';

    @isTest
    global static void bulkInvoke_works_with_empty_list() {
        List<SortRecordList.InputParameters> inputs = getInputs(
            new List<Account>(),
            SORT_NAME_DESC
        );

        List<SortRecordList.OutputParameters> outputs = SortRecordList.bulkInvoke(
            inputs
        );

        Assert.areEqual(inputs.size(), outputs.size());
        Assert.areEqual(0, outputs[0].collection.size());
    }

    @isTest
    global static void bulkInvoke_works_with_single_item_list() {
        List<SortRecordList.InputParameters> inputs = getInputs(
            new List<Account>{ SampleDataFactory.SAMPLE_ACCOUNTS[0] },
            SORT_NAME_DESC
        );

        List<SortRecordList.OutputParameters> outputs = SortRecordList.bulkInvoke(
            inputs
        );

        Assert.areEqual(inputs.size(), outputs.size());
        Assert.areEqual(1, outputs[0].collection.size());
    }

    @isTest
    global static void bulkInvoke_works_with_simple_list_string_sort() {
        List<SortRecordList.InputParameters> inputs = getInputs(
            SampleDataFactory.SAMPLE_ACCOUNTS,
            SORT_NAME_DESC
        );

        List<SortRecordList.OutputParameters> outputs = SortRecordList.bulkInvoke(
            inputs
        );

        Assert.areEqual(inputs.size(), outputs.size());
        Assert.areEqual(
            inputs[0].collection.size(),
            outputs[0].collection.size()
        );
        Account acc = (Account) outputs[0].collection[1];
        Assert.areEqual(SampleDataFactory.ACCOUNT_NAME + 1, acc.Name);
    }

    @isTest
    global static void bulkInvoke_works_with_simple_list_number_sort() {
        List<SortRecordList.InputParameters> inputs = getInputs(
            SampleDataFactory.SAMPLE_ACCOUNTS,
            SORT_NUM_EMPLOYEES_ASC
        );

        List<SortRecordList.OutputParameters> outputs = SortRecordList.bulkInvoke(
            inputs
        );

        Assert.areEqual(inputs.size(), outputs.size());
        Assert.areEqual(
            inputs[0].collection.size(),
            outputs[0].collection.size()
        );
        Account acc = (Account) outputs[0].collection[1];
        Assert.areEqual(SampleDataFactory.ACCOUNT_NAME + 1, acc.Name);
    }

    @isTest
    global static void bulkInvoke_works_with_simple_list_date_sort() {
        List<SortRecordList.InputParameters> inputs = getInputs(
            SampleDataFactory.SAMPLE_TASKS,
            SORT_DUE_DATE_DESC
        );

        List<SortRecordList.OutputParameters> outputs = SortRecordList.bulkInvoke(
            inputs
        );

        Assert.areEqual(inputs.size(), outputs.size());
        Assert.areEqual(
            inputs[0].collection.size(),
            outputs[0].collection.size()
        );
        Task task = (Task) outputs[0].collection[1];
        Assert.areEqual(SampleDataFactory.TASK_NAME + 1, task.Subject);
    }

    @isTest
    global static void bulkInvoke_works_with_empty_sortKeys() {
        List<SortRecordList.InputParameters> inputs = getInputs(
            SampleDataFactory.SAMPLE_ACCOUNTS,
            '[]'
        );

        List<SortRecordList.OutputParameters> outputs = SortRecordList.bulkInvoke(
            inputs
        );

        Assert.areEqual(inputs.size(), outputs.size());
        Assert.areEqual(
            inputs[0].collection.size(),
            outputs[0].collection.size()
        );
    }

    @isTest
    global static void bulkInvoke_fails_when_malformed_sortKeys() {
        List<SortRecordList.InputParameters> inputs = getInputs(
            SampleDataFactory.SAMPLE_ACCOUNTS,
            'invalidJSON'
        );

        try {
            SortRecordList.bulkInvoke(inputs);
            Assert.fail('Expected InvalidSortKeyException');
        } catch (SortRecordList.InvalidSortKeyException e) {
            Assert.isTrue(e.getMessage().contains('Failed to parse sort keys'));
        }
    }

    @isTest
    global static void bulkInvoke_fails_when_unsupported_sort_type() {
        List<SortRecordList.InputParameters> inputs = getInputs(
            SampleDataFactory.SAMPLE_TASKS,
            SORT_PRIORITY_DESC
        );

        try {
            SortRecordList.bulkInvoke(inputs);
            Assert.fail('Expected UnsupportedSortTypeException');
        } catch (SortRecordList.UnsupportedSortTypeException e) {
            Assert.isTrue(e.getMessage().contains('Unsupported sort type'));
        }
    }

    // Helper method for assembling invocable method parameters
    private static List<SortRecordList.InputParameters> getInputs(
        List<SObject> collection,
        String sortKeys
    ) {
        SortRecordList.InputParameters input = new SortRecordList.InputParameters();
        input.collection = collection;
        input.sortKeys = sortKeys;
        return new List<SortRecordList.InputParameters>{ input };
    }
}
