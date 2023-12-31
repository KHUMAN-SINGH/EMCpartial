@isTest
public class NewdriverdashboardController_Test {
    public static testMethod void Method1() {
        TriggerConfig__c cusmsetting = TestDataFactory.triggerConfigCustomSetting(True);
         TrueDialog_Keys__c tdKeys = TestDataFactory.createTrueDialog(true);
        SendEmail__c  SendEmailcusmsetting = TestDataFactory.sendEmailCustomSetting(true, 'Send Email For Compliance');
        Vehicle_URL_Mapping__c vehicleType = TestDataFactory.createVehicleData(true, 3);
        IRS_Mileage_Rate__c createIRSRate = TestDataFactory.createIRSRate(true, 0);
        
        Account acc;
        List<Contact> con ;
        UserRole userRole = TestDataFactory.getUserRole();
        Profile profileObj = TestDataFactory.getUserProfile();
        User admin = TestDataFactory.getSystemAdminUser(userRole.Id);
        User userObj;
        
        System.runAs(admin) {
            acc = TestDataFactory.createAccount(True, 'Test Account', true);
            con = TestDataFactory.createDriverContact(true, acc.Id, 'Driver', vehicleType.Name, 'Paras.Patel', 2); 
            userObj = TestDataFactory.createUser(True, profileObj.Id, con[0].Id);
        }        
                
        List<Employee_Reimbursement__c> er = TestDataFactory.createPendingReimbursement(true, con, 0, createIRSRate.Id);          
        
        Test.startTest();
            Test.setCurrentPage(Page.Newdriverdashboard);
            ApexPages.CurrentPage().getParameters().put('id', con[0].Id);        
            NewdriverdashboardController testAccPlan = new NewdriverdashboardController();          
        Test.stopTest();
    }
    
}