public with sharing class TestReportController {
    @AuraEnabled(cacheable=true)
    public static string fetchMileagesSize(){
    
            List<Employee_Mileage__c> mileageList = new List<Employee_Mileage__c>();
 mileageList = [SELECT id,Name,EmployeeReimbursement__r.Contact_Id_Name__c,
                        Stay_Time__c, Driving_Time__c,Trip_Date__c,
                        EmployeeReimbursement__r.Contact_Id__r.Vehicle_Type__c,
                        Mileage__c,Trip_Origin__c, Trip_Destination__c,
                        Origin_Name__c, Destination_Name__c,ConvertedStartTime__c,
                        ConvertedEndTime__c,Notes__c,Triplog_Map__c,Day_Of_Week__c,
                        Trip_Status__c,EmployeeReimbursement__r.Contact_Id__r.External_Email__c,
                        From_Location__Latitude__s, From_Location__Longitude__s,
                        To_Location__Latitude__s, To_Location__Longitude__s,
                        Tracing_Style__c,Trip_Id__c,Way_Points__c,Tag__c,Activity__c,
                        EmployeeReimbursement__r.Contact_Id__r.Account.Triplog_API__c,
                        TimeZone__c,EmployeeReimbursement__r.Month__c,Drive_Stay_Time__c,
                        StartTime__c, EndTime__c,EMP_Mileage__c 
                    FROM Employee_Mileage__c
                
                    order by ConvertedStartTime__c asc 
                    limit 2000
                    ];
                   
                     return JSON.serialize(mileageList ); 

    }

    @AuraEnabled(cacheable=true)
    public static String getManager(String did, String accid) {
        
        List<Contact> adminContact = new List<Contact>();
        if(accid == '0013r00002D3DlPAAV'){
            //This is for Anton Paar account
            adminContact = [SELECT id, Name, Email, Accountid FROM Contact WHERE Accountid =: accid AND (Deactivated_Date__c = null OR Deactivated_Date__c > TODAY) AND (Role__c='Manager' OR Role__c='Driver/Manager' OR Role__c = 'Admin')];
        }
        else {
            adminContact = [SELECT id, Name, Email, Accountid FROM Contact WHERE Accountid =: accid AND (Deactivated_Date__c = null OR Deactivated_Date__c > TODAY) AND (Role__c='Manager' OR Role__c='Driver/Manager')];
        }
        return String.escapeSingleQuotes(JSON.serialize(adminContact));
    }  
    
    @AuraEnabled(cacheable=true)
    public static String getChartData(String did,String showteam,String accid) {
        return WrapperUtils.getChartData(did,boolean.valueOf(showteam),accid,'Admin');
    }  
}