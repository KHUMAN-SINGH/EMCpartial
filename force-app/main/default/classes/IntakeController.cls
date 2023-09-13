public without sharing class IntakeController {
    public string insurance {get; set;}
    public IntakeController (){
        insurance = getInsuranceMinimum();
    }
    @RemoteAction
    public static Id readFromFile(String file,String accountId, String adminId) {       
        Id batchId;
        ImportContactdatafromCSVController batch = new ImportContactdatafromCSVController(file, accountId, adminId);      
        batchid = Database.executebatch(batch,101);
        return batchid;
    }
    @RemoteAction
    public static PollarResponse CheckStatus(id batchId) {
        AsyncApexJob aaj = [SELECT Id, Status, JobItemsProcessed, TotalJobItems, NumberOfErrors
                    FROM AsyncApexJob WHERE ID =: batchid];
        PollarResponse res = new PollarResponse();
        res.enablePollar = true;
        if(aaj != null) {
            if(aaj.status == 'Completed' || aaj.status == 'Failed'){
                res.enablePollar = false;
            }             
            res.message = aaj.status;
        }
        return res;
    }
    public static String getInsuranceMinimum() {
        List<String> roleList = new List<String>();
        Schema.DescribeFieldResult fieldResult = Account.Insurance_Minimum__c.getDescribe();
        List<Schema.PicklistEntry> pickListEntries = fieldResult.getPicklistValues();
        for(Schema.PicklistEntry currentEntries : pickListEntries)
        {
            roleList.add(currentEntries.getValue());
        }
        return JSON.serialize(roleList);     
    }
    public class PollarResponse {
        public Boolean enablePollar;
        public String Message;
    }
    
}