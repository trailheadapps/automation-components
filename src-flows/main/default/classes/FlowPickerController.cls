global with sharing class FlowPickerController {
    @AuraEnabled(cacheable=true)
    @SuppressWarnings('PMD.ApexSOQLInjection')
    global static List<FlowDefinitionView> getFlowNames(
        List<FilterParameter> filterParams
    ) {
        String query = getSearchQuery(filterParams);
        return (List<FlowDefinitionView>) Database.query(query);
    }

    @TestVisible
    private static String getSearchQuery(List<FilterParameter> filterParams) {
        String query = 'SELECT ApiName, Label FROM FlowDefinitionView';
        // Apply filters if any
        if (filterParams != null && filterParams.size() > 0) {
            query += ' WHERE';
            Boolean isFirst = true;
            for (FilterParameter param : filterParams) {
                // Build negative clause if needed
                String negativeClause = '';
                if (param.isNegative()) {
                    negativeClause = param.hasMultipleValues() ? 'NOT ' : '!';
                }
                // Get operator
                String operator = '= ';
                if (param.isSearch()) {
                    operator = 'LIKE ';
                } else if (param.hasMultipleValues()) {
                    operator = 'IN ';
                }
                // Format value
                String value;
                if (param.value == null) {
                    value = 'NULL';
                } else if (param.hasMultipleValues()) {
                    value =
                        '(\'' +
                        String.join(param.getValues(), '\',\'') +
                        '\')';
                } else {
                    value =
                        '\'' +
                        String.escapeSingleQuotes(param.value) +
                        '\'';
                }
                // Add expression to query
                query +=
                    (isFirst ? ' ' : ' AND ') +
                    param.key.replace('!', '') +
                    ' ' +
                    negativeClause +
                    operator +
                    value;
                isFirst = false;
            }
        }
        // Sort results by Flow Label
        query += ' ORDER BY Label ASC';
        return query;
    }

    global class FilterParameter {
        @AuraEnabled
        global String key { get; set; }
        @AuraEnabled
        global String value { get; set; }

        global Boolean isNegative() {
            return this.key.startsWith('!');
        }

        global Boolean isSearch() {
            return (this.value != null && this.value.contains('%'));
        }

        global List<String> getValues() {
            if (this.value == null) {
                return null;
            }
            return String.escapeSingleQuotes(this.value)
                .replace(' ', '')
                .split(',');
        }

        global Boolean hasMultipleValues() {
            List<String> values = this.getValues();
            return (values != null && values.size() > 1);
        }
    }
}
