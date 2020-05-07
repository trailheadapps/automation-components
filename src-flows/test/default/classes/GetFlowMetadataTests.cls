@isTest(isParallel=true)
global class GetFlowMetadataTests {
    private static final String FLOW_API_NAME = 'MockFlow';
    private static final String FLOW_ID = 'MockId';

    private static final String QUERY_API_NAME =
        GetFlowMetadata.BASE_QUERY +
        ' WHERE ApiName = \'' +
        FLOW_API_NAME +
        '\'';
    private static final String QUERY_ID =
        GetFlowMetadata.BASE_QUERY +
        ' WHERE DurableId = \'' +
        FLOW_ID +
        '\'';
    private static final String QUERY_ID_AND_API_NAME =
        GetFlowMetadata.BASE_QUERY +
        ' WHERE DurableId = \'' +
        FLOW_ID +
        '\' AND ApiName = \'' +
        FLOW_API_NAME +
        '\'';

    @isTest
    global static void getQuery_works_with_flowApiName() {
        GetFlowMetadata.InputParameters input = new GetFlowMetadata.InputParameters();
        input.flowApiName = FLOW_API_NAME;

        String query = GetFlowMetadata.getQuery(input);

        System.assertEquals(QUERY_API_NAME, query);
    }

    @isTest
    global static void getQuery_works_with_flowDefinitionId() {
        GetFlowMetadata.InputParameters input = new GetFlowMetadata.InputParameters();
        input.flowDefinitionId = FLOW_ID;

        String query = GetFlowMetadata.getQuery(input);

        System.assertEquals(QUERY_ID, query);
    }

    @isTest
    global static void getQuery_works_with_flowApiName_and_flowDefinitionId() {
        GetFlowMetadata.InputParameters input = new GetFlowMetadata.InputParameters();
        input.flowApiName = FLOW_API_NAME;
        input.flowDefinitionId = FLOW_ID;

        String query = GetFlowMetadata.getQuery(input);

        System.assertEquals(QUERY_ID_AND_API_NAME, query);
    }

    @isTest
    global static void getQuery_fails_when_params_are_missing() {
        GetFlowMetadata.InputParameters input = new GetFlowMetadata.InputParameters();

        try {
            GetFlowMetadata.getQuery(input);
            System.assert(false, 'Expected InvocableException');
        } catch (GetFlowMetadata.InvocableException e) {
            System.assert(e.getMessage().contains('must be provided'));
        }
    }
}
