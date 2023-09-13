/**
 * @Author: GetonCRM Solutions LLP
 * @Description: This Batch is use for add 6th Message upto 18th day or lock date is available and it's use for flagged mileages
 * @Modification logs
 * ========================================================================================================================
 * @Date: 17 March 2023 | Niraj Sahedani
 */
public class UpdateSeventhMessageBatchSchedule implements Schedulable{
    public void execute(SchedulableContext sc) {
        //Run this batch for after 18th day or more and for 1st,2nd and 3rd day of month
        if(System.today().day() >= 18 || System.today().day() <= 3){
            UpdateSeventhMessageBatch batch = new UpdateSeventhMessageBatch();
            database.executebatch(batch);
    }
        }
        
}