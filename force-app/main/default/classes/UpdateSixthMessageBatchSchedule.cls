/**
 * @Author: GetonCRM Solutions LLP
 * @Description: This Batch is use for add 6th Message upto 18th day or lock date is available and it's use for flagged mileages
 * @Modification logs
 * ========================================================================================================================
 * @Date: 17 March 2023 | Niraj Sahedani
 */
public class UpdateSixthMessageBatchSchedule implements Schedulable{
    public void execute(SchedulableContext sc) {
        //Run this Batch for Every day
        UpdateSixthMessageBatch batch = new UpdateSixthMessageBatch();
        database.executebatch(batch);
    }
}