//Class for Sending Email for payment for driver/admin driver/driver manager 
//Retrive those drives details who associated with PL marketing account and send email to all driver on payment date schedule on custome label(BiweeklyReimbursmentPaymentDate)

global with sharing class yearToDateBiWeeklyReimbursmentStatment implements Database.Batchable<SObject>,Database.Stateful
{
    public List<String> accountNamesList;
    public List<EmailTemplate> emailTemplateList;
    public List<String> emailsToSend;
    public List<String> biWeeklyList;
    public SendEmailonDeactivation__c customSettings;
    public List<String> PaydateList;
    public yearToDateBiWeeklyReimbursmentStatment() 
    { 
        try{
        String accountName = Label.BiWeeklyReimbursementStatementBatch;
        String PaydateListLabel =Label.BiweeklyReimbursmentPaymentDate;
        accountNamesList = new List<String>();
        emailsToSend = new List<String>(); 
        biWeeklyList = new List<String>();
        if(accountName != null)     
        {
            accountNamesList = accountName.split(',');
        }
            if(PaydateListLabel!=null)
            {
                PaydateList=PaydateListLabel.split(',');
            }
        emailTemplateList = new List<EmailTemplate>([SELECT Id, Subject,HtmlValue, body FROM EmailTemplate WHERE developerName = 'year_to_date_Bi_Weekly_Reimbursement_statement_template']);        
        customSettings = SendEmailonDeactivation__c.getValues('YearToDateReimbursementStatement');       
        if(customSettings!=null && String.isNotBlank(customSettings.BCCEmailaddresses__c) && customSettings.BCCEmailaddresses__c.contains(','))
        {
            emailsToSend = customSettings.BCCEmailaddresses__c.split(',');
        }
        else if(customSettings!=null && String.isNotBlank(customSettings.BCCEmailaddresses__c) && (!customSettings.BCCEmailaddresses__c.contains(',')))
        {
            emailsToSend.add(customSettings.BCCEmailaddresses__c);
        }
       
    }catch(Exception ex){
        system.debug('error'+ex.getMessage());
    }
    }
    global Database.QueryLocator start(Database.BatchableContext BC) 
    {
        String  query = 'Select Id,External_Email__c,FirstName FROM Contact WHERE Account.Name IN: accountNamesList AND (Role__c = \'Driver\' OR Role__c = \'Driver/Manager\' OR Role__c = \''+StaticValues.roleAdminDriver+'\') AND (Deactivated_Date__c = NULL OR Deactivated_Date__c >= TODAY)';
       // String  query = 'Select Id,External_Email__c,FirstName FROM Contact WHERE id = \'0030Z00003H8h7GQAR\' OR id = \'0033100003BvW5gAAF\'';
       //Select Id,External_Email__c,FirstName FROM Contact WHERE Account.Name ='Test Account' AND (Role__c = 'Driver' OR Role__c = 'Driver/Manager' OR Role__c = 'Driver/Admin') AND (Deactivated_Date__c = NULL OR Deactivated_Date__c >= TODAY)
        return Database.getQueryLocator(query);    
    }
    global void execute(Database.BatchableContext BC, List<SObject> scope) 
    {      
        try{
            // system.debug('1'+scope);  
        
        List<String> contactIdList = new List<String>();       
        Map<String,String> driverEmailMap = new Map<String,String>();
        Map<String,String> driverPayPeriod = new Map<String,String>();
        Map<String,Decimal> driverMileageMap = new Map<String,Decimal>();
        Map<String,Decimal> driverTotalVariableRateMap = new Map<String,Decimal>();
        Map<String,Decimal> driverVariableAmountMap = new Map<String,Decimal>();
        Map<String,Decimal> driverFixedAmountMap = new Map<String,Decimal>();
        Map<String,Decimal> driverMonthlyReimbursementMap = new Map<String,Decimal>();
        List<Messaging.SingleEmailMessage> singleEmailMessageList = new List<Messaging.SingleEmailMessage>();
        
        for(Contact currentContact : (List<Contact>)scope)
        {
            contactIdList.add(currentContact.id);
           // system.debug('currentContact==+ '+ currentContact);
        }
       
        for(Bi_Weekly_Reimbursement__c currentReimbursement : 
            [SELECT id,Name,Contact__r.Name,Contact__r.Id,Total_Approved__c,Total_Variable_Rate__c, Monthly_Approved_Variable_Amount__c ,Half_Fixed_Amount__c,Total_Monthly_Reimbursement__c
                                                                     FROM Bi_Weekly_Reimbursement__c WHERE Contact__r.Id IN : contactIdList and End_Date__c = this_year  ORDER BY End_Date__c  ASC ])
                {
                   //system.debug('currentReimbursement'+currentReimbursement);    
                   // List<String> monthAndYear = new List<String>();
                   // datetime monthValue = System.Now();
                   // if(currentReimbursement.Month__c!=null && currentReimbursement.Month__c.contains('-'))
                   // {
                   //     monthAndYear = currentReimbursement.Month__c.split('-');
                   //     monthValue = datetime.newInstance(Integer.valueOf(monthAndYear[1]), integer.valueOf(monthAndYear[0]), 1,00,00,00);
                  //  }
                  //  String monthName = monthValue.format('MMMMM'); 
                    String htmlTemplate='';  
                     if(driverEmailMap.size()>0 && driverEmailMap.containsKey(currentReimbursement.Contact__r.Id))
                     {
                        htmlTemplate = driverEmailMap.get(currentReimbursement.Contact__r.Id);
                       
                        Decimal mileage =(currentReimbursement.Total_Approved__c!=null)?currentReimbursement.Total_Approved__c:0;
                        mileage = mileage + driverMileageMap.get(currentReimbursement.Contact__c);
                        driverMileageMap.put(currentReimbursement.Contact__r.Id,mileage);
                        
                        Decimal variableRate = (currentReimbursement.Total_Variable_Rate__c!=null)?currentReimbursement.Total_Variable_Rate__c:0;
                        variableRate = variableRate+ driverVariableAmountMap.get(currentReimbursement.Contact__c);
                        driverVariableAmountMap.put(currentReimbursement.Contact__r.Id,variableRate);
                         
                        Decimal variableAmout = (currentReimbursement.Monthly_Approved_Variable_Amount__c!=null)?currentReimbursement.Monthly_Approved_Variable_Amount__c:0;
                        variableAmout = variableAmout+ driverVariableAmountMap.get(currentReimbursement.Contact__c);
                        driverVariableAmountMap.put(currentReimbursement.Contact__r.Id,variableAmout);
                                                
                        Decimal fixedAmount = (currentReimbursement.Half_Fixed_Amount__c!=null)?currentReimbursement.Half_Fixed_Amount__c:0;
                        fixedAmount = fixedAmount + driverFixedAmountMap.get(currentReimbursement.Contact__c);
                        driverFixedAmountMap.put(currentReimbursement.Contact__r.Id,fixedAmount);
                        
                        Decimal monthlyReimbursement = (currentReimbursement.Total_Monthly_Reimbursement__c!=null)?currentReimbursement.Total_Monthly_Reimbursement__c:0;
                        monthlyReimbursement = monthlyReimbursement + driverMonthlyReimbursementMap.get(currentReimbursement.Contact__c);
                        driverMonthlyReimbursementMap.put(currentReimbursement.Contact__r.Id,monthlyReimbursement);
                        
                         htmlTemplate = htmlTemplate + '<tr align="center" style="border:2px solid black;">'+
                             '<td style="border:1px solid black;">'  
                                + currentReimbursement.Name +'</td><td style="border:2px solid black;">'
                                + mileage+'</td><td style="border:2px solid black;">'+'$' 
                                + variableRate+'</td><td style="border:2px solid black;">'+'$' 
                                + variableAmout +'</td><td style="border:2px solid black;">' +'$' 
                                + fixedAmount+'</td><td style="border:2px solid black;">'+'$' 
                                + monthlyReimbursement +'</td>' 
                                +'</tr>';
                     }
                     else
                     {
                         driverPayPeriod.put(currentReimbursement.Contact__r.Id,currentReimbursement.Name);
                         driverMileageMap.put(currentReimbursement.Contact__r.Id,((currentReimbursement.Total_Approved__c!=null && String.IsNotEmpty(String.valueOf(currentReimbursement.Total_Approved__c)))?currentReimbursement.Total_Approved__c:0));
                         driverTotalVariableRateMap.put(currentReimbursement.Contact__r.Id,((currentReimbursement.Total_Variable_Rate__c!=null && String.IsNotEmpty(String.valueOf(currentReimbursement.Total_Variable_Rate__c)))?currentReimbursement.Total_Variable_Rate__c:0));
                         driverVariableAmountMap.put(currentReimbursement.Contact__r.Id,((currentReimbursement.Monthly_Approved_Variable_Amount__c!=null && String.IsNotEmpty(String.valueOf(currentReimbursement.Monthly_Approved_Variable_Amount__c)))?currentReimbursement.Monthly_Approved_Variable_Amount__c:0));
                         driverFixedAmountMap.put(currentReimbursement.Contact__r.Id,((currentReimbursement.Half_Fixed_Amount__c!=null && String.IsNotEmpty(String.valueOf(currentReimbursement.Half_Fixed_Amount__c)))?currentReimbursement.Fixed_Amount__c:0));
                         driverMonthlyReimbursementMap.put(currentReimbursement.Contact__r.Id,((currentReimbursement.Total_Monthly_Reimbursement__c!=null && String.IsNotEmpty(String.valueOf(currentReimbursement.Total_Monthly_Reimbursement__c)))?currentReimbursement.Total_Monthly_Reimbursement__c:0));
                         
                 htmlTemplate='<tr align="center" style="border:2px solid black;"> <td style="border:1px solid black;">'  
                                + currentReimbursement.Name +'</td><td style="border:2px solid black;">'
                                + currentReimbursement.Total_Approved__c+'</td><td style="border:2px solid black;">'+'$' 
                                + currentReimbursement.Total_Variable_Rate__c+'</td><td style="border:2px solid black;">'+'$' 
                                + currentReimbursement.Monthly_Approved_Variable_Amount__c +'</td><td style="border:2px solid black;">' +'$' 
                                + currentReimbursement.Half_Fixed_Amount__c+'</td><td style="border:2px solid black;">'+'$' 
                                + currentReimbursement.Total_Monthly_Reimbursement__c +'</td>' 
                                +'</tr>';
                     }
                    //system.debug('1htmlTemplate'+htmlTemplate);
                     driverEmailMap.put(currentReimbursement.Contact__c,htmlTemplate);
                  //   system.debug('driverEmailMap'+driverEmailMap);
           // system.debug('currentReimbursement==+ '+ currentReimbursement);
                }
         
        OrgWideEmailAddress[] owea = [SELECT Id,Address from OrgWideEmailAddress where Address = 'driverservices@mburse.com'];         
        for(Contact currentContact : (List<Contact>)scope)
        {
           String htmlTemplate = '';
           if(driverEmailMap.containsKey(currentContact.id))
           {
               htmlTemplate = driverEmailMap.get(currentContact.id);               
               htmlTemplate = htmlTemplate + '<tr align="center" style="border:2px solid black;">'+
                                                '<td style="border:2px solid black;"><b>'+String.valueOf(driverPayPeriod.get(currentContact.Id))+ '</b></td>'+
                                                '<td style="border:2px solid black;"><b>'+String.valueOf(driverMileageMap.get(currentContact.id))+ '</b></td>'+
                                                '<td style="border:2px solid black;"><b>'+'$'+ String.valueOf(driverVariableAmountMap.get(currentContact.id))+'</b></td>'+
                                                '<td style="border:2px solid black;"><b>'+'$'+ String.valueOf(driverTotalVariableRateMap.get(currentContact.id))+'</b></td>'+
                                                '<td style="border:2px solid black;"><b>'+'$'+String.valueOf(driverFixedAmountMap.get(currentContact.id))+ '</b></td>'+
                                                '<td style="border:2px solid black;"><b>'+'$'+String.valueOf(driverMonthlyReimbursementMap.get(currentContact.id))+'</b></td>'+
                                            '</tr>';
               Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
              // system.debug('emailTemplateList'+emailTemplateList);
               
               String newBody = emailTemplateList[0].HtmlValue;
               newBody = newBody.replace('{tableDynamicData}',htmlTemplate);
               newBody = newBody.replace('{!Bi_Weekly_Reimbursement__c.Contact_Id_Name__c}',currentContact.FirstName);
               newBody = newBody.replace('{!$Label.Driver_Forword_Logo}', System.Label.Driver_Forword_Logo);
               
               
               mail.setSubject(emailTemplateList[0].Subject);
               mail.setHtmlBody(newBody);
               List<String> toAddress = new List<String>();
             
               if(customSettings.Send_to_Driver__c == true) 
               {
                   //toAddress.add(currentContact.External_Email__c);
                   toAddress.add('Paras.dhanani@getoncrm.com');
                   mail.setToAddresses(toAddress);
                   if(emailsToSend.size()>0)
                   {
                       mail.setBccAddresses(emailsToSend);
                   }                   
               }
               else if(emailsToSend.size()>0)
               {
                   List<string> emilId=new List<String>();
                   mail.setToAddresses(emailsToSend);
                   mail.setToAddresses(emilId);
               }
               mail.setOrgWideEmailAddressId(owea.get(0).Id);    
               singleEmailMessageList.add(mail);                 
           }
        }
                for(integer i=0;i<PaydateList.size();i++){
                Date currentDate =(Date.parse(PaydateList[i]));
                    if(currentDate==date.today()){
                if(singleEmailMessageList.size()>0 && !Test.IsRunningTest()) 
                    {
                      
                        Messaging.sendEmail(singleEmailMessageList);  
                    }        
                    }
                }
        
        }catch(Exception ex)
        {
            system.debug('Error:'+ex.getMessage()+' at Line No:'+ex.getLineNumber());
        }
    }
    global void finish(Database.BatchableContext BC) 
    {
         
    }
     
}