global class ParseCsvAsStringList {
    /**
     * Parses a CSV string into a list of strings
     * Inputs:
     *   String csvString
     *   String separator
     *   Boolean trimValues
     * Outputs:
     *   List<String> strings
     */
    @InvocableMethod(
        label='Parses a CSV string into a list of strings'
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
        String csvString = input.csvString;
        String separator = String.isBlank(input.separator)
            ? ','
            : input.separator;
        Boolean trimValues = input.trimValues == null ? true : input.trimValues;
        // Split strings using separator
        String[] values = csvString.split(separator);
        if (trimValues) {
            for (Integer i = 0; i < values.size(); i++) {
                values[i] = values[i].trim();
            }
        }
        // Return output
        OutputParameters output = new OutputParameters();
        output.strings = values;
        return output;
    }

    /**
     * Wrapper class for input parameters
     */
    global class InputParameters {
        @InvocableVariable(label='CSV string' required=true)
        global String csvString;
        @InvocableVariable(
            label='RegEx Separator'
            description='Optional list separator. Defaults to a comma.'
        )
        global String separator;
        @InvocableVariable(
            label='Trim values?'
            description='Whether values should be trimmed from whitespace. Defaults to true.'
        )
        global Boolean trimValues;
    }

    /**
     * Wrapper class for output parameters
     */
    global class OutputParameters {
        @InvocableVariable
        global List<String> strings;
    }
}
