global class SaveRecordsAsync {
    /**
     * Upserts a list of records asynchronously (outside of current transaction)
     * Original contribution by David Entremont (https://twitter.com/davidentremont)
     * Inputs:
     *   List<SObject> records
     * Outputs:
     *   Id jobId Id of the upsert job
     */
    @InvocableMethod(
        label='Saves a list of records asynchronously (outside of current transaction)'
        category='Data'
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
        UpsertRecordsQueueable job = new UpsertRecordsQueueable(input.records);
        Id jobId = System.enqueueJob(job);
        // Return output
        OutputParameters output = new OutputParameters();
        output.jobId = jobId;
        return output;
    }

    /**
     * Wrapper class for input parameters
     */
    global class InputParameters {
        @InvocableVariable(required=true)
        global List<SObject> records;
    }

    /**
     * Wrapper class for output parameters
     */
    global class OutputParameters {
        @InvocableVariable
        public Id jobId;
    }

    /**
     * Apex queueable job that upserts records
     */
    public class UpsertRecordsQueueable implements Queueable {
        private List<SObject> records;

        @TestVisible
        UpsertRecordsQueueable(List<SObject> records) {
            this.records = records;
        }

        public void execute(QueueableContext context) {
            upsert records;
        }
    }
}
