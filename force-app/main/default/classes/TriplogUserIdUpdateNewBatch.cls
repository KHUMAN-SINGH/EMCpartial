global class TriplogUserIdUpdateNewBatch implements Database.Batchable<sObject>, Database.AllowsCallouts, Database.stateful {
    global String accountID;
    global String apiKey;  
    global String htmlTemplate = ''; 
    global String htmlTemplate2 = '';     
    global String accName = '';   
    global String responseOfAPICall = '';
    public Map<String,Contact> contactMap;       
    public Map<String,String> appUpdateMap ;
    public static final String MLOGACCOUNT = System.Label.Triplog_New_URL + ',' + System.Label.Triplog_New_URL2;

    global List<Account> start(Database.BatchableContext BC){  
        return [Select Id,Name,Triplog_API__c,isUsingTriplog__c,(Select id,Name,Account.Name,Triplog_UserID__c,External_Email__c,Deactivated_Date__c From Contacts Where (Role__c = 'Driver' or Role__c = 'Driver/Manager'or Role__c =: StaticValues.roleAdminDriver ) and Deactivated_Date__c = null ) From Account where Triplog_API__c != null and isUsingTriplog__c = true];
    }

    global void execute(Database.BatchableContext bc, List<Account> scope){
        String baseUrl = URL.getSalesforceBaseUrl().toExternalForm();        
        set<string> emailSet = new set<string>();
        List<String> appVersionList = new List<String>();
        List<Contact> contactToUpdateList = new List<Contact>();
        System.debug('scope '+scope.size());

        String appVersionName = '';
        appVersionName = Label.Latest_App_Versions_In_Triplog;
           
            if(!String.isBlank(appVersionName))
            {
                // System.debug('appVersionName '+appVersionName);
                if(appVersionName.contains(','))
                {
                    appVersionList = appVersionName.split(',');                   
                }
                else {
                    appVersionList.add(appVersionName);
                } 
            }
        
        for(Account a : scope){
            accName = a.Name;  
            // System.debug('accName '+accName);
            contactMap = new Map<String,Contact>();
            for(Contact con : a.Contacts){  
                // System.debug('contcon.External_Email__c '+con.External_Email__c);
                contactMap.put(con.External_Email__c.toLowerCase(),con);    
                // System.debug('contactMap '+contactMap);
            }

            if (!Test.isRunningTest()) {
                responseOfAPICall = getTripIds(a.Triplog_API__c);
                // System.debug('responseOfAPICall '+responseOfAPICall);
            }
            if(String.isNotBlank(responseOfAPICall)  && responseOfAPICall!='Error')
            {
                TriplogJsonUserParse triplogRes = TriplogJsonUserParse.parse(responseOfAPICall);                
                if(triplogRes.user!=null && triplogRes.user.size()>0)
                {
                    for(TriplogJsonUserParse.Users currentUser : triplogRes.user)
                    {
                        if(String.isNotBlank(currentUser.email) && contactMap.containsKey(currentUser.email.toLowerCase()))
                        {           
                            // System.debug('currentUser '+currentUser);                  
                            Contact currentContact = new Contact();
                            currentContact = contactMap.get(currentUser.email);
                            currentContact.Triplog_UserID__c = String.valueOf(currentUser.id);
                            currentContact.App__c = currentUser.appVersion;                            
                            currentContact.Is_Driver_In_Triplog__c = currentUser.driver;
                            /*if(!appVersionList.contains(currentUser.appVersion)){
                                appUpdateMap.put(currentUser.email,currentContact.Firstname);
                            }*/
                            if(currentUser.timeZone != null){
                                List<String> resZone = currentUser.timeZone.split(',');                                
                                currentContact.Time_Zone__c = resZone[0].substringAfter('=').replace('\"', '');
                            }                         
                            contactToUpdateList.add(currentContact);
                            emailSet.add(currentUser.email.toLowerCase());
                        }
                    }
                }
            }
        }
        if(contactToUpdateList.size()>0)
        {
            // System.debug('contactToUpdateList '+contactToUpdateList);
            // Database method to update the records in List
            List<Database.SaveResult> srList = Database.update(contactToUpdateList, false);
            if(contactMap.size() != contactToUpdateList.size()){ 
                for (Integer i = 0; i < contactToUpdateList.size(); i++) {
                    Database.SaveResult sr = srList[i];
                    Contact origRecord = contactToUpdateList[i];

                    if (!sr.isSuccess()) {
                        String DeactivateDate = String.valueOf(origRecord.Deactivated_Date__c);
                        if(DeactivateDate == null){
                            DeactivateDate = '';
                        }
                        htmlTemplate2 = htmlTemplate2 + '<tr align="center">' 
                                        + '<td style="border:2px solid black;">' + '<a href="'+baseUrl+'/'+origRecord.Id+'">'+origRecord.Name+'</a>'+ '</td>'
                                        + '<td style="border:2px solid black;">' + origRecord.External_Email__c + '</td>'
                                        + '<td style="border:2px solid black;">' + origRecord.Account.Name + '</td>'
                                        + '<td style="border:2px solid black;">' + DeactivateDate + '</td>';

                        Integer getErrorsSize = 1;
                        for(Database.Error objErr : srList[i].getErrors()) {
                            if(getErrorsSize > 1){
                                htmlTemplate2 = htmlTemplate2 + '</tr> <tr align="center"><td colspan="2" style="border:2px solid black"></td>'
                                                                + '<td style="border:2px solid black;">' + objErr.getStatusCode() + ': ' + objErr.getMessage()+ '</td>' ;
                            }
                            else{
                                htmlTemplate2 = htmlTemplate2 + '<td style="border:2px solid black;">' + objErr.getStatusCode() + ': ' + objErr.getMessage()+ '</td>' ;
                            }
                            getErrorsSize++;
                        }
                        htmlTemplate2 += +'</tr>';
                    } 
                }         
                            
                for (Contact cont:contactMap.values()){                    
                    if(!emailSet.contains(cont.External_Email__c.toLowerCase())){
                        String DeactivateDate = String.valueOf(cont.Deactivated_Date__c);
                        if(DeactivateDate == null){
                            DeactivateDate = '';
                        }
                                                
                        htmlTemplate = htmlTemplate + '<tr align="center">' 
                                        + '<td style="border:2px solid black;">' + '<a href="'+baseUrl+'/'+cont.Id+'">'+cont.Name+'</a>'+ '</td>'                                         
                                        + '<td style="border:2px solid black;">' + cont.External_Email__c + '</td>'
                                        + '<td style="border:2px solid black;">' + cont.Account.Name + '</td>'
                                        + '<td style="border:2px solid black;">' + DeactivateDate + '</td>';   
                        htmlTemplate += +'</tr>';
                    }
                }                
            }
            // System.debug('htmlTemplate :'+htmlTemplate);
            // System.debug('htmlTemplate2 :'+htmlTemplate2);
        }
    }

    global void finish(Database.BatchableContext bc){
        SendEmail__c  objSendEmail = SendEmail__c.getValues('TriplogUserIdUpdateNewBatch');
        if(htmlTemplate != ''){
            EmailTemplate emailTemplate = [SELECT Id,
                                                  HtmlValue,
                                                  Name,
                                                  Subject 
                                           FROM EmailTemplate 
                                           WHERE DeveloperName = 'Contact_external_email_not_found_in_triplog'];              
            String newBody = emailTemplate.HtmlValue;       
            newBody = newBody.replace('{tableDynamicData}',htmlTemplate);  
            newBody = newBody.replace('{tableDynamicData2}',htmlTemplate2);
            
            // System.debug('newBody: '+newBody);
            List<String> emailaddressofsending = new List<String>();     
            messaging.singleEmailMessage mail = new messaging.singleEmailMessage();
            mail.setHtmlBody(newBody);
            mail.setSubject(accName+'\'s contacts list did not update triplog User id');            
            emailaddressofsending = System.Label.Email_To_Address.split(','); 
            // System.debug('emailaddressofsending=='+emailaddressofsending);
            
            mail.setToAddresses(emailaddressofsending);            
            try{
                if(objSendEmail.Send_email_from_code__c){
                    System.debug('mail sent');
                    Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
                }
                
            }catch(exception e){
                System.debug('Exception: '+e.getmessage());
                // apexpages.addmessage(new apexpages.message(apexpages.severity.error,e.getMessage()));
            }
        }    
    }

    public static String getTripIds(String passedApikey)
    {
        String baseURL = !MLOGACCOUNT.Contains(passedApikey) ? StaticValues.TRIPLOG_BASEURL : StaticValues.MLOG_BASEURL;
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint( baseURL + '/api/users');
        request.setMethod('GET');
        request.setHeader('Authorization','apikey ' + passedApikey);
        HttpResponse response = http.send(request);
        
        return response.getStatusCode() == 200 ? response.getBody() : 'Error';
    }   
}