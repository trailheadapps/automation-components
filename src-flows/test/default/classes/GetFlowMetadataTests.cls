@isTest(isParallel=true)
global class GetFlowMetadataTests {
    private static final String FLOW_API_NAME = 'MockFlow';
    private static final String FLOW_ID = 'MockId';

    private static final String QUERY_API_NAME =
        GetFlowMetadata.BASE_QUERY + ' WHERE ApiName = :apiName';
    private static final String QUERY_ID =
        GetFlowMetadata.BASE_QUERY + ' WHERE DurableId = :definitionId';
    private static final String QUERY_ID_AND_API_NAME =
        GetFlowMetadata.BASE_QUERY +
        ' WHERE DurableId = :definitionId AND ApiName = :apiName';

    @isTest
    global static void getQuery_works_with_flowApiName() {
        GetFlowMetadata.InputParameters input = new GetFlowMetadata.InputParameters();
        input.flowApiName = FLOW_API_NAME;

        GetFlowMetadata.QueryInfo queryInfo = GetFlowMetadata.prepareQuery(
            input
        );

        Assert.areEqual(QUERY_API_NAME, queryInfo.query);
        Assert.areEqual(FLOW_API_NAME, queryInfo.params.get('apiName'));
    }

    @isTest
    global static void getQuery_works_with_flowDefinitionId() {
        GetFlowMetadata.InputParameters input = new GetFlowMetadata.InputParameters();
        input.flowDefinitionId = FLOW_ID;

        GetFlowMetadata.QueryInfo queryInfo = GetFlowMetadata.prepareQuery(
            input
        );

        Assert.areEqual(QUERY_ID, queryInfo.query);
        Assert.areEqual(FLOW_ID, queryInfo.params.get('definitionId'));
    }

    @isTest
    global static void getQuery_works_with_flowApiName_and_flowDefinitionId() {
        GetFlowMetadata.InputParameters input = new GetFlowMetadata.InputParameters();
        input.flowApiName = FLOW_API_NAME;
        input.flowDefinitionId = FLOW_ID;

        GetFlowMetadata.QueryInfo queryInfo = GetFlowMetadata.prepareQuery(
            input
        );

        Assert.areEqual(QUERY_ID_AND_API_NAME, queryInfo.query);
        Assert.areEqual(FLOW_API_NAME, queryInfo.params.get('apiName'));
        Assert.areEqual(FLOW_ID, queryInfo.params.get('definitionId'));
    }

    @isTest
    global static void getQuery_fails_when_params_are_missing() {
        GetFlowMetadata.InputParameters input = new GetFlowMetadata.InputParameters();

        try {
            GetFlowMetadata.prepareQuery(input);
            Assert.fail('Expected InvocableException');
        } catch (GetFlowMetadata.InvocableException e) {
            Assert.isTrue(e.getMessage().contains('must be provided'));
        }
    }
}
