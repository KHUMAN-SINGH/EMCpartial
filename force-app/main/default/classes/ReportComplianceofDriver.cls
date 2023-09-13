public with sharing class ReportComplianceofDriver 
{
    public static Integer AccountYear{get;set;} 
    public ReportComplianceofDriver() 
    {
        List<Account> accList = [SELECT id,name,CreatedDate FROM Account WHERE id =:getAccountid()];
        AccountYear = Date.valueof(accList[0].CreatedDate).year();
    }
    public static String getAccountid() {
        if (ApexPages.currentPage().getParameters().containsKey('accid')) {
            return ApexPages.currentPage().getParameters().get('accid');
        } else {
            return '';
        }
    }
    
    @AuraEnabled(cacheable = true)
    public static Integer complianceYear(String accountId){
        List<Account> accList = [SELECT id,name,CreatedDate FROM Account WHERE id =: accountId];
        Integer accYear = Date.valueof(accList[0].CreatedDate).year();
        return accYear;
    }
    public static String getContactid() {
        if (ApexPages.currentPage().getParameters().containsKey('id')) {
            return ApexPages.currentPage().getParameters().get('id');
        } else {
            return '';
        }
    }
    public static String getReportid() {
        if (ApexPages.CurrentPage().getparameters().containsKey('reportid')) {
            return ApexPages.currentPage().getParameters().get('reportid');
        } else {
            return '';
        }
    }
    public static PageReference getRedirected() {

        if (getContactid() != '' && getAccountid() != '' && getReportid()!='') {
            return null;
        } else {
// redirect to error page
            return null;
        }

    }
    public static string getAllDrivers()
    {           
        String query = 'Select id,Name from Contact where accountid=\''+getAccountid()+'\'and (Role__c = \''+StaticValues.roleAdminDriver+'\' OR Role__c=\'Driver/Manager'+'\' OR Role__c=\'Driver'+'\')';
        List<Contact> driverslist = new List<Contact>();
        driverslist = (List<Contact>)ExecuteQueryUtil.getListFromMap(ExecuteQueryUtil.getRecordMapWithSinglesObject(query));
        return JSON.serialize(driverslist);
        return '';
    }
    @AuraEnabled(cacheable = true)
    public static string getDriversDetails(String accountId)
    {           
        String query = 'Select id,Name from Contact where accountid=\''+accountId+'\'and (Role__c = \''+StaticValues.roleAdminDriver+'\' OR Role__c=\'Driver/Manager'+'\' OR Role__c=\'Driver'+'\')';
        List<Contact> driverslist = new List<Contact>();
        driverslist = (List<Contact>)ExecuteQueryUtil.getListFromMap(ExecuteQueryUtil.getRecordMapWithSinglesObject(query));
        return JSON.serialize(driverslist);
        return '';
    }
    @RemoteAction
    public static List<String> getCompliance(String did,String year)
    {
        return WrapperUtils.getComplianceCalculation(did,year);
    }
    
    @AuraEnabled(cacheable = true)
    public static List<String> getComplianceCalculation(String did,String year)
    {
        return WrapperUtils.getComplianceCalculation(did,year);
    }
}