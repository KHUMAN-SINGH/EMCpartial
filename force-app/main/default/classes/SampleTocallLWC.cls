public with sharing class SampleTocallLWC {
    public SampleTocallLWC() {

    }

    @AuraEnabled
    public static string getStr(){
        try {
            String str = 'working..!';
            return str;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}