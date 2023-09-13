/*
 * @Author:  GetonCRM Solutions LLP
 * @Description:  Batch class to fetch UserId,App version and Timezone of contacts from TripLog and update 
 * ------------------------------------------------------------------------------------------------------------------------
 * @Modification Logs
 * ------------------------------------------------------------------------------------------------------------------------
 * @version 1.1   - @Author:  Paras Dhanani - 30 August 2022
 * @Description: Update a code to run this batch daily basis
 */

public class MileageDeductionController Implements Schedulable {
    public void execute(SchedulableContext sc) {
        mileageDeduct();
    }
    
    public static void mileageDeduct() {
        //String id = 'a008H000001HaAg';
        String accId = label.Mileage_Deduction_Account_ID;
        Map<Date,Integer> mielMap = new Map<Date,Integer>();
        string sdate = string.valueof(system.today());
        String[] splitDate = sdate.split('-');
        system.debug('sdate==' + sdate); 
        String monthStartDate = splitDate[0] + '-' + splitDate[1] + '-01'; 
        String monthEndDate; 
        
        Map<String, String> evenDayMap = new Map<String, String>{'01' => '31', '03' => '31' , '05' => '31' , 
            '07' => '31' , '08' => '31' , '10' => '31', '12' => '31' };
                if (EvenDayMap.containsKey(splitDate[1])) {
                    monthEndDate = splitDate[0] + '-' + splitDate[1] + '-31'; 
                } /*else if(splitDate[1] = '02') {
                    monthEndDate = splitDate[0] + '-' + splitDate[1] + '-28';
                } */else {
                    monthEndDate = splitDate[0] + '-' + splitDate[1] + '-30'; 
                }
        
        List<Employee_Reimbursement__c> reimList = new List<Employee_Reimbursement__c>();
        set<ID> reimIdList = new set<ID>();
        
        for(Employee_Mileage__c obj : [SELECT id,Trip_Date__c,Trip_Id__c,EmployeeReimbursement__c  
                                       FROM Employee_Mileage__c 
                                       WHERE (Trip_Date__c >=: Date.valueOf(monthStartDate) and Trip_Date__c <=: Date.valueOf(monthEndDate)) 
                                       AND EmployeeReimbursement__r.Contact_Id__r.AccountId =: accId Order by Trip_Id__c]){
                                           reimIdList.add(obj.EmployeeReimbursement__c);           
                                           
                                           if(mielMap != null && mielMap.containsKey(obj.Trip_Date__c)) {
                                               Integer countNumber = mielMap.get(obj.Trip_Date__c);
                                               countNumber = countNumber + 1;
                                               mielMap.put(obj.Trip_Date__c,countNumber);
                                           }
                                           else{
                                               mielMap.put(obj.Trip_Date__c,1);
                                           }
                                       }
        system.debug('mielMap==' + mielMap);
        for(Employee_Reimbursement__c objReim : [SELECT id,Working_Days__c,month__c 
                                                 FROM Employee_Reimbursement__c 
                                                 WHERE id =: reimIdList ]) {
                                                     objReim.Working_Days__c = mielMap.keyset().size();
                                                     system.debug('mielMap.keyset().size()==' + mielMap.keyset().size());
                                                     reimList.add(objReim);
                                                 }
        if(reimList.size() > 0) {
            update reimList;
        }
    }  
}