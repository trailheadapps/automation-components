global with sharing class AggregateRecordList {
    /**
     * Calculates an aggregate operation on a list of records
     * Inputs:
     *   List<SObject> collection
     *   String fieldName
     *   String operation
     *   Decimal defaultValueForNullFields
     * Outputs:
     *   Decimal decimalResult
     *   String stringResult
     */
    @InvocableMethod(
        label='Calculates an aggregate operation on a list of records'
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

    @TestVisible
    private static OutputParameters invoke(InputParameters input) {
        // Parse operation
        Operation aggregateOperation;
        try {
            aggregateOperation = Operation.valueOf(input.operation);
        } catch (System.NoSuchElementException e) {
            throw new InvocableException(
                'Unsupported operation "' +
                input.operation +
                '" for RecordListCalculate'
            );
        }
        // Get field values
        List<Decimal> values = getFieldValuesAsDecimal(
            input.collection,
            input.fieldName,
            input.defaultValueForNullFields
        );
        // Calculate aggregate value
        Decimal aggregate = 0;
        switch on aggregateOperation {
            when SUM {
                for (Decimal value : values) {
                    aggregate += value;
                }
            }
            when AVERAGE {
                if (values.size() > 0) {
                    for (Decimal value : values) {
                        aggregate += value;
                    }
                    aggregate /= values.size();
                }
            }
            when MIN {
                if (values.size() > 0) {
                    aggregate = values[0];
                }
                for (Decimal value : values) {
                    aggregate = Math.min(aggregate, value);
                }
            }
            when MAX {
                if (values.size() > 0) {
                    aggregate = values[0];
                }
                for (Decimal value : values) {
                    aggregate = Math.max(aggregate, value);
                }
            }
        }
        // Return result
        OutputParameters output = new OutputParameters();
        output.decimalResult = aggregate;
        output.stringResult = String.valueOf(aggregate);
        return output;
    }

    private static List<Decimal> getFieldValuesAsDecimal(
        List<SObject> collection,
        String fieldName,
        Decimal defaultValueForNullFields
    ) {
        List<Decimal> values = new List<Decimal>();
        for (SObject record : collection) {
            Object rawValue = (record.get(fieldName) == null)
                ? defaultValueForNullFields
                : record.get(fieldName);
            if (rawValue == null) {
                throw new InvocableException(
                    'No default value specified for null "' +
                    fieldName +
                    '" field.'
                );
            }
            Decimal value;
            try {
                value = Decimal.valueOf(String.valueOf(rawValue));
            } catch (Exception e) {
                throw new InvocableException(
                    'Failed to convert ' +
                    fieldName +
                    ' field value "' +
                    rawValue +
                    '" into a decimal.'
                );
            }
            values.add(value);
        }
        return values;
    }

    /**
     * Wrapper class for input parameters
     */
    global class InputParameters {
        @InvocableVariable(required=true)
        global List<SObject> collection;
        @InvocableVariable(required=true)
        global String fieldName;
        @InvocableVariable(required=true)
        global String operation;
        @InvocableVariable
        global Decimal defaultValueForNullFields;
    }

    /**
     * Wrapper class for output parameters
     */
    global class OutputParameters {
        @InvocableVariable
        global Decimal decimalResult;
        @InvocableVariable
        global String stringResult;
    }

    private enum Operation {
        SUM,
        AVERAGE,
        MIN,
        MAX
    }

    global class InvocableException extends Exception {
    }
}
