public with sharing class updateMilegesRecord {
    @AuraEnabled
    public static void updateMilegesDetail(String id , String tags , String notes , Integer staytime ) {
        list<Employee_Mileage__c> accts = new List<Employee_Mileage__c>();
        Employee_Mileage__c emp_mileges = new Employee_Mileage__c();
            emp_mileges.id = id;
            emp_mileges.Notes__c = notes;
            emp_mileges.Tag__c = tags;
            emp_mileges.Stay_Time__c = staytime;
        accts.add(emp_mileges);
        if(accts.size()> 0){
            update accts;
            
        }
    }

    @AuraEnabled
    public static void updateStatusOfMileges(List<id> id , String updatetext ) {
        List<Employee_Mileage__c> Employee_Mileage = [SELECT id, Trip_Status__c FROM Employee_Mileage__c WHERE Id IN :id];
        List<Employee_Mileage__c> listofemployee = new List<Employee_Mileage__c>();
        for(Employee_Mileage__c emp_mileges : Employee_Mileage){
            emp_mileges.Trip_Status__c = updatetext;
            listofemployee.add(emp_mileges);
        }
        system.debug('listof employee-->'+listofemployee);
        if(listofemployee.size()> 0){
            update listofemployee;
        }
    }

    @AuraEnabled
    public static void deleteMileges(List<id> id ) {
        // List<Employee_Mileage__c> Employee_Mileage = [SELECT Id FROM Employee_Mileage__c WHERE Id IN :id];
        // List<Employee_Mileage__c> listofemployee = new List<Employee_Mileage__c>();
        // for(Employee_Mileage__c emp_mileges : Employee_Mileage){
        //     listofemployee.add(emp_mileges);
        // }
        // system.debug('listof employee-->'+listofemployee);
        // if(listofemployee.size()> 0){
        //     delete listofemployee;
        // }


        Employee_Mileage__c[] deletemilege = [SELECT Id FROM Employee_Mileage__c WHERE Id IN :id]; 
        try {
            delete deletemilege;
        } catch (DmlException e) {
            // Process exception here
        }
    }

    
}