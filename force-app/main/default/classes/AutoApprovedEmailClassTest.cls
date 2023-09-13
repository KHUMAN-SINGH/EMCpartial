@isTest
public class AutoApprovedEmailClassTest {
    public static testmethod void test1() {
       
        TriggerConfig__c triggerCustomSetting = TestDataFactory.triggerConfigCustomSetting(true);
        triggerCustomSetting.mileageremoveapprovaldate__c = false;
        triggerCustomSetting.MappingGasPriceTrigger__c = false;
        triggerCustomSetting.MappingGasPriceTriggerUpdateConvertedDat__c = false;
        Update triggerCustomSetting;

        SendEmail__c customSetting2 = TestDataFactory.sendEmailCustomSetting(true, 'Send Email For Compliance');
        SendEmail__c customSetting3 = TestDataFactory.sendEmailCustomSetting(true, 'EmployeeReimbursementTrigger');
        SendEmailToMe__c customSetMail = TestDataFactory.sendEmailToMeCustomSetting(true, 'Defaulttrigger');
        Vehicle_URL_Mapping__c vehicleType = TestDataFactory.createVehicleData(true, 3);
        IRS_Mileage_Rate__c createIRSRate = TestDataFactory.createIRSRate(true, 0);

        UserRole userRole = TestDataFactory.getUserRole();
        Profile profileObj = TestDataFactory.getUserProfile();
        User admin = TestDataFactory.getSystemAdminUser(userRole.Id);
        User userObj;
        Account acc ;
        List<Contact> conList;
       
        System.runAs(admin) {
            Account accountObj = TestDataFactory.createAccount(true,'Test',true);
            Contact contactObj = TestDataFactory.createCICDContact(true,accountObj.Id);

            acc = TestDataFactory.createAccount(true,'Test Account',true);
            acc.Triplog_API__c = 'fde76cdde14449bea46b321225ac8fd1';
            acc.Pay_Period_Start_Date__c = System.today().addDays(-100);
            acc.Pay_Period_Days__c = 13;
            acc.Motor_Vehicle_Record_Check_Document__c = true;
            acc.Enable_Email_For_Managers__c = true;
            acc.Approval_Template_Message__c = 'test message';
            update acc;
           
            conList = TestDataFactory.createDriverContact(false, acc.Id, 'Driver/Admin', vehicleType.Name, 'paras.dhanani',  3);
            conList[0].Vehicle_Type__c = vehicleType.Name;
            conList[0].External_Email__c = 'minkesh.patel1478@gmail.com';
            conList[0].Deactivated_Date__c = Date.today().addMonths(4);
            Insert conList;
            
            conList = TestDataFactory.createDriverContact(false, acc.Id, 'Driver', vehicleType.Name, 'paras.dhanani22',  3);
            conList[0].Manager__c = conList[0].Id;
            Insert conList;
            
            conList = TestDataFactory.createDriverContact(false, acc.Id, 'Manager', vehicleType.Name, 'paras.dhanani1',  3);
            conList[0].Vehicle_Type__c = vehicleType.Name;
            Insert conList;           
            
            userObj = TestDataFactory.createUser(True, profileObj.Id, conList[0].Id);
        }

        String tempDate = date.today().addMonths(-1).Month() + '-' + date.today().addMonths(-1).Year();
        String lastMonth = tempDate.left(2);

        if(lastMonth.contains('-')) {
            lastMonth = '0' + tempDate;
        } else {
            lastMonth = tempDate;
        }
     List<Employee_Reimbursement__c> er = TestDataFactory.createPendingReimbursement(False, conList, 1, createIRSRate.Id);
        er[0].Approved_Date__c = system.today()-4;
        er[0].Month__c = lastMonth;
        er[0].Status__c = 'Approved';
        Insert er[0];
        
        List<Bi_Weekly_Reimbursement__c> br = TestDataFactory.createBiweeklyReim (true, conList, System.today().addDays(-26),System.today().addDays(-13), 1, createIRSRate.Id);
             
        List<Employee_Mileage__c> emp1 = TestDataFactory.getEmpMileage (False, 0, er, br);
        emp1[0].Trip_Status__c = 'Approved';
        emp1[0].Approved_Date__c = system.today();
        Insert emp1;

        Test.startTest();
        AutoApprovedEmailClass batchcon = new AutoApprovedEmailClass();
        DataBase.executeBatch(batchcon, 1);
        batchcon.CreateHtml(conList[2],er[0],23.23,false,'test');
        Test.stopTest();
    }
}