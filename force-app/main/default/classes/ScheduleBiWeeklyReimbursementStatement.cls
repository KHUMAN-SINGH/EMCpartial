global class ScheduleBiWeeklyReimbursementStatement implements Schedulable	{
    public static final String JOB_NAME = 'Biweekly Reimbursement Pay Statement';
    
    global void execute(SchedulableContext sc) {
        BiWeeklyReimbursementStatement biweeklyReimStetement = new BiWeeklyReimbursementStatement(); 
        Database.executeBatch(biweeklyReimStetement, 1);
        
        System.abortJob(sc.getTriggerId());

        Datetime workTime = System.now().addDays(1);
        String CRONEXP = '' + workTime.second() + ' ' + workTime.minute() + ' ' + workTime.hour()
                + ' ' + workTime.day() + ' ' + workTime.month() + ' ? ' + workTime.year();

        System.schedule(JOB_NAME, CRONEXP, new ScheduleBiWeeklyReimbursementStatement());
    }
}