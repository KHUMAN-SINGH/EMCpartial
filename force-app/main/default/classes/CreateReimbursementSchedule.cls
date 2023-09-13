public class CreateReimbursementSchedule implements Schedulable {
    public static final String JOB_NAME = 'EVERY_14_DAYS_JOB';
    
    public void execute(System.SchedulableContext sc) {
    //global void execute(SchedulableContext sc) {
        CreateReimbursement reimbursementtobecreated = new CreateReimbursement(); 
        Database.executeBatch(reimbursementtobecreated, 1);
        
        System.abortJob(sc.getTriggerId());

        Datetime workTime = System.now().addDays(13);
        String CRONEXP = '' + workTime.second() + ' ' + workTime.minute() + ' ' + workTime.hour()
                + ' ' + workTime.day() + ' ' + workTime.month() + ' ? ' + workTime.year();

        System.schedule(JOB_NAME, CRONEXP, new CreateReimbursementSchedule());
    }
}