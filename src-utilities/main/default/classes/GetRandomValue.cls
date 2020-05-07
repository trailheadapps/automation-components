global class GetRandomValue {
    global static String TYPE_NUMBER = 'number';
    global static String TYPE_BOOLEAN = 'boolean';

    global static Integer MAX_INTEGER = 2147483647;

    /**
     * Generates a random value
     * Inputs:
     *   String randomType
     *   Integer minNumber
     *   Integer maxNumber
     * Outputs:
     *   Double randomNumber
     *   Boolean randomBoolean
     */
    @InvocableMethod(label='Generates a random value' category='Utilities')
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
        // Get input
        String randomType = input.randomType.toLowerCase();
        // Generate random value
        OutputParameters output = new OutputParameters();
        if (randomType == TYPE_NUMBER) {
            output.randomNumber = generateRandomNumber(
                input.minNumber,
                input.maxNumber
            );
        } else if (randomType == TYPE_BOOLEAN) {
            output.randomBoolean = generateRandomBoolean();
        } else {
            throw new InvocableException(
                'Unsupported type: ' + input.randomType
            );
        }
        // Return output
        return output;
    }

    private static Double generateRandomNumber(
        Integer minNumber,
        Integer maxNumber
    ) {
        Double rand = Math.random();
        // If no range is provided return a random number in [0;1[
        if (minNumber == null && maxNumber == null) {
            return rand;
        }
        if (minNumber == null) {
            minNumber = 0;
        } else if (maxNumber == null) {
            maxNumber = MAX_INTEGER;
        }
        // Generate random number in range
        Integer min = Math.min(minNumber, maxNumber);
        Integer range = Math.abs(maxNumber - minNumber);
        return min + rand * range;
    }

    private static Boolean generateRandomBoolean() {
        return (Math.random() < 0.5);
    }

    global class InvocableException extends Exception {
    }

    /**
     * Wrapper class for input parameters
     */
    global class InputParameters {
        @InvocableVariable(label='Random Value Type' required=true)
        global String randomType;
        @InvocableVariable(label='Maximum Number')
        global Integer minNumber;
        @InvocableVariable(label='Minimum Number')
        global Integer maxNumber;
    }

    /**
     * Wrapper class for output parameters
     */
    global class OutputParameters {
        @InvocableVariable
        global Double randomNumber;
        @InvocableVariable
        global Boolean randomBoolean;
    }
}
