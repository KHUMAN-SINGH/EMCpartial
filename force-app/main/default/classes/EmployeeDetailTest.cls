@isTest
public class EmployeeDetailTest {
    public static testmethod void employeeTest(){
        EmployeeDetails empDetail = new EmployeeDetails();
        empDetail.userId    = '01I31000001qwea';
        empDetail.firstName = 'test';
        empDetail.lastName  = 'EmployeeDetail';
        empDetail.email     = 'test123@gmail.com';
        empDetail.zipCode   = '382225';
        empDetail.city      = 'Cincinnati';
        empDetail.state     = 'Ohio';
        empDetail.employeeId     = '00B310000065iFf';
        empDetail.activationDate = '8/3/2019 12:00 AM';
        empDetail.role           = 'Driver';
        empDetail.managerId      = 'a001h000001swsP';
        empDetail.managerName    = 'Natvar';
        empDetail.vehicalType    = 'tesType';
        List<String> listDrivingStates = new List<String> {'CA','LA','OH','NY'};
        empDetail.drivingStates  = listDrivingStates;
        empDetail.deactivaedDate = '20/3/2019 06:00 AM';
        empDetail.lastPayDate    = '10/3/2019 10:00 AM';
        //empDetail.editmode       = true;
         empDetail.cellphone ='';
        empDetail.resetReimbursementLink = false;
        empDetail.IsDeactivated = false;
        empDetail.compliancestatus ='';
        empDetail.accountId      = '0011h00000LNa1f';
        empDetail.IsMassDeactivated = true;
        empDetail.approvalThreshold = '50';
        empDetail.appVersion = '5';
        empDetail.totalreimbursement = '57';
        empDetail.monthlymileageLimit = '1200';
        empDetail.fixedamount = '500';
        empDetail.branchName = 'abc';
        empDetail.district = 'abc';
        empDetail.code = 'abc';
        empDetail.territory = 'abc';
        empDetail.jobtitle = 'asc';
        empDetail.department = 'asc';
        empDetail.driverType = 'asc';
        empDetail.freeze = 'asc';
        empDetail.sage100ID = 'asc';
        empDetail.glcode = 'asc';
        empDetail.loaStartDate = '20/3/2019';
        empDetail.loaEndDate = '20/3/2019';
        empDetail.payRollPeriod = 'asc';
        empDetail.loaFixedAmount = '450';
        empDetail.isleaveofabsence = false;
        empDetail.monthlyReimbursement = true;
        empDetail.biWeekReimbursement = false;
        empDetail.timeAttandance = false;
        empDetail.branchNumber = '12345332';
        empDetail.monthlymileage = '435';
        empDetail.IsMassFreeze = false;
        empDetail.netchexEmployeeID = 'Paras123';
        empDetail.deptDesign = 'sales';
        empDetail.deactivationBy = 'Tom Honkus';
        empDetail.deptPL = 'develoement';
        empDetail.divison = 'North';
        empDetail.finalPayrollAmount = '342';
        empDetail.firstPayrollPer  = '34';
        empDetail.company = 'PdDeveloper';
        empDetail.am = 'vafa';
        empDetail.an = 'dvjhdjks';
        empDetail.costCode = '1254353';
        empDetail.appSetting = 'start:MagicTrip.';
        empDetail.Businesshours = ' Business hours:Mon Tue Wed Thu Fri 3:00 AM-9:00 PM Business. After hours:Personal.';
        empDetail.lastSynced = '4/20/2023 7:39';
        empDetail.mileageForDeduction = 55.00;
    }
}