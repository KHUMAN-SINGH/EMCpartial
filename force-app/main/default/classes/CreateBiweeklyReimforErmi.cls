/* ******************************************************************************************************
 * Author : GetonCRM Solutions LLP																		*
 * Created Date : 10/02/2022																			*
 * Description : This Batch is used to create BiWeekly Reimbursement For Ermi Account automatically		*
 * 				 to the next day of the current Biweekly Reimbursement is Finished.						*
 * -----------------------------------------------------------------------------------------------------*
 * Modified By : Paras Dhanani																			*
 * Modified Date : 21-03-2022																			*
 *******************************************************************************************************/



Global class CreateBiweeklyReimforErmi Implements Database.Batchable<sObject> ,  database.stateful {
    
    Public date myDate;
    Public  date dateStr;
    Public string tempYear;
    Public String accId ;
    Public date fuelPriceDate ;
    List<IRS_Mileage_Rate__c> objIRSRate;

    global CreateBiweeklyReimforErmi(){
        myDate = system.today();
        accId = System.Label.ERMI_Account;
        tempYear = String.valueOf(date.today().Year());
        objIRSRate = [SELECT id,year__c,IRS_Rate__c FROM IRS_Mileage_Rate__c Where year__c =: tempYear Limit 1];
    }
    
    Global List<Contact> start(Database.BatchableContext bc)	{
        Date myDate = system.today();
        List<Contact> conList = new List<Contact>();
        if(!Test.isRunningTest()){
            conList = [SELECT Id,name,Role__c,Fixed_Amount__c, Maintenance_and_Tires__c, MPG__c,Account.Pay_Period_Start_Date__c, 
                       Account.Pay_Period_Days__c,MailingCity, MailingState 
                       FROM contact 
                       where AccountId = : accId
                       AND Role__c != 'Admin' 
                       AND Role__c != 'Manager' 
                       AND Deactivated_Date__c = NULL 
                       AND Account.isUsingTriplog__c = true 
                       AND Activation_Date__c <=: myDate limit 1]; 
        } else {
           conList = [SELECT Id,name,Role__c,Fixed_Amount__c, Maintenance_and_Tires__c, MPG__c,Account.Pay_Period_Start_Date__c, 
                       Account.Pay_Period_Days__c,MailingCity, MailingState  
						FROM contact 
                                WHERE Role__c != 'Admin' 
                                    AND Role__c != 'Manager'];
        }
        return conList; 
    }
    
    Global void execute(Database.BatchableContext BC, list<SObject> conList)	{
        Decimal days;
        List<String> dateRange = new List<String>();
        for(account acc : [SELECT id,name,Pay_Period_Start_Date__c, Pay_Period_Days__c FROM Account WHERE Bi_Weekly_Pay_Period__c = true and id = : accId]){
            days = (acc.Pay_Period_Days__c != null ? acc.Pay_Period_Days__c : null);
        }
        string startdate = string.valueOf(system.today().adddays(1));
        string[] splitsdate = startDate.split('-');
            string splitStartDate = splitsdate[1]+'/'+splitsdate[2]+'/'+splitsdate[0];
            String enddate = String.valueof(date.valueof(startDate).addDays(Integer.valueof(days)));
            string[] splitdate = enddate.split('-');
            string splitEndDate = splitdate[1]+'/'+splitdate[2]+'/'+splitdate[0];
        string[] currentDate = string.valueOf(myDate).split('-');
       
        if(integer.valueOf(currentDate[1]) == 01){
            fuelPriceDate = date.valueOf(string.valueOf(integer.valueOf(currentDate[0])-1) + '-12' + '-01' );   
        } else {
            fuelPriceDate = date.valueOf(currentDate[0] + '-' + string.valueOf(integer.valueOf(currentDate[1])-1) + '-01');
        } 
    string[] splitedfuelPriceDate = string.valueOf(fuelPriceDate).split('-');

            map<string, Decimal> monthStateCityVsFuelPriceMap = new map<string, Decimal>(); 
           for(Gas_Prices__c obj_GasPrice : [SELECT id,
           name,
           City__c,
           State__c, 
           Fuel_Price__c, 
           Month_Year__c,
           Month_State_City__c 
           FROM Gas_Prices__c 
           WHERE  Month_Year__c =: date.valueOf(fuelPriceDate)]) {
                    monthStateCityVsFuelPriceMap.put(obj_GasPrice.Month_State_City__c, obj_GasPrice.Fuel_Price__c); 
           }
        
         List<Bi_Weekly_Reimbursement__c> biweeklyreimToInsert   = new List<Bi_Weekly_Reimbursement__c>();
        MAP<Id,Bi_Weekly_Reimbursement__c> accMap = new MAP<Id,Bi_Weekly_Reimbursement__c>();  
        for(contact con :  (List<Contact>) conList) {
            Bi_Weekly_Reimbursement__c br = new Bi_Weekly_Reimbursement__c();
            br.Name = splitStartDate + ' to ' + splitEndDate ; 
            br.Contact__c = con.Id;
            br.Start_Date__c = date.parse(splitStartDate);
            br.End_Date__c = date.parse(splitEndDate);
            br.MPG__c = con.MPG__c;
            br.Maintenance_and_Tires__c = con.Maintenance_and_Tires__c;
            br.Fixed_Amount__c = con.Fixed_Amount__c;
            br.Status__c = 'Pending';
        
             if(integer.valueOf(currentDate[1]) == 01){
                if (monthStateCityVsFuelPriceMap.containsKey(con.MailingCity+ con.MailingState + '12' + string.valueOf(integer.valueOf(currentDate[0])-1)) ) {
                    br.Fuel_Price__c = monthStateCityVsFuelPriceMap.get(con.MailingCity+ con.MailingState + '12' + string.valueOf(integer.valueOf(currentDate[0])-1)) ;
                }   else {
                    br.Fuel_Price__c = 0;
                }
            }   else {
                if (monthStateCityVsFuelPriceMap.containsKey(con.MailingCity+ con.MailingState + string.valueOf(integer.valueOf(currentDate[1])-1) + currentDate[0]) ) {
                    br.Fuel_Price__c = monthStateCityVsFuelPriceMap.get(con.MailingCity+ con.MailingState + string.valueOf(integer.valueOf(currentDate[1])-1) + currentDate[0]);
                    }   else {
                        system.debug('if inserted');
                        br.Fuel_Price__c = 0;
                    }
                }
            if(!objIRSRate.isEmpty()){
                br.IRS_Mileage_Rate__c = objIRSRate[0].ID;
            }
            biweeklyreimToInsert.add(br);
        }
        accMap.putall(biweeklyreimToInsert);
        if(!accMap.isEmpty() && !Test.isRunningTest()) {
            insert accmap.values();
        }
    } 
    Global void finish(Database.BatchableContext BC){}  
}