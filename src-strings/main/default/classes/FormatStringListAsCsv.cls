global class FormatStringListAsCsv {
    /**
     * Formats a list of strings into a CSV string
     * Inputs:
     *   List<String> strings
     *   String separator
     * Outputs:
     *   String csvString
     */
    @InvocableMethod(
        label='Formats a list of strings into a CSV string'
        category='Strings'
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
        String[] strings = input.strings;
        String separator = String.isBlank(input.separator)
            ? ','
            : input.separator;
        // Join strings
        String csvString = String.join(strings, separator);
        // Return output
        OutputParameters output = new OutputParameters();
        output.csvString = csvString;
        return output;
    }

    /**
     * Wrapper class for input parameters
     */
    global class InputParameters {
        @InvocableVariable(label='String List' required=true)
        global String[] strings;
        @InvocableVariable(
            label='Separator'
            description='Optional list separator. Defaults to a comma.'
        )
        global String separator;
    }

    /**
     * Wrapper class for output parameters
     */
    global class OutputParameters {
        @InvocableVariable
        global String csvString;
    }
}
