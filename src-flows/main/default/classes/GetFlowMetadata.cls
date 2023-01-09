global with sharing class GetFlowMetadata {
    @TestVisible
    private final static String BASE_QUERY = 'SELECT Id, ApiName, Label, ActiveVersionId, Description, DurableId, LatestVersionId, NamespacePrefix, ProcessType FROM FlowDefinitionView';

    /**
     * Gets a Flow's Metadata
     * Inputs:
     *   String flowApiName
     *   String flowDefinitionId
     * Outputs:
     *   String flowApiName
     *   String flowDefinitionId
     *   String activeVersionId
     *   String description
     *   String label
     *   String latestVersionId
     *   String namespacePrefix
     *   String flowType
     */
    @InvocableMethod(label='Gets a Flow definition metadata' category='Flows')
    global static List<OutputParameters> bulkInvoke(
        List<InputParameters> inputs
    ) {
        List<OutputParameters> outputs = new List<OutputParameters>();
        for (InputParameters input : inputs) {
            outputs.add(invoke(input));
        }
        return outputs;
    }

    private static OutputParameters invoke(InputParameters input) {
        // Find flow
        QueryInfo queryInfo = prepareQuery(input);
        FlowDefinitionView flow = Database.queryWithBinds(
            queryInfo.query,
            queryInfo.params,
            AccessLevel.USER_MODE
        );
        // Return output
        OutputParameters output = new OutputParameters();
        output.flowApiName = flow.ApiName;
        output.flowDefinitionId = flow.DurableId;
        output.activeVersionId = flow.ActiveVersionId;
        output.description = flow.Description;
        output.label = flow.Label;
        output.latestVersionId = flow.LatestVersionId;
        output.namespacePrefix = flow.NamespacePrefix;
        output.flowType = flow.ProcessType;
        return output;
    }

    @TestVisible
    private static QueryInfo prepareQuery(InputParameters input) {
        // Get and validate inputs
        String apiName = input.flowApiName;
        String definitionId = input.flowDefinitionId;
        if (apiName == null && definitionId == null) {
            throw new InvocableException(
                'At least one of apiName or definitionId must be provided.'
            );
        }
        // Build query
        Map<String, Object> params;
        String query;
        if (apiName != null && definitionId != null) {
            query =
                BASE_QUERY +
                ' WHERE DurableId = :definitionId AND ApiName = :apiName';
            params = new Map<String, Object>{
                'definitionId' => definitionId,
                'apiName' => apiName
            };
        } else if (apiName != null) {
            query = BASE_QUERY + ' WHERE ApiName = :apiName';
            params = new Map<String, Object>{ 'apiName' => apiName };
        } else /** definitionId != null */ {
            query = BASE_QUERY + ' WHERE DurableId = :definitionId';
            params = new Map<String, Object>{ 'definitionId' => definitionId };
        }
        return new QueryInfo(query, params);
    }

    public class QueryInfo {
        public String query { get; set; }
        public Map<String, Object> params { get; set; }

        public QueryInfo(String query, Map<String, Object> params) {
            this.query = query;
            this.params = params;
        }
    }

    global class InvocableException extends Exception {
    }

    /**
     * Wrapper class for input parameters
     */
    global class InputParameters {
        @InvocableVariable(label='Flow API Name')
        global String flowApiName;
        @InvocableVariable(label='Flow Definition ID')
        global String flowDefinitionId;
    }

    /**
     * Wrapper class for output parameters
     */
    global class OutputParameters {
        @invocableVariable
        global String flowApiName;
        @invocableVariable
        global String flowDefinitionId;
        @invocableVariable
        global String activeVersionId;
        @invocableVariable
        global String description;
        @invocableVariable
        global String label;
        @invocableVariable
        global String latestVersionId;
        @invocableVariable
        global String namespacePrefix;
        @invocableVariable
        global String flowType;
    }
}
