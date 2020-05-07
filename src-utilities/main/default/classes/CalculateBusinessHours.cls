global class CalculateBusinessHours {
    /**
     * Calculates the duration in terms business hours between two dates
     * Inputs:
     *   Id businessHoursId
     *   DateTime startDate
     *   DateTime endDate
     * Outputs:
     *   Long durationMs
     *   Long durationSec
     *   Long durationMin
     *   Long durationHours
     *   Long durationDays
     */
    @InvocableMethod(
        label='Calculates the duration in terms business hours between two dates'
        category='Utilities'
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
        long durationMs = BusinessHours.diff(
            input.businessHoursId,
            input.startDate,
            input.endDate
        );
        // Return output
        OutputParameters output = new OutputParameters();
        output.durationMs = durationMs;
        output.durationSec = durationMs / 1000;
        output.durationMin = durationMs / 60000;
        output.durationHours = durationMs / 3600000;
        output.durationDays = durationMs / 86400000;
        return output;
    }

    /**
     * Wrapper class for input parameters
     */
    global class InputParameters {
        @InvocableVariable(label='Business Hours Id' required=true)
        global Id businessHoursId;
        @InvocableVariable(label='Start Date' required=true)
        global DateTime startDate;
        @InvocableVariable(label='End Date' required=true)
        global DateTime endDate;
    }

    /**
     * Wrapper class for output parameters
     */
    global class OutputParameters {
        @InvocableVariable(label='Duration in milliseconds')
        global Long durationMs;
        @InvocableVariable(label='Duration in seconds')
        global Long durationSec;
        @InvocableVariable(label='Duration in minutes')
        global Long durationMin;
        @InvocableVariable(label='Duration in hours')
        global Long durationHours;
        @InvocableVariable(label='Duration in days')
        global Long durationDays;
    }
}
