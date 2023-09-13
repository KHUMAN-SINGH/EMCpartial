/**
 * @Author: GetonCRM Solutions LLP
 * @Description: This Batch is use for add 10th Message for Manager and it's display Daily
 * @Modification logs
 * ========================================================================================================================
 * @Date: 17 March 2023 | Niraj Sahedani
 */
public class UpdateTenthMessageBatchSchedule implements Schedulable{
    public void execute(SchedulableContext sc) {
        UpdateTenthMessageBatch batch = new UpdateTenthMessageBatch();
        database.executebatch(batch);
    }
}