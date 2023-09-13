@isTest
public class UpdateActivityStatusInMlogBatchTest {
    @isTest
    public static void updateActivityStatusTest(){
        TriggerConfig__c customEmailSetting = TestDataFactory.triggerConfigCustomSetting(true);
        TrueDialog_Keys__c trueDialogCustom = TestDataFactory.createTrueDialog(true);
        Vehicle_URL_Mapping__c veh = TestDataFactory.createVehicleData(true,0);
        
        IRS_Mileage_Rate__c irsRate = TestDataFactory.createIRSRate(true,2023);

        Gas_Prices__c gasprice = new Gas_Prices__c();
        gasprice.City__c = 'Atlanta';
        gasprice.Fuel_Price__c = 3;
        gasprice.Month_Year__c = Date.today().adddays(-12);
        gasprice.State__c = 'AK';
        insert gasprice;

        UserRole uRole = TestDataFactory.getUserRole();
        Profile profileObj = TestDataFactory.getUserProfile();
        User admin = TestDataFactory.getSystemAdminUser(uRole.Id);
        User userObj;
        
        Account acc;
        List<Contact> conList = new List<Contact>();
        
        
        System.runAs(admin) {
            acc = TestDataFactory.createAccount(false,'Test',true);
            acc.Name = 'Test Accounts';
            acc.isUsingTriplog__c = true;
            insert acc;

            conList = TestDataFactory.createDriverContact(false,acc.Id,'Driver',veh.Name,'Priyanka',2);
            conList[0].Deactivated_Date__c = Null;
            conList[0].Insurance_Attachment_Id__c = Null;
            conList[0].Vehicle_Type__c = '2023 Mileage Rate';
            conList[0].Employee_ID__c = '234343456';
            conList[0].Time_Zone__c = 'US/Mountain';
            conList[0].Driver_Type__c = 'Driver - Full Time';
            conList[0].compliancestatus__c = 'Yes';
            conList[0].ReimbursementStatementBatch__c = true;            
            conList[0].Manager__c = null;   
            conList[0].Monthly_Mileage_Limit__c = -1;  
            conList[0].MailingState = 'AK';
            conList[0].MailingCity = 'Atlanta';
            conList[0].Activation_Date__c = System.today()-12;
            conList[0].Driving_States__c = 'TN';
            insert conList;
        }

        String lastMonth = Utils.fetchMonths(1, 0)[0];
        List<Employee_Reimbursement__c> er = TestDataFactory.createPendingReimbursement(False, conList, 1, irsRate.Id);
        er[0].Approved_Date__c = system.today()-4;
        er[0].Month__c = lastMonth;
        er[0].Status__c = 'Approved';
        Insert er[0];        

        List<Bi_Weekly_Reimbursement__c> br = TestDataFactory.createBiweeklyReim (true, conList, System.today().addDays(-26),System.today().addDays(-13), 1, irsRate.Id);
        List<Employee_Mileage__c> emp1 = TestDataFactory.getEmpMileage (True, 0, er, br);
        emp1[0].Trip_Date__c =  date.today().adddays(-1);
        emp1[0].Trip_Status__c = 'Approved';
        emp1[0].Approved_Date__c = system.today();
        Update emp1;

        Set<Id> recordIds = new Set<Id>();
        recordIds.add(er[0].Id);

        Test.startTest();
        UpdateActivityStatusInMlogBatch b = new UpdateActivityStatusInMlogBatch(recordIds);
        database.executeBatch(b);
        Test.stopTest();
    }
}