@isTest(isParallel=true)
global class CalculateBusinessHoursTests {
    @isTest
    global static void bulkInvoke_works() {
        BusinessHours businessHours = [
            SELECT Id
            FROM BusinessHours
            WHERE Name = 'Default'
            LIMIT 1
        ];
        DateTime startDate = DateTime.newInstance(2020, 3, 27);
        DateTime endDate = startDate.addDays(1);

        CalculateBusinessHours.InputParameters input = new CalculateBusinessHours.InputParameters();
        input.businessHoursId = businessHours.Id;
        input.startDate = startDate;
        input.endDate = endDate;
        List<CalculateBusinessHours.InputParameters> inputs = new List<CalculateBusinessHours.InputParameters>{
            input
        };

        List<CalculateBusinessHours.OutputParameters> outputs = CalculateBusinessHours.bulkInvoke(
            inputs
        );

        System.assertEquals(1, outputs.size());
        CalculateBusinessHours.OutputParameters output = outputs[0];
        System.assertEquals(24 * 60 * 60 * 1000, output.durationMs);
        System.assertEquals(24 * 60 * 60, output.durationSec);
        System.assertEquals(24 * 60, output.durationMin);
        System.assertEquals(24, output.durationHours);
        System.assertEquals(1, output.durationDays);
    }
}
