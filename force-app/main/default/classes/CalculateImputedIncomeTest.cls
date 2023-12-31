@isTest
public class CalculateImputedIncomeTest {
    public static testmethod void imputedIncomeMethod(){
        RecordUtilityClass.createRecordsAdminDashboardController();
        IRS_Mileage_Rate__c irsRateObj = TestDataFactory.createIRSRate(true,0);
         Vehicle_URL_Mapping__c vehicleObj = TestDataFactory.createVehicleData(true,0);
        Account currentAccount = RecordUtilityClass.getAccount(); // retriving the Accounts EmployeeMileagesForCalculation        
        currentAccount.Tax_Calculation_Year__c = string.valueOf(System.Today().year());
        update currentAccount;
        Contact currentAdmin = RecordUtilityClass.getAdminContact(); // Retriving the Admin with limit 1
        Contact selectedDriver = RecordUtilityClass.getDriverContact();
        List<Contact> conList = TestDataFactory.createDriverContact(true, currentAccount.Id, 'Driver', vehicleObj.Name, 'test.email', 1);
        system.debug('currentAccount.id==' + currentAccount.id);
        List<Employee_Reimbursement__c> empReimbursementList  = TestDataFactory.createPendingReimbursement(true, conList, 10, irsRateObj.id);
        empReimbursementList[0].Approved_Date__c  = system.today();
        update empReimbursementList;
        //List<Employee_Reimbursement__c> empReimbursementList = RecordUtilityClass.getEmployee_Reimbursement(currentAccount.id);
       
       //List<Employee_Reimbursement__c> empReimbursementList = TestDataFactory.createPendingReimbursement(true,selectedDriver ,1,irsRateObj);
        system.debug('empReimbursementList ' + empReimbursementList );
        List<Id> contIdList = new List<Id>{currentAdmin.Id,conList[0].Id};
        CalculateImputedIncome.getImputedIncome(contIdList, currentAccount.Tax_Calculation_Year__c);
        


    }
    
}