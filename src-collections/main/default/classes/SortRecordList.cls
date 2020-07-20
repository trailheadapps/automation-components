global with sharing class SortRecordList {
    /**
     * Sorts a record list
     * Inputs:
     *   List<SObject> collection
     *   String sortKeys - Array of objects in JSON format: [{ "field":"Name", "direction":"desc" }]
     * Outputs:
     *   List<SObject> collection
     */
    @InvocableMethod(label='Sorts a record list' category='Collections')
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
        // Get inputs and parse sort keys
        List<SObject> collection = input.collection;
        List<SortKeyMember> sortKeys;
        try {
            sortKeys = (List<SortKeyMember>) JSON.deserialize(
                input.sortKeys,
                List<SortKeyMember>.class
            );
        } catch (Exception e) {
            throw new InvalidSortKeyException(
                'Failed to parse sort keys "' +
                input.sortKeys +
                '" JSON: ' +
                e.getMessage()
            );
        }

        // Check if there's something to sort
        if (collection.size() > 1 && sortKeys.size() > 0) {
            // Get sorted field types
            List<String> allSortFields = new List<String>();
            for (SortKeyMember skm : sortKeys) {
                allSortFields.add(skm.field);
            }
            Map<String, String> fieldTypes = getFieldTypes(
                collection[0],
                allSortFields
            );

            // Sort collection
            for (SortKeyMember skm : sortKeys) {
                List<SortableWrapper> sortable = new List<SortableWrapper>();
                for (SObject record : collection) {
                    Integer sortDirection = 'DESC'
                            .equalsIgnoreCase(skm.direction)
                        ? -1
                        : 1;
                    sortable.add(
                        new SortableWrapper(
                            record,
                            skm.field,
                            sortDirection,
                            fieldTypes.get(skm.field)
                        )
                    );
                }
                sortable.sort();
                collection.clear();
                for (SortableWrapper sw : sortable) {
                    collection.add(sw.record);
                }
            }
        }

        // Return output
        OutputParameters output = new OutputParameters();
        output.collection = collection;
        return output;
    }

    private static Map<String, String> getFieldTypes(
        SObject record,
        List<String> fieldNames
    ) {
        Map<String, String> fieldTypes = new Map<String, String>();
        DescribeSObjectResult objDescription = record.getSObjectType()
            .getDescribe();
        Map<String, Schema.SobjectField> objectFieldMap = objDescription.fields.getMap();
        for (String fieldName : fieldNames) {
            fieldTypes.put(
                fieldName,
                objectFieldMap.get(fieldName).getDescribe().getType().name()
            );
        }
        return fieldTypes;
    }

    /**
     * Wrapper class for input parameters
     */
    global class InputParameters {
        @InvocableVariable(required=true)
        global List<SObject> collection;
        @InvocableVariable(required=true)
        global String sortKeys;
    }

    /**
     * Wrapper class for output parameters
     */
    global class OutputParameters {
        @InvocableVariable
        global List<SObject> collection;
    }

    global class InvalidSortKeyException extends Exception {
    }
    global class UnsupportedSortTypeException extends Exception {
    }

    public class SortableWrapper implements Comparable {
        SObject record;
        String field;
        Integer direction;
        String fieldType;

        SortableWrapper(
            SObject record,
            String field,
            Integer direction,
            String fieldType
        ) {
            this.record = record;
            this.field = field;
            this.direction = direction;
            this.fieldType = fieldType;
        }

        public Integer compareTo(Object compareTo) {
            SortableWrapper compareToRecord = (SortableWrapper) compareTo;

            Integer returnValue = 0;
            //Have to copy paste code here as there is no way to cast field types dynamically in APEX
            if (fieldType == 'STRING') {
                String origValue = String.valueOf(record.get(this.field));
                String compareToValue = String.valueOf(
                    compareToRecord.record.get(this.field)
                );
                if (origValue == null && compareToValue == null) {
                    returnValue = 0;
                } else if (origValue == null) {
                    returnValue = -1;
                } else if (compareToValue == null) {
                    returnValue = 1;
                } else if (origValue > compareToValue) {
                    returnValue = 1 * direction;
                } else if (origValue < compareToValue) {
                    returnValue = -1 * direction;
                }
            } else if (fieldType == 'INTEGER' || fieldType == 'DOUBLE') {
                Double origValue = Double.valueOf(record.get(this.field));
                Double compareToValue = Double.valueOf(
                    compareToRecord.record.get(this.field)
                );
                if (origValue == null && compareToValue == null) {
                    returnValue = 0;
                } else if (origValue == null) {
                    returnValue = -1;
                } else if (compareToValue == null) {
                    returnValue = 1;
                } else if (origValue > compareToValue) {
                    returnValue = 1 * direction;
                } else if (origValue < compareToValue) {
                    returnValue = -1 * direction;
                }
            } else if (fieldType == 'DATE' || fieldType == 'DATE') {
                Date origValue = Date.valueOf(record.get(this.field));
                Date compareToValue = Date.valueOf(
                    compareToRecord.record.get(this.field)
                );
                if (origValue == null && compareToValue == null) {
                    returnValue = 0;
                } else if (origValue == null) {
                    returnValue = -1;
                } else if (compareToValue == null) {
                    returnValue = 1;
                } else if (origValue > compareToValue) {
                    returnValue = 1 * direction;
                } else if (origValue < compareToValue) {
                    returnValue = -1 * direction;
                }
            } else {
                throw new UnsupportedSortTypeException(
                    'Unsupported sort type ' +
                    fieldType +
                    ' for field ' +
                    field
                );
            }

            return returnValue;
        }
    }

    private class SortKeyMember {
        String field;
        String direction;
    }
}
