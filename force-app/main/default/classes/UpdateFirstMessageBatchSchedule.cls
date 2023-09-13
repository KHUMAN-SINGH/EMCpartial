/**
 * @Author: GetonCRM Solutions LLP
 * @Description: This Batch is use for add 1st Message if not in record else active those message record for display in new UI.
 * @Modification logs
 * ========================================================================================================================
 * @Date: 17 March 2023 | Niraj Sahedani
 */
public class UpdateFirstMessageBatchSchedule implements Schedulable{
    public void execute(SchedulableContext sc) {

        //This Schedule run for every every 5 days before 4th day of every month (eg:30,31,01,02,03)
        //We use this condition System.today().day() == dayVal for deactivate message to display on UI 
        
        Integer dayVal = 4;
        if((System.today().adddays(5)).day() == dayVal || (System.today().adddays(4)).day() == dayVal || (System.today().adddays(3)).day() == dayVal || (System.today().adddays(2)).day() == dayVal || (System.today().adddays(1)).day() == dayVal || System.today().day() == dayVal || Test.isRunningTest()){
            UpdateFirstMessageBatch batch = new UpdateFirstMessageBatch();
            database.executebatch(batch);
        }
        
    }
}