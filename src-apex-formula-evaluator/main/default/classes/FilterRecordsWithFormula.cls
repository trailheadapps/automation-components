global with sharing class FilterRecordsWithFormula {
    /**
     * Filters a list of records with a formula
     * Inputs:
     *   List<SObject> collection
     *   String formula
     * Outputs:
     *   List<SObject> collection
     *   Integer totalRecordCount
     *   Integer filteredRecordCount
     */
    @InvocableMethod(
        label='Filters a list of records with a formula'
        category='Collections'
    )
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
        // Get inputs
        List<SObject> collection = input.collection;
        String formula = input.formula;
        // Filter records
        List<SObject> filteredCollection = new List<SObject>();
        for (SObject record : collection) {
            // For each member of the input collection, call the FormulaEvaluator.parseFormula method, which
            // returns true if the formula is true for this member
            // the FormulaEvaluator use the recordId of the current member as context, replacing expressions in the
            // formula string of the form $Record.fieldname. For example, if the formula is '$Record.Age__c > 22' and the input collection
            // is a collection of Student__c, the evaluator takes the current student's Id, retrieve the record, and looks for a field 'Student__c.Age__c'
            List<FormulaEvaluator.ContextWrapper> context = new List<FormulaEvaluator.ContextWrapper>();
            context.add(
                new FormulaEvaluator.ContextWrapper('$Record', record.Id)
            );
            String stringContext = JSON.serialize(context);
            String result = FormulaEvaluator.parseFormula(
                formula,
                stringContext
            );
            if (result == 'true') {
                filteredCollection.add(record);
            }
        }
        // Return output
        OutputParameters output = new OutputParameters();
        output.collection = filteredCollection;
        output.totalRecordCount = collection.size();
        output.filteredRecordCount = filteredCollection.size();
        return output;
    }

    /**
     * Wrapper class for input parameters
     */
    global class InputParameters {
        @InvocableVariable(required=true)
        global List<SObject> collection;
        @InvocableVariable(required=true)
        global String formula;
    }

    /**
     * Wrapper class for output parameters
     */
    global class OutputParameters {
        @InvocableVariable
        global List<SObject> collection;
        @InvocableVariable
        global Integer totalRecordCount;
        @InvocableVariable
        global Integer filteredRecordCount;
    }
}
