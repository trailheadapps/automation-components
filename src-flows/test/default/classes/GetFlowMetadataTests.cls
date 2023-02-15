@isTest(isParallel=true)
global class GetFlowMetadataTests {
    private static final String FLOW_API_NAME = 'MockFlow';
    private static final String FLOW_ID = 'MockId';

    private static final String QUERY_API_NAME =
        GetFlowMetadata.BASE_QUERY + ' WHERE ApiName = :apiName LIMIT 1';
    private static final String QUERY_ID =
        GetFlowMetadata.BASE_QUERY + ' WHERE DurableId = :definitionId LIMIT 1';
    private static final String QUERY_ID_AND_API_NAME =
        GetFlowMetadata.BASE_QUERY +
        ' WHERE DurableId = :definitionId AND ApiName = :apiName LIMIT 1';

    @isTest
    global static void getQuery_works_with_flowApiName() {
        String query = GetFlowMetadata.getQuery(FLOW_API_NAME, null);

        System.assertEquals(QUERY_API_NAME, query);
    }

    @isTest
    global static void getQuery_works_with_flowDefinitionId() {
        String query = GetFlowMetadata.getQuery(null, FLOW_ID);

        System.assertEquals(QUERY_ID, query);
    }

    @isTest
    global static void getQuery_works_with_flowApiName_and_flowDefinitionId() {
        String query = GetFlowMetadata.getQuery(FLOW_API_NAME, FLOW_ID);

        System.assertEquals(QUERY_ID_AND_API_NAME, query);
    }

    @isTest
    global static void getQuery_fails_when_params_are_missing() {
        List<GetFlowMetadata.InputParameters> inputs = new List<GetFlowMetadata.InputParameters>{
            new GetFlowMetadata.InputParameters()
        };

        try {
            GetFlowMetadata.bulkInvoke(inputs);
            System.assert(false, 'Expected InvocableException');
        } catch (GetFlowMetadata.InvocableException e) {
            System.assert(e.getMessage().contains('must be provided'));
        }
    }

    @isTest
    global static void bulkInvoke_fails_when_flow_not_found() {
        GetFlowMetadata.InputParameters input = new GetFlowMetadata.InputParameters();
        input.flowApiName = FLOW_API_NAME;
        List<GetFlowMetadata.InputParameters> inputs = new List<GetFlowMetadata.InputParameters>{
            input
        };

        try {
            GetFlowMetadata.bulkInvoke(inputs);
            Assert.fail('Expected FlowNotfoundException');
        } catch (GetFlowMetadata.FlowNotfoundException e) {
            System.debug(e.getMessage());
            Assert.isTrue(e.getMessage().contains('Failed to find flow'));
        }
    }
}
