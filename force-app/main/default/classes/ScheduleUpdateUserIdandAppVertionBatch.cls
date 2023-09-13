/*
 * @Author:  GetonCRM Solutions LLP
 * @Description:  Schedule class for run a Batch class on every day.
 * ------------------------------------------------------------------------------------------------------------------------
 * @Modification Logs
 * ------------------------------------------------------------------------------------------------------------------------
 * @version 1.1   - @Author:  Paras Dhanani - 01 September 2022
 */
global class ScheduleUpdateUserIdandAppVertionBatch implements Schedulable {
    global void execute(SchedulableContext sc) {
        UpdateUserIdandAppVertionBatch objbatch = new UpdateUserIdandAppVertionBatch();
        Database.executeBatch(objbatch,1);
    }
}