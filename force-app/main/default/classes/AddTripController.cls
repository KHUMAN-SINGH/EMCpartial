public with sharing class AddTripController {

    @AuraEnabled
    public static List<Schema.Location> getLocationList(Id contactId) {
        
        List<Schema.Location> locationList= [SELECT Id, Address__c, Name 
            FROM Location WHERE Driver__c=:contactId WITH SECURITY_ENFORCED];

        return locationList;
    }
}