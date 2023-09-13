global class HelloSignAdminSignatureRequestBatch implements Database.Batchable<sObject>, Database.AllowsCallouts {
    global Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator('');
    }
    global void execute(Database.BatchableContext bc, List<contact> records){
        try{
        }catch(Exception e){
            System.debug('Exception:- '+e.getmessage()+' - Line:-'+e.getLineNumber());
        }
    }    
    global void finish(Database.BatchableContext bc){
    }    
}