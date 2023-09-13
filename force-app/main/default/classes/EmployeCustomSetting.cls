public with sharing class EmployeCustomSetting {
    @AuraEnabled(cacheable=true)
    public static List<EmployeeFieldSetting__c> getCustomSettings() {
        return EmployeeFieldSetting__c.getAll().values();
    }
}