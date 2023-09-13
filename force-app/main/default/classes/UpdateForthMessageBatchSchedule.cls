/**
 * @Author: GetonCRM Solutions LLP
 * @Description: This Batch is use for add 4th Message if not in record else active those message record for display in new UI.
 * @Modification logs
 * ========================================================================================================================
 * @Date: 17 March 2023 | Niraj Sahedani
 */
public class UpdateForthMessageBatchSchedule implements Schedulable{
    public void execute(SchedulableContext sc) {
        //Run this Method for Every Month 1st and 31st day
        if(System.today().day() == 1 || System.today().day() == 31 || Test.isRunningTest()){
            UpdateForthMessageBatch batch = new UpdateForthMessageBatch();
            database.executebatch(batch);
        }
        
    }
}