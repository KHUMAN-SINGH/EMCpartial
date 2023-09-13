@isTest
public class GetTripBatchClassTest {
    @isTest
    public static void getTriptest() {
        TrueDialog_Keys__c tdKeys = TestDataFactory.createTrueDialog(true);
        TriggerConfig__c triggerCustomSetting = TestDataFactory.triggerConfigCustomSetting(true);
        Vehicle_URL_Mapping__c vehicleType = TestDataFactory.createVehicleData(true, 3);
        SendEmailToMe__c customSetMail = TestDataFactory.sendEmailToMeCustomSetting(true, 'GetTripCallOutApprovePutCall');
        IRS_Mileage_Rate__c createIRSRate = TestDataFactory.createIRSRate(true, 0);
        daylight_saving_time_config__c daylightsetting = new daylight_saving_time_config__c();
        daylightsetting.Name = '2022';
        daylightsetting.Start_Date__c = date.valueof('2022-03-13');
        daylightsetting.End_Date__c = date.valueof('2022-06-11');
        insert daylightsetting;
        
        List<Id> contactids = new List<Id>();
        UserRole userRole = TestDataFactory.getUserRole();
        Profile profileObj = TestDataFactory.getUserProfile();
        User admin = TestDataFactory.getSystemAdminUser(userRole.Id);
        User userObj;
        Account acc ;
        List<Contact> conList;
        
        System.runAs(admin) {
            Account accountObj = TestDataFactory.createAccount(true,'Delta account',true);
            Contact contactObj = TestDataFactory.createCICDContact(true,accountObj.Id);
            
            acc = TestDataFactory.createAccount(true,'Delta account',true);
            acc.Triplog_API__c = 'fde76cdde14449bea46b321225ac8fd1';
            acc.Pay_Period_Start_Date__c = System.today().addDays(-100);
            acc.Pay_Period_Days__c = 13;
            update acc;
            
            conList = TestDataFactory.createDriverContact(true, acc.Id, 'Driver', vehicleType.Name, 'paras.dhanani',  1);
            conList[0].Vehicle_Type__c = vehicleType.Name;
            conList[0].isCommunityUser__c = true;
            conList[0].External_Email__c = 'minkesh.patel1478@gmail.com';
            update conList[0];
            contactids.add(conList[0].Id);
            
            userObj = TestDataFactory.createUser(True, profileObj.Id, conList[0].Id);
        }
        List<Employee_Reimbursement__c> er = TestDataFactory.createPendingReimbursement(False, conList, 1, createIRSRate.Id);
        er[0].Month__c = getLastMonthValue(-1);
        er[0].Status__c = 'Pending';
        Insert er[0];
        
        List<Bi_Weekly_Reimbursement__c> br = TestDataFactory.createBiweeklyReim (true, conList, System.today().addDays(-26),System.today().addDays(-13), 1, createIRSRate.Id);
        br[0].Status__c = 'Pending';
        update br;
        system.System.debug('br==' + br.size());
        List<Employee_Mileage__c> emp1 = TestDataFactory.getEmpMileage (false, 0, er, br);
        system.System.debug('br==' + br);
        emp1[0].Trip_Status__c = 'Not Approved Yet';
        emp1[0].Trip_Date__c = system.today().adddays(-100);
        System.debug('emp1==' + emp1);
        //emp1[0].EmployeeReimbursement__c = er[0].id;
        //emp1[0].Bi_Weekly_Reimbursement__c = br[0].id;
        Insert emp1;
        System.debug('emp1==' + emp1);
        
        Test.startTest();
        Test.SetMock(HttpCalloutMock.class, new GetTripCalloutMock());
        GetTripBatchClass obj = new GetTripBatchClass();
        DataBase.executeBatch(obj);
        GetTripBatchClass gt = new GetTripBatchClass(acc.Id, er[0].Triplog_Status__c);
        DataBase.executeBatch(gt);
        GetTripBatchClass gtB = new GetTripBatchClass(contactids, er[0].Triplog_Status__c);
        DataBase.executeBatch(gtB);
        Test.stopTest();
    }
    
