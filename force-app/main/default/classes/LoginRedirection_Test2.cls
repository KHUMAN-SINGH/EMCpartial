@isTest
public with sharing class LoginRedirection_Test2 {
    @isTest
    public static void utilMethod1()     {
        TriggerConfig__c triggerCustomSetting = TestDataFactory.triggerConfigCustomSetting(true);
        SendEmail__c customSetting2 = TestDataFactory.sendEmailCustomSetting(true, 'Send Email For Compliance');
        Vehicle_URL_Mapping__c vehicleType = TestDataFactory.createVehicleData(true, 3);
        IRS_Mileage_Rate__c createIRSRate = TestDataFactory.createIRSRate(true, 0);
        TrueDialog_Keys__c tdKeys = TestDataFactory.createTrueDialog(true);
        
        UserRole userRole = TestDataFactory.getUserRole();
        User admin = TestDataFactory.getSystemAdminUser(userRole.Id);
        
        System.runAs(admin) {
            
        Account acc = new Account();     
        List<Contact> conList = new List<Contact>(); 
        
        Profile profileObj = TestDataFactory.getUserProfile();
        User userObj;
         //Id accCustomLabel = system.lable.ERMI_Account;
         acc = TestDataFactory.createAccount(False, 'Test Account', True);
         acc.MburseDashboardRedirect__c = true;
         Insert acc;
         conList = TestDataFactory.createDriverContact(false, acc.Id, 'Driver', vehicleType.Name, 'Paras.Patel', 2);
         //conList[0].accountId = System.label.ERMI_Account;
         conList[0].IsCreatedFromCommunity__c = false;
         Insert conList[0];
         system.assertEquals(2, conList.size(), true);
          
         userObj = TestDataFactory.createUser(True, profileObj.Id, conList[0].Id);
            
        List<User> u = [Select id from User WHERE Profile.name='Customer Community Login User - Manager' and IsActive = true limit 1];
        Test.startTest();
        System.runAs(u[0]) {
          
            Contact obj = [select id from contact limit 1];
            ApexPages.currentPage().getParameters().put('id',obj.Id);
            LoginRedirection objLoginRedirection = new LoginRedirection();
            objLoginRedirection.redirectOnPage();
              
          }
    Test.stopTest();
        }
    }

}