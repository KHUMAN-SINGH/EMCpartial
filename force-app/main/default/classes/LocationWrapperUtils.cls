public with sharing class LocationWrapperUtils {
    public LocationWrapperUtils() {}

    @AuraEnabled(cacheable=true)
    public static String getLocations(String contactId) {       
        List<Schema.Location> locationsList = [Select Id,Name,Address__c,Driver__c,Range__c from Location where Driver__c =: contactId];
        
        System.debug('json data: '+JSON.serialize(locationsList).unescapeHtml4());
         
        return JSON.serialize(locationsList).unescapeHtml4();
    }
}