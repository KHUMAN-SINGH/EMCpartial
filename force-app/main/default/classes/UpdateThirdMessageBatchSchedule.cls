/**
 * @Author: GetonCRM Solutions LLP
 * @Description: This Batch is use for add 3rd Message if not in record else active those message record for display in new UI.
 * @Modification logs
 * ========================================================================================================================
 * @Date: 17 March 2023 | Niraj Sahedani
 */
public class UpdateThirdMessageBatchSchedule implements Schedulable{
    public void execute(SchedulableContext sc) {
        //Run this Schedule for every Month 1st,2nd day and 30,31 day 
        if(System.today().day() == 1 || System.today().day() == 30 || System.today().day() == 2 || System.today().day() == 31 || Test.isRunningTest()){
            UpdateThirdMessageBatch batch = new UpdateThirdMessageBatch();
            database.executebatch(batch);
        }
    }
}