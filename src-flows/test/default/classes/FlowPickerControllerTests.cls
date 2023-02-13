@isTest(isParallel=true)
global class FlowPickerControllerTests {
    private static final String QUERY_BASE = 'SELECT ApiName, Label FROM FlowDefinitionView';
    private static final String QUERY_ORDER = ' ORDER BY Label ASC';

    private static final String QUERY_NO_PARAM = QUERY_BASE + QUERY_ORDER;
    private static final String QUERY_NOT_NULL =
        QUERY_BASE +
        ' WHERE ActiveVersionId != NULL' +
        QUERY_ORDER;
    private static final String QUERY_SEARCH =
        QUERY_BASE +
        ' WHERE Label LIKE \'%keyword%\'' +
        QUERY_ORDER;
    private static final String QUERY_MULTIPLE_VALUES =
        QUERY_BASE +
        ' WHERE ProcessType IN (\'Flow\',\'AutolaunchedFlow\')' +
        QUERY_ORDER;
    private static final String QUERY_MULTIPLE_EXPRESSIONS =
        QUERY_BASE +
        ' WHERE ActiveVersionId != NULL AND ProcessType IN (\'Flow\',\'AutolaunchedFlow\')' +
        QUERY_ORDER;

    @isTest
    global static void getSearchQuery_works_with_no_params() {
        List<FlowPickerController.FilterParameter> params = new List<FlowPickerController.FilterParameter>{};

        String query = FlowPickerController.getSearchQuery(params);

        Assert.areEqual(QUERY_NO_PARAM, query);
    }

    @isTest
    global static void getSearchQuery_works_with_not_null() {
        FlowPickerController.FilterParameter param = new FlowPickerController.FilterParameter();
        param.key = '!ActiveVersionId';
        param.value = null;
        List<FlowPickerController.FilterParameter> params = new List<FlowPickerController.FilterParameter>{
            param
        };

        String query = FlowPickerController.getSearchQuery(params);

        Assert.areEqual(QUERY_NOT_NULL, query);
    }

    @isTest
    global static void getSearchQuery_works_with_search() {
        FlowPickerController.FilterParameter param = new FlowPickerController.FilterParameter();
        param.key = 'Label';
        param.value = '%keyword%';
        List<FlowPickerController.FilterParameter> params = new List<FlowPickerController.FilterParameter>{
            param
        };

        String query = FlowPickerController.getSearchQuery(params);

        Assert.areEqual(QUERY_SEARCH, query);
    }

    @isTest
    global static void getSearchQuery_works_with_multiple_values() {
        FlowPickerController.FilterParameter param = new FlowPickerController.FilterParameter();
        param.key = 'ProcessType';
        param.value = 'Flow,AutolaunchedFlow';
        List<FlowPickerController.FilterParameter> params = new List<FlowPickerController.FilterParameter>{
            param
        };

        String query = FlowPickerController.getSearchQuery(params);

        Assert.areEqual(QUERY_MULTIPLE_VALUES, query);
    }

    @isTest
    global static void getSearchQuery_works_with_multiple_expressions() {
        FlowPickerController.FilterParameter param1 = new FlowPickerController.FilterParameter();
        param1.key = '!ActiveVersionId';
        param1.value = null;
        FlowPickerController.FilterParameter param2 = new FlowPickerController.FilterParameter();
        param2.key = 'ProcessType';
        param2.value = 'Flow,AutolaunchedFlow';
        List<FlowPickerController.FilterParameter> params = new List<FlowPickerController.FilterParameter>{
            param1,
            param2
        };

        String query = FlowPickerController.getSearchQuery(params);

        Assert.areEqual(QUERY_MULTIPLE_EXPRESSIONS, query);
    }
}
