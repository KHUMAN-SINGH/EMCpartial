public with sharing class saveReimbursementRadioValue {
    public string id{get;set;}
    public Contact con{get;set;}

    public saveReimbursementRadioValue(ApexPages.StandardController controller){
        id = ApexPages.currentPage().getParameters().get('id'); 
        updateRadioBtn(id);
    }
    

    public void updateRadioBtn(String id) {   
        

        con = [Select Id, Name, Biweek_Reimbursement__c,Monthly_Reimbursement__c from Contact where Id =: id];
        System.debug('con: '+con);

    }
}