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
        String query = getQuery(input);
        FlowDefinitionView flow = Database.query(query);
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
    private static String getQuery(InputParameters input) {
        // Get and validate input
        String apiName = input.flowApiName == null
            ? null
            : String.escapeSingleQuotes(input.flowApiName);
        String definitionId = input.flowDefinitionId == null
            ? null
            : String.escapeSingleQuotes(input.flowDefinitionId);
        if (apiName == null && definitionId == null) {
            throw new InvocableException(
                'At least one of apiName or definitionId must be provided.'
            );
        }
        // Build flow query
        String query = BASE_QUERY;
        if (apiName != null && definitionId != null) {
            query +=
                ' WHERE DurableId = \'' +
                definitionId +
                '\' AND ApiName = \'' +
                apiName +
                '\'';
        } else if (apiName != null) {
            query += ' WHERE ApiName = \'' + apiName + '\'';
        } else /** definitionId != null */ {
            query += ' WHERE DurableId = \'' + definitionId + '\'';
        }
        return query;
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
