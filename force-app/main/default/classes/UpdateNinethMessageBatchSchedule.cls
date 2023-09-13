/**
 * @Author: GetonCRM Solutions LLP
 * @Description: This Batch is use for add 9th Message for Manager and it's display 1 to 3rd day of month
 * @Modification logs
 * ========================================================================================================================
 * @Date: 17 March 2023 | Niraj Sahedani
 */
public class UpdateNinethMessageBatchSchedule implements Schedulable{
    public void execute(SchedulableContext sc) {
        if(System.today().day() >= 1 || System.today().day() <= 3){
            UpdateNinethMessageBatch batch = new UpdateNinethMessageBatch();
            database.executebatch(batch);
        }
       
    }
}