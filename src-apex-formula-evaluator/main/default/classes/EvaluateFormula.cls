global with sharing class EvaluateFormula {
    /**
     * Evaluates a formula
     * Original contribution by Enrico Murru (https://enree.co/) and Andrii Kraiev
     * Inputs:
     *   String formula
     *   String context as a JSON Object
     * Outputs:
     *   String result
     */
    @InvocableMethod(label='Evaluates a formula' category='Utilities')
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
        String formula = input.formula;
        String stringContext = input.context;
        // Evaluate formula
        String result = FormulaEvaluator.parseFormula(formula, stringContext);
        // Return output
        OutputParameters output = new OutputParameters();
        output.result = result;
        return output;
    }

    /**
     * Wrapper class for input parameters
     */
    global class InputParameters {
        @InvocableVariable(required=true)
        global String formula;
        @InvocableVariable(required=true)
        global String context;
    }

    /**
     * Wrapper class for output parameters
     */
    global class OutputParameters {
        @InvocableVariable
        global String result;
    }
}
