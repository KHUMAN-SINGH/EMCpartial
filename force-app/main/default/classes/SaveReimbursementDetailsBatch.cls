public class SaveReimbursementDetailsBatch implements Database.Batchable<sObject>{
    // public static List<Id> reimListId = new List<Id>();

    public List<String> months;
    public Boolean savePrevMonth;

    // Pass month List on 1st Parameter
    // Pass true on second Param if we need to save approve date and status value on new fields
    // Pass false on second Param if we need to revert pprove date and status value on original fields

    public SaveReimbursementDetailsBatch(List<String> monthsLst, Boolean savePrevMonthVal){
        months = monthsLst;
        savePrevMonth = savePrevMonthVal;
    }

    public static String lblValue = system.Label.TripstobeLogged;
    public static List<String> lstLblValue = lblValue.split(',');

    public List<General_Query__mdt> start(Database.BatchableContext bc){
        List<General_Query__mdt> metaValue = [SELECT id,Test_Query__c,savePrevMonthVal__c,revertReimVal__c FROM General_Query__mdt];
        return metaValue;
    }

    public void execute(Database.BatchableContext bc, List<General_Query__mdt> metaValue) {
        List<Employee_Reimbursement__c> reimListToUpdate = new List<Employee_Reimbursement__c>();
        // System.debug('metaValue: '+metaValue);

        // this if Run for store approve date and status value on new fields
        // for active this block pass true on Second Parameter 
        if(savePrevMonth == true){
            
            // Here We Add Dynamic Query from General_Query__mdt metadata and query value store in savePrevMonthVal__c field
            // for(Employee_Reimbursement__c reimList : [Select id,Name,Month__c,Status__c,Prev_Approved_Date_Value__c,Prev_Status_Value__c, Approved_Date__c,Mileage_Lock_Date__c,Contact_Id__r.Account.isUsingTriplog__c  from Employee_Reimbursement__c where Month__c IN: months and Contact_Id__r.Account.isUsingTriplog__c = true and Contact_Id__r.Account.Name IN : lstLblValue and (Status__c = 'Approved' OR Mileage_Lock_Date__c != null)]){
            for(Employee_Reimbursement__c reimList : Database.query(metaValue[0].savePrevMonthVal__c)){
                // System.debug('reimList: '+reimList);
                reimList.Prev_Approved_Date_Value__c = reimList.Approved_Date__c;
                reimList.Prev_Status_Value__c = reimList.Status__c;
                reimList.Approved_Date__c = null;
                reimList.Status__c = 'Pending';
                reimList.Mileage_Lock_Date__c = null;
                reimListToUpdate.add(reimList);
            }
            if(!reimListToUpdate.isEmpty()){
                update reimListToUpdate;
            } 
        } else{
            // this else Run for revert approve date and status value on original fields
            // for active this block pass false on Second Parameter 
            for(Employee_Reimbursement__c reimList : Database.query(metaValue[0].revertReimVal__c)){
                // System.debug('reimList: '+reimList);
                reimList.Approved_Date__c = reimList.Prev_Approved_Date_Value__c;
                reimList.Status__c = reimList.Prev_Status_Value__c;
                reimList.Prev_Approved_Date_Value__c = null;
                reimList.Prev_Status_Value__c = null;
                reimListToUpdate.add(reimList);
            }
            if(!reimListToUpdate.isEmpty()){
                update reimListToUpdate;
            } 
        } 
    }

    public void finish(Database.BatchableContext bc){}

    // public static General_Query__mdt metaValue = [SELECT id,Test_Query__c,savePrevMonthVal__c,revertReimVal__c FROM General_Query__mdt];

    /* public static void savePrevMonthVal(List<String> months){
        List<Employee_Reimbursement__c> reimListToUpdate = new List<Employee_Reimbursement__c>();

        String lblValue = system.Label.TripstobeLogged;
        List<String> lstLblValue = lblValue.split(',');

        // Here We Add Dynamic Query from General_Query__mdt metadata and query value store in savePrevMonthVal__c field
        // for(Employee_Reimbursement__c reimList : [Select id,Name,Month__c,Status__c,Prev_Approved_Date_Value__c,Prev_Status_Value__c, Approved_Date__c,Mileage_Lock_Date__c,Contact_Id__r.Account.isUsingTriplog__c  from Employee_Reimbursement__c where Month__c IN: months and Contact_Id__r.Account.isUsingTriplog__c = true and Contact_Id__r.Account.Name IN : lstLblValue and (Status__c = 'Approved' OR Mileage_Lock_Date__c != null)]){
        for(Employee_Reimbursement__c reimList : Database.query(metaValue.savePrevMonthVal__c)){
            // System.debug('reimList: '+reimList);
           
            reimList.Prev_Approved_Date_Value__c = reimList.Approved_Date__c;
            reimList.Prev_Status_Value__c = reimList.Status__c;
            reimList.Approved_Date__c = null;
            reimList.Status__c = 'Pending';
            reimList.Mileage_Lock_Date__c = null;
            reimListToUpdate.add(reimList);
        }
        if(!reimListToUpdate.isEmpty()){
            update reimListToUpdate;
        }
    }

    public static void revertReimVal(List<String> months){
        List<Employee_Reimbursement__c> reimListToUpdate = new List<Employee_Reimbursement__c>();

        // Here We Add Dynamic Query from General_Query__mdt metadata and query value store in revertReimVal__c field
        // for(Employee_Reimbursement__c reimList : [Select id,Name,Month__c,Status__c,Prev_Approved_Date_Value__c,Prev_Status_Value__c, Approved_Date__c,Mileage_Lock_Date__c,Contact_Id__r.Account.isUsingTriplog__c  from Employee_Reimbursement__c where Month__c IN: months and Contact_Id__r.Account.isUsingTriplog__c = true and Contact_Id__r.Account.Name IN : lstLblValue and Prev_Approved_Date_Value__c != null and Prev_Status_Value__c != null]){
        for(Employee_Reimbursement__c reimList : Database.query(metaValue.revertReimVal__c)){
            // System.debug('reimList: '+reimList);
            reimList.Approved_Date__c = reimList.Prev_Approved_Date_Value__c;
            reimList.Status__c = reimList.Prev_Status_Value__c;
            reimList.Prev_Approved_Date_Value__c = null;
            reimList.Prev_Status_Value__c = null;
            reimListToUpdate.add(reimList);
        }
        if(!reimListToUpdate.isEmpty()){
            update reimListToUpdate;
        }
    }*/
}