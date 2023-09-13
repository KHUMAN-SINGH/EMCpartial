global  class testDataforLWC {
    @AuraEnabled
    public static String getMileagesData(Integer year,String contactId) {
        
        List<mileageValueWrapper> empMileageValue = new List<mileageValueWrapper>(); 
        List<Employee_Mileage__c> getMileagesDataList = new List<Employee_Mileage__c>();
        List<mileageValueWrapper> mileageData = new List<mileageValueWrapper>(); 
    
        for(Employee_Mileage__c empMileagelst : [SELECT Id,StartTime__c, EndTime__c, Contact_Email_Id__c, Tracing_Style__c, Day_Of_Week__c, 
                                                    Trip_Date__c, Origin_Name__c, Destination_Name__c, Mileage__c, Trip_Status__c, Approved_Date__c, 
                                                    Fuel_Variable_Rate__c, Variable_Rate__c,EmployeeReimbursement__r.Month__c ,Total_Time__c, 
                                                    Notes__c, Tag__c 
                                                from Employee_Mileage__c 
                                                where EmployeeReimbursement__r.Contact_Id__c =: contactId and EmployeeReimbursement__r.Year__c =:year]){
            String MonthVal = empMileagelst.EmployeeReimbursement__r.Month__c.split('-').get(0);
            String MonthStr = WrapperUtils.getMonthNamefromno(Integer.valueOf(MonthVal));            
            mileageValueWrapper empMileWrap = new mileageValueWrapper ();
            empMileWrap.reimMonth = MonthStr;
            empMileWrap.id = String.valueOf(empMileagelst.Id);
            empMileWrap.endtime = String.valueOf(empMileagelst.EndTime__c);
            empMileWrap.starttime = String.valueOf(empMileagelst.StartTime__c);
            empMileWrap.email = String.valueOf(empMileagelst.Contact_Email_Id__c);
            empMileWrap.tracingStyle = String.valueOf(empMileagelst.Tracing_Style__c);
            empMileWrap.dayOfWeek = String.valueOf(empMileagelst.Day_Of_Week__c);
            empMileWrap.tripDate = empMileagelst.Trip_Date__c;
            empMileWrap.originName = String.valueOf(empMileagelst.Origin_Name__c);
            empMileWrap.destinationName = String.valueOf(empMileagelst.Destination_Name__c);
            empMileWrap.mileage = String.valueOf(empMileagelst.Mileage__c);
            empMileWrap.tripStatus = String.valueOf(empMileagelst.Trip_Status__c);
            empMileWrap.approvedDate = empMileagelst.Approved_Date__c;
            empMileWrap.fuelVaraibleRate = String.valueOf(empMileagelst.Fuel_Variable_Rate__c);
            empMileWrap.varaibleRate = String.valueOf(empMileagelst.Variable_Rate__c);
            empMileWrap.fuelVaraibleRate = String.valueOf(empMileagelst.Fuel_Variable_Rate__c);
            //empMileWrap.month = String.valueOf(empMileagelst.Variable_Rate__c);
            empMileWrap.totalTime = String.valueOf(empMileagelst.Total_Time__c);
            empMileWrap.notes = String.valueOf(empMileagelst.Notes__c);
            empMileWrap.tag = String.valueOf(empMileagelst.Tag__c);
            //empMileWrap.empMileagesData = empMileagelst;
            mileageData.add(empMileWrap);
        }     
        System.debug('mileage data: '+JSON.serialize(mileageData ).unescapeHtml4());
        return JSON.serialize(mileageData).unescapeHtml4();
    }

    public class mileageValueWrapper {
        //public List<Employee_Mileage__c> empMileagesDataList {get;set;}
        //public Employee_Mileage__c empMileagesData {get;set;}
        public string reimMonth {get;set;}
        public string id {get;set;}
        public string starttime {get;set;}
        public string endtime {get;set;}
        public string email {get;set;}
        public string tracingStyle {get;set;}
        public string dayOfWeek {get;set;}
        public date tripDate {get;set;}
        public string originName {get;set;}
        public string destinationName {get;set;}
        public string mileage {get;set;}
        public string tripStatus {get;set;}
        public date approvedDate {get;set;}
        public string fuelVaraibleRate {get;set;}
        public string varaibleRate {get;set;}
        public string totalTime {get;set;}
        public string notes {get;set;}
        public string tag {get;set;}
    }   

    @AuraEnabled
    public static String getMileagesData1(Integer year,String contactId) {
        Map<string,List<Employee_Mileage__c>> empMileagenewData = new Map<string,List<Employee_Mileage__c>>();
        for(Employee_Mileage__c empMileagelst : [SELECT Id,Trip_Date_Month__c,StartTime__c, EndTime__c, Contact_Email_Id__c, Tracing_Style__c, Day_Of_Week__c, 
                                                    Trip_Date__c, Origin_Name__c, Destination_Name__c, Mileage__c, Trip_Status__c, Approved_Date__c, 
                                                    Fuel_Variable_Rate__c, Variable_Rate__c,EmployeeReimbursement__r.Month__c ,Total_Time__c, 
                                                    Notes__c, Tag__c 
                                                from Employee_Mileage__c 
                                                where EmployeeReimbursement__r.Contact_Id__c =: contactId and EmployeeReimbursement__r.Year__c =:year]){
            
                String MonthVal = empMileagelst.EmployeeReimbursement__r.Month__c.split('-').get(0);
                String MonthStr = WrapperUtils.getMonthNamefromno(Integer.valueOf(MonthVal));
                
                if(empMileagenewData.containsKey(MonthStr)){
                    empMileagenewData.get(MonthStr).add(empMileagelst);
                }
                else {
                    empMileagenewData.put(MonthStr, new List<Employee_Mileage__c>{empMileagelst});
                }
            }
            System.debug('json data : '+ JSON.serialize(empMileagenewData).unescapeHtml4());
            return JSON.serialize(empMileagenewData).unescapeHtml4();
    }
}