    public static testmethod void GetTriptest1() {
        TrueDialog_Keys__c tdKeys = TestDataFactory.createTrueDialog(true);
        TriggerConfig__c triggerCustomSetting = TestDataFactory.triggerConfigCustomSetting(true);
        Vehicle_URL_Mapping__c vehicleType = TestDataFactory.createVehicleData(true, 3);
        SendEmailToMe__c customSetMail = TestDataFactory.sendEmailToMeCustomSetting(true, 'GetTripCallOutApprovePutCall');
        IRS_Mileage_Rate__c createIRSRate = TestDataFactory.createIRSRate(true, 0);
        daylight_saving_time_config__c daylightsetting = new daylight_saving_time_config__c();
        daylightsetting.Name = '2022';
        daylightsetting.Start_Date__c = date.valueof('2022-03-13');
        daylightsetting.End_Date__c = date.valueof('2022-06-11');
        insert daylightsetting;
        
        List<Id> contactids = new List<Id>();
        UserRole userRole = TestDataFactory.getUserRole();
        Profile profileObj = TestDataFactory.getUserProfile();
        User admin = TestDataFactory.getSystemAdminUser(userRole.Id);
        User userObj;
        Account acc ;
        List<Contact> conList;
        
        System.runAs(admin) {
            Account accountObj = TestDataFactory.createAccount(true,'Delta account',true);
            Contact contactObj = TestDataFactory.createCICDContact(true,accountObj.Id);
            
            acc = TestDataFactory.createAccount(true,'Delta account',true);
            acc.Triplog_API__c = 'fde76cdde14449bea46b321225ac8fd1';
            acc.Pay_Period_Start_Date__c = System.today().addDays(-100);
            acc.Pay_Period_Days__c = 13;
            Acc.Triplog_Status__c = 'A';
            update acc;
            
            conList = TestDataFactory.createDriverContact(true, acc.Id, 'Driver', vehicleType.Name, 'paras.dhanani',  1);
            conList[0].Vehicle_Type__c = vehicleType.Name;
            conList[0].isCommunityUser__c = true;
            conList[0].External_Email__c = 'minkesh.patel1357@gmail.com';
            conList[0].Email = 'minkesh.patel1357@gmail.com';
            conList[0].Triplog_Status__c = 'A';
            //conList[0].External_Email__c = 'minkesh.patel1478@gmail.com';
            update conList;
            contactids.add(conList[0].Id);
            
            userObj = TestDataFactory.createUser(True, profileObj.Id, conList[0].Id);
        }
        List<Employee_Reimbursement__c> er = TestDataFactory.createPendingReimbursement(False, conList, 1, createIRSRate.Id);
        er[0].Month__c = getLastMonthValue(-1);
        er[0].Status__c = 'Pending';
        Insert er[0];
        
        List<Bi_Weekly_Reimbursement__c> br = TestDataFactory.createBiweeklyReim (true, conList, System.today().addDays(-26),System.today().addDays(-13), 1, createIRSRate.Id);
        br[0].Status__c = 'Pending';
        update br;
        List<Employee_Mileage__c> emp1 = TestDataFactory.getEmpMileage (False, 0, er, br);
        emp1[0].Trip_Status__c = 'Not Approved Yet';
        emp1[0].Trip_Date__c = system.today().adddays(-100);
        Insert emp1;
        
        Test.startTest();
        Test.SetMock(HttpCalloutMock.class, new GetTripCalloutMock());
        GetTripBatchClass obj = new GetTripBatchClass();
        DataBase.executeBatch(obj);
        GetTripBatchClass gt = new GetTripBatchClass(acc.Id, er[0].Triplog_Status__c);
        DataBase.executeBatch(gt);
        GetTripBatchClass gtB = new GetTripBatchClass(contactids, er[0].Triplog_Status__c);
        DataBase.executeBatch(gtB);
        Test.stopTest();
    }    
    public static String getLastMonthValue(Integer value) {
        String tempDate = date.today().addMonths(value).Month() + '-' + date.today().addMonths(value).Year();
        String lastMonth = tempDate.left(2);
        if(lastMonth.contains('-')) {
            lastMonth = '0' + tempDate;
        } else {
            lastMonth = tempDate;
        }
        return lastMonth;
    }
}