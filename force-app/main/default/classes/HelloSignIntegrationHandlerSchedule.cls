global class HelloSignIntegrationHandlerSchedule implements Schedulable {
    String emailId;
    Id batchprocessid;
    public HelloSignIntegrationHandlerSchedule (string email){
        this.emailId = email;
    }
    global void execute(SchedulableContext sc) {
        HelloSignIntegrationHandlerBatch batch = new HelloSignIntegrationHandlerBatch(emailId);
        database.executebatch(batch);
        // ID batchprocessid = Database.executeBatch(tripBtc,1);
    }

    // global void finish(Database.BatchableContext BC)
    // {
    //     // Get the ID of the AsyncApexJob representing this batch job from Database.BatchableContext.
    //     // Query the AsyncApexJob object to retrieve the current job's information.
    //     System.debug('Run finish method');
    //     AsyncApexJob a = [SELECT Id, Status, NumberOfErrors, JobItemsProcessed, TotalJobItems FROM AsyncApexJob WHERE Id =:BC.getJobId()];

    //     //then use the active job id and abort it
    //     system.abortJob(a.id);
    //     System.debug('Run finish method after abort');
    // }
}