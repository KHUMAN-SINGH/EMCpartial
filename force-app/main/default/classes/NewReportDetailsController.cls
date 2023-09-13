public with sharing class NewReportDetailsController {
    public static String accountId;
    public static String reportID;
    public static Custom_Report__c obj_current_report;
    public static String contactId;
    public static String getdataofmanager;
    public NewReportDetailsController (){}
    @AuraEnabled
    public static string getMangerData (String reportid,String accId,String conId){
    accountId = accId;
    contactId = conId;
    reportID = reportid;
        Custom_Report__c obj_current_report = new Custom_Report__c();
        String getdataofdriver;
         String managerdriverlist;
            obj_current_report = getReportDetailNew(reportid);
            if(obj_current_report != null) {
                if(obj_current_report.Use_Driver_List__c == true) {
                    getdataofdriver = getAllReportSoqlForDriver();
                }
                else if(obj_current_report.Use_Manager_List__c == true) {
                    getdataofmanager =getAllReportSoqlForManager();
                }
                if(obj_current_report.Use_Bussiness_Unit__c == true) { }
                return getdataofdriver;
            } else {
                // Exception page.
            }
        return '';
    }
    
    @AuraEnabled
    public static Custom_Report__c getReportDetailNew(String reportid)
    {
        List<String> obj_list_of_headers = new List<String>();
        String query = 'Select id,Name,Report_Type__c,Report_Soql__c,Report_Header__c,Date_Fields__c,Date_Time_Fields__c,Date_Time_To_Time__c,Numeric_Fields__c,Report_Category__c,Use_Bussiness_Unit__c,Use_Driver_List__c,Use_Manager_List__c from Custom_Report__c where id=\''+reportid+'\'';
        obj_current_report = (Custom_Report__c)(((List<Custom_Report__c>)ExecuteQueryUtil.getRecordListFromsObject(query))[0]);
        return obj_current_report;
    }
    
    @AuraEnabled
    public static string getAllManagers(String role,String accountId)
    {   
        String query;
        if(role == 'Driver') {
            query = 'Select id,Name from Contact where accountid=\''+accountId+'\'and (Role__c = \''+StaticValues.roleAdminDriver+'\' OR Role__c=\'Driver'+'\' OR Role__c=\'Driver/Manager'+'\')';
        } else {
            query = 'Select id,Name from Contact where accountid=\''+accountId +'\'and (Role__c=\'Manager'+'\' OR Role__c=\'Driver/Manager'+'\')';
        }   
        List<Contact> managerlist = (List<Contact>)ExecuteQueryUtil.getListFromMap(ExecuteQueryUtil.getRecordMapWithSinglesObject(query));
        if(managerlist != null && managerlist.size() > 0) {
            return JSON.serialize(managerlist);    
        } else {   
            List<String > er= new List<String>();
            er.add('failed');
            return JSON.serialize(er);    
        }            
    }
    
    @AuraEnabled
    public static String getAllReportSoqlForDriver()
    {     
        string data;
        if(obj_current_report.Report_Type__c == 'Mileages Between 2 Trip Dates'){
            String LastMonth = String.valueof(System.today().addMonths(-1).month());
            String CurrentMonth = String.valueof(System.today().month());
            if(System.today().addMonths(-1).month() < 10){
                LastMonth = '0'+System.today().addMonths(-1).month();
            }
            if(System.today().month() < 10){
                CurrentMonth = '0'+System.today().month();
            }
            String lastmonthdate = System.today().addMonths(-1).year()+'-'+LastMonth+'-01';
            String currentMonthDate = System.today().year()+'-'+CurrentMonth+'-01';
            data = getAllReportSoql1(obj_current_report.Report_Soql__c,obj_current_report.Report_Type__c,'',lastmonthdate,currentMonthDate,contactId,accountId,reportID,'Driver'); 
        }
        else {
            data = getAllReportSoql1(obj_current_report.Report_Soql__c,obj_current_report.Report_Type__c,'',String.valueOf((System.today().addMonths(-1).toStartOfMonth()).format()), String.valueOf(system.today().addMonths(0).toStartofMonth().addDays(-1).format()),contactId,accountId,reportID,'Driver'); 
        }
        return data;
    }
    
    public static String getAllReportSoqlForManager()
    {     
        string data;
        if(obj_current_report.Report_Type__c == 'Mileages Between 2 Trip Dates'){
            data = getAllReportSoql1(obj_current_report.Report_Soql__c,obj_current_report.Report_Type__c,'',String.valueOf((System.today().addMonths(-1).toStartOfMonth()).format()),String.valueOf((System.today().toStartOfMonth()).format()),contactId,accountId,reportID,'Manager'); 
        } else {
            data = getAllReportSoql1(obj_current_report.Report_Soql__c,obj_current_report.Report_Type__c,'',String.valueOf((System.today().addMonths(-1).toStartOfMonth()).format()),String.valueOf((System.today().toStartOfMonth()).format()),contactId,accountId,reportID,'Manager'); 
        }
        return data;
    }
    
    @AuraEnabled
    public static String getAllReportSoql1(String reportSoql,String reporttype,String selectedManager, String tripStartDate, String tripEndDate,String contactid,String accountid,String reportid,String driverormanager)
    {
        String query  = reportSoql;
       
        if(query.contains('from Contact') || query.contains('from contact'))
        {
            if(reporttype=='Contact Created Between 2 Dates')
            {
                if(selectedManager==null || selectedManager=='')
                {
                    if(!query.contains('where'))
                    {
                        query = query+ ' where CreatedDate>='+buildDate(tripStartDate)+' AND CreatedDate<='+buildDate(tripEndDate) + ' AND accountid=\''+accountid+'\'';                          
                    }
                    else
                    {   // yes
                        query = query + ' AND CreatedDate>='+buildDate(tripStartDate)+' AND CreatedDate<='+buildDate(tripEndDate) + ' AND accountid=\''+accountid+'\'';    
                    }
                   
                    List<Contact> obj_contact_list = Database.query(query);                    
                    return JSON.serialize(obj_contact_list);
                }            
                else
                {
                    if(driverormanager=='Manager')
                    {
                        if(!query.contains('where'))
                        {
                            query = query+ ' where CreatedDate>='+buildDate(tripStartDate)+' AND CreatedDate<='+buildDate(tripEndDate)+' AND Manager__c=\''+selectedManager+'\'' + ' AND accountid=\''+accountid+'\'';                          
                        }
                        else
                        {   // yes
                            query = query + ' AND CreatedDate>='+buildDate(tripStartDate)+' AND CreatedDate<='+buildDate(tripEndDate)+' AND Manager__c=\''+selectedManager+'\'' + ' AND accountid=\''+accountid+'\'';                          
                        }
                    }
                    else
                    {
                        if(!query.contains('where'))
                        {
                            query = query+ ' where CreatedDate>='+buildDate(tripStartDate)+' AND CreatedDate<='+buildDate(tripEndDate)+' AND id=\''+selectedManager+'\'' + ' AND accountid=\''+accountid+'\'';                          
                        }
                        else
                        {   // yes
                            query = query + ' AND CreatedDate>='+buildDate(tripStartDate)+' AND CreatedDate<='+buildDate(tripEndDate)+' AND id=\''+selectedManager+'\'' + ' AND accountid=\''+accountid+'\'';                          
                        }
                    }                    
                   
                    List<Contact> obj_contact_list = Database.query(query); 
                    return JSON.serialize(obj_contact_list);
                }  
            }
            else if(reporttype=='Contact Activation Between 2 Dates') 
            {
                if(selectedManager==null || selectedManager=='')
                {
                    if(!query.contains('where'))
                    {
                        query = query+ ' where Activation_Date__c>='+buildDateforactivation(tripStartDate)+' AND Activation_Date__c<='+buildDateforactivation(tripEndDate) + ' AND accountid=\''+accountid+'\'';                                                
                    }
                    else
                    {   // yes
                        query = query + ' AND Activation_Date__c>='+buildDateforactivation(tripStartDate)+' AND Activation_Date__c<='+buildDateforactivation(tripEndDate) + ' AND accountid=\''+accountid+'\'';                          
                    }
               
                    List<Contact> obj_contact_list = Database.query(query); 
                    return JSON.serialize(obj_contact_list);
                }            
                else
                {
                    if(driverormanager=='Manager')
                    {
                        if(!query.contains('where'))
                        {
                            query = query+ ' where Activation_Date__c>='+buildDateforactivation(tripStartDate)+' AND Activation_Date__c<='+buildDateforactivation(tripEndDate)+' AND Manager__c=\''+selectedManager+'\'' + ' AND accountid=\''+accountid+'\'';                                                  
                        }
                        else
                        {   // yes
                            query = query + ' AND Activation_Date__c>='+buildDateforactivation(tripStartDate)+' AND Activation_Date__c<='+buildDateforactivation(tripEndDate)+' AND Manager__c=\''+selectedManager+'\'' + ' AND accountid=\''+accountid+'\'';                          
                        }
                    }
                    else
                    {
                        if(!query.contains('where'))
                        {
                            query = query+ ' where Activation_Date__c>='+buildDateforactivation(tripStartDate)+' AND Activation_Date__c<='+buildDateforactivation(tripEndDate)+' AND id=\''+selectedManager+'\'' + ' AND accountid=\''+accountid+'\'';                                                  
                        }
                        else
                        {   // yes
                            query = query + ' AND Activation_Date__c>='+buildDateforactivation(tripStartDate)+' AND Activation_Date__c<='+buildDateforactivation(tripEndDate)+' AND id=\''+selectedManager+'\'' + ' AND accountid=\''+accountid+'\'';                          
                        }
                    }                    
                  
                    List<Contact> obj_contact_list = Database.query(query); 
                    return JSON.serialize(obj_contact_list);
                } 

            } 
            else if(reporttype=='Contact Deactivation Between 2 Dates') 
            {
                if(selectedManager==null || selectedManager=='')
                {
                    if(!query.contains('where'))
                    {
                        query = query+ ' where Deactivated_Date__c>='+buildDate(tripStartDate)+' AND Deactivated_Date__c<='+buildDate(tripEndDate) + ' AND accountid=\''+accountid+'\'';                                                  
                    }
                    else
                    {   // yes
                        query = query + ' AND Deactivated_Date__c>='+buildDate(tripStartDate)+' AND Deactivated_Date__c<='+buildDate(tripEndDate) + ' AND accountid=\''+accountid+'\'';                          
                    }
                  
                    List<Contact> obj_contact_list = Database.query(query); 
                    return JSON.serialize(obj_contact_list);
                }            
                else
                {
                    if(driverormanager=='Manager')
                    {
                        if(!query.contains('where'))
                        {
                            query = query+ ' where Deactivated_Date__c>='+buildDate(tripStartDate)+' AND Deactivated_Date__c<='+buildDate(tripEndDate)+' AND Manager__c=\''+selectedManager+'\'' + ' AND accountid=\''+accountid+'\'';                                                 
                        }
                        else
                        {   // yes
                            query = query + ' AND Deactivated_Date__c>='+buildDate(tripStartDate)+' AND Deactivated_Date__c<='+buildDate(tripEndDate)+' AND Manager__c=\''+selectedManager+'\'' + ' AND accountid=\''+accountid+'\'';                          
                        }
                    }
                    else
                    {
                        if(!query.contains('where'))
                        {
                            query = query+ ' where Deactivated_Date__c>='+buildDate(tripStartDate)+' AND Deactivated_Date__c<='+buildDate(tripEndDate)+' AND ID=\''+selectedManager+'\'' + ' AND accountid=\''+accountid+'\'';                                                 
                        }
                        else
                        {   // yes
                            query = query + ' AND Deactivated_Date__c>='+buildDate(tripStartDate)+' AND Deactivated_Date__c<='+buildDate(tripEndDate)+' AND ID=\''+selectedManager+'\'' + ' AND accountid=\''+accountid+'\'';                          
                        } 
                    }
                    
                   
                    List<Contact> obj_contact_list = Database.query(query); 
                    return JSON.serialize(obj_contact_list);
                } 
            } 
            else if(reporttype=='Without Date Range') 
            {
               
                if(selectedManager !=null && selectedManager !='')
                {
                    if(driverormanager=='Manager')
                    {
                        if(!query.contains('where'))
                        {
                            query = query + ' where accountid=\''+accountid+'\''+' AND Manager__c=\''+selectedManager+'\'';
                        }
                        else
                        {
                            query = query +' AND accountid=\''+accountid+'\''+' AND Manager__c=\''+selectedManager+'\'';
                           // query = query +' AND accountid=\''+accountid+'\''+' AND ID=\''+selectedManager+'\'';
                        }
                    }
                    else
                    {
                        if(!query.contains('where'))
                        {
                            query = query + ' where accountid=\''+accountid+'\''+' AND ID=\''+selectedManager+'\'';
                        }
                        else
                        {
                            query = query +' AND accountid=\''+accountid+'\''+' AND ID=\''+selectedManager+'\'';
                        }
                    }
                }
                else 
                {
                    if(!query.contains('where'))
                    {
                        query = query + ' where accountid=\''+accountid+'\'';                          
                    }
                    else
                    {
                        query = query +' AND accountid=\''+accountid+'\'';                          
                    }
                                   
                }
                List<Contact> obj_contact_list = Database.query(query); 
                return JSON.serialize(obj_contact_list);
            }          
           
        }
        else if(query.contains('from Employee_Reimbursement__c'))
        {
            if(reporttype=='Reimbursements Created Between 2 Dates')
            {
                if(selectedManager==null || selectedManager=='')
                {
                    if(!query.contains('where'))
                    {
                        query = query+ ' where CreatedDate>='+buildDate(tripStartDate)+' AND CreatedDate<='+buildDate(tripEndDate) + ' AND Contact_Id__r.accountid=\''+accountid+'\'';                        
                    }
                    else
                    {   // yes
                        query = query + ' AND CreatedDate>='+buildDate(tripStartDate)+' AND CreatedDate<='+buildDate(tripEndDate) + ' AND Contact_Id__r.accountid=\''+accountid+'\''; 
                    }
                   
                    List<Employee_Reimbursement__c> obj_contact_list = Database.query(query);                    
                    return JSON.serialize(obj_contact_list);
                }            
                else
                {
                    if(driverormanager=='Manager')
                    {
                        if(!query.contains('where'))
                        {
                            query = query+ ' where CreatedDate>='+buildDate(tripStartDate)+' AND CreatedDate<='+buildDate(tripEndDate)+' AND Contact_Id__r.Manager__c=\''+selectedManager+'\'' + ' AND Contact_Id__r.accountid=\''+accountid+'\'';                    
                        }
                        else
                        {   // yes
                            query = query + ' AND CreatedDate>='+buildDate(tripStartDate)+' AND CreatedDate<='+buildDate(tripEndDate)+' AND Contact_Id__r.Manager__c=\''+selectedManager+'\'' + ' AND Contact_Id__r.accountid=\''+accountid+'\''; 
                        }
                    }
                    else
                    {
                        if(!query.contains('where'))
                        {
                            query = query+ ' where CreatedDate>='+buildDate(tripStartDate)+' AND CreatedDate<='+buildDate(tripEndDate)+' AND Contact_Id__c=\''+selectedManager+'\'' + ' AND Contact_Id__r.accountid=\''+accountid+'\'';                    
                        }
                        else
                        {   // yes
                            query = query + ' AND CreatedDate>='+buildDate(tripStartDate)+' AND CreatedDate<='+buildDate(tripEndDate)+' AND Contact_Id__c=\''+selectedManager+'\'' + ' AND Contact_Id__r.accountid=\''+accountid+'\''; 
                        }
                    }
                    
                    List<Employee_Reimbursement__c> obj_contact_list = Database.query(query);                    
                    return JSON.serialize(obj_contact_list);
                } 
            }
            else if(reporttype=='Reimbursements Between 2 Deactivation Dates') 
            {
                String contactQuery = 'Select id,Last_Reimbursement_Created__c from Contact where Deactivated_Date__c >='+buildDate(tripStartDate)+' AND Deactivated_Date__c <='+buildDate(tripEndDate) + ' AND accountid=\''+accountid+'\'';
                List<Contact> contactList = new List<Contact>();
                Map<String,String> contactReimbursementMap = new Map<String,String>();
                Set<String> monthList = new Set<String>();
                contactList = Database.query(contactQuery);
                if(contactList.size()>0)
                {
                    for(Contact currentContact : contactList)
                    {
                        if(!contactReimbursementMap.containsKey(currentContact.id))
                        {
                            contactReimbursementMap.put(currentContact.id,currentContact.Last_Reimbursement_Created__c);
                            monthList.add(currentContact.Last_Reimbursement_Created__c);
                        }                        
                    }
                }                
                List<String> monthofreimbursements = new List<String>();
                if(monthList.size()>0)
                {
                    monthofreimbursements.addAll(monthList);
                }
                String reimbursementquery='';
                String queryingdata='';
                if(!query.contains('Month__c') && query.contains('from'))
                {
                    List<String> fields = query.split('from');
                    fields[0]=fields[0]+',Month__c from ';
                    reimbursementquery = fields[0]+fields[1];
                   
                }
                if(!query.contains('Contact_Id__c') && query.contains('from'))
                {
                    List<String> fields = reimbursementquery.split('from');
                    fields[0]=fields[0]+',Contact_Id__c from ';
                    reimbursementquery = fields[0]+fields[1];
                  
                }
              
                if(selectedManager==null || selectedManager=='')
                {
                    
                    String monthquery = getReimbursementMonthCoparision(monthofreimbursements);
                    if(!query.contains('where'))
                    {
                        if(monthofreimbursements.size()>0)
                        {
                            queryingdata = ' where Month__c IN '+ monthquery + ' AND Contact_Id__r.Deactivated_Date__c >='+buildDate(tripStartDate)+' AND Contact_Id__r.Deactivated_Date__c <='+buildDate(tripEndDate) + ' AND Contact_Id__r.accountid=\''+accountid+'\'';
                            reimbursementquery = reimbursementquery+ ' where Month__c IN '+ monthquery + ' AND Contact_Id__r.Deactivated_Date__c >='+buildDate(tripStartDate)+' AND Contact_Id__r.Deactivated_Date__c <='+buildDate(tripEndDate) + ' AND Contact_Id__r.accountid=\''+accountid+'\''; 
                        }
                        else {
                            queryingdata = ' where Contact_Id__r.Deactivated_Date__c >='+buildDate(tripStartDate)+' AND Contact_Id__r.Deactivated_Date__c <='+buildDate(tripEndDate) + ' AND Contact_Id__r.accountid=\''+accountid+'\'';
                            reimbursementquery = reimbursementquery+ ' where Contact_Id__r.Deactivated_Date__c >='+buildDate(tripStartDate)+' AND Contact_Id__r.Deactivated_Date__c <='+buildDate(tripEndDate) + ' AND Contact_Id__r.accountid=\''+accountid+'\'';
                        }
                                             
                    }
                    else
                    {   // yes
                        if(monthofreimbursements.size()>0)
                        {
                            queryingdata = ' AND Month__c IN '+ monthquery + ' AND Contact_Id__r.Deactivated_Date__c >='+buildDate(tripStartDate)+' AND Contact_Id__r.Deactivated_Date__c <='+buildDate(tripEndDate) + ' AND Contact_Id__r.accountid=\''+accountid+'\'';
                            reimbursementquery = reimbursementquery + ' AND Month__c IN '+ monthquery + ' AND Contact_Id__r.Deactivated_Date__c >='+buildDate(tripStartDate)+' AND Contact_Id__r.Deactivated_Date__c <='+buildDate(tripEndDate) + ' AND Contact_Id__r.accountid=\''+accountid+'\'';
                        }
                        else {
                            queryingdata = ' AND Contact_Id__r.Deactivated_Date__c >='+buildDate(tripStartDate)+' AND Contact_Id__r.Deactivated_Date__c <='+buildDate(tripEndDate) + ' AND Contact_Id__r.accountid=\''+accountid+'\'';
                            reimbursementquery = reimbursementquery + ' AND Contact_Id__r.Deactivated_Date__c >='+buildDate(tripStartDate)+' AND Contact_Id__r.Deactivated_Date__c <='+buildDate(tripEndDate) + ' AND Contact_Id__r.accountid=\''+accountid+'\'';
                        }
                    }
                  
                    List<String> employeeReimbursementsIds = getReimbursmentIdsList(reimbursementquery,contactReimbursementMap);
                    if(employeeReimbursementsIds!=null && employeeReimbursementsIds.size()>0)
                    {
                        String idQuery = getReimbursementMonthCoparision(employeeReimbursementsIds);
                        if(!query.contains('where'))
                        {
                            query = query+' where ID IN '+ idQuery;
                        }
                        else {
                            query = query+' AND ID IN '+ idQuery;
                        } 
                        System.debug(query);                        
                    }
                    else {
                        query=query+queryingdata;
                    }
                    
                    List<Employee_Reimbursement__c> reimbursementList = Database.query(query);
                    return JSON.serialize(reimbursementList);
                    
                }            
                else
                {
                    if(driverormanager=='Manager')
                    {
                        String monthquery = getReimbursementMonthCoparision(monthofreimbursements);
                        if(!query.contains('where'))
                        {
                            if(monthofreimbursements.size()>0)
                            {
                                queryingdata = ' where Month__c IN '+ monthquery + ' AND Contact_Id__r.Deactivated_Date__c >='+buildDate(tripStartDate)+' AND Contact_Id__r.Deactivated_Date__c <='+buildDate(tripEndDate)+' AND Contact_Id__r.Manager__c=\''+selectedManager+'\'' + ' AND Contact_Id__r.accountid=\''+accountid+'\'';
                                reimbursementquery = reimbursementquery+ ' where Month__c IN '+ monthquery + ' AND Contact_Id__r.Deactivated_Date__c >='+buildDate(tripStartDate)+' AND Contact_Id__r.Deactivated_Date__c <='+buildDate(tripEndDate)+' AND Contact_Id__r.Manager__c=\''+selectedManager+'\'' + ' AND Contact_Id__r.accountid=\''+accountid+'\'';
                            }
                            else {
                                queryingdata = ' where Contact_Id__r.Deactivated_Date__c >='+buildDate(tripStartDate)+' AND Contact_Id__r.Deactivated_Date__c <='+buildDate(tripEndDate)+' AND Contact_Id__r.Manager__c=\''+selectedManager+'\'' + ' AND Contact_Id__r.accountid=\''+accountid+'\'';
                                reimbursementquery = reimbursementquery+ ' where Contact_Id__r.Deactivated_Date__c >='+buildDate(tripStartDate)+' AND Contact_Id__r.Deactivated_Date__c <='+buildDate(tripEndDate)+' AND Contact_Id__r.Manager__c=\''+selectedManager+'\'' + ' AND Contact_Id__r.accountid=\''+accountid+'\'';
                            }
                                                  
                        }
                        else
                        {   // yes
                            if(monthofreimbursements.size()>0)
                            {
                                 queryingdata = ' AND Month__c IN '+ monthquery + ' AND Contact_Id__r.Deactivated_Date__c >='+buildDate(tripStartDate)+' AND Contact_Id__r.Deactivated_Date__c <='+buildDate(tripEndDate)+' AND Contact_Id__r.Manager__c=\''+selectedManager+'\'' + ' AND Contact_Id__r.accountid=\''+accountid+'\'';
                                reimbursementquery = reimbursementquery + ' AND Month__c IN '+ monthquery + ' AND Contact_Id__r.Deactivated_Date__c >='+buildDate(tripStartDate)+' AND Contact_Id__r.Deactivated_Date__c <='+buildDate(tripEndDate)+' AND Contact_Id__r.Manager__c=\''+selectedManager+'\'' + ' AND Contact_Id__r.accountid=\''+accountid+'\'';
                            }
                            else 
                            {
                                queryingdata = ' AND Contact_Id__r.Deactivated_Date__c >='+buildDate(tripStartDate)+' AND Contact_Id__r.Deactivated_Date__c <='+buildDate(tripEndDate)+' AND Contact_Id__r.Manager__c=\''+selectedManager+'\'' + ' AND Contact_Id__r.accountid=\''+accountid+'\'';
                                reimbursementquery = reimbursementquery + ' AND Contact_Id__r.Deactivated_Date__c >='+buildDate(tripStartDate)+' AND Contact_Id__r.Deactivated_Date__c <='+buildDate(tripEndDate)+' AND Contact_Id__r.Manager__c=\''+selectedManager+'\'' + ' AND Contact_Id__r.accountid=\''+accountid+'\'';
                            }
                           
                        }
                    }
                    else
                    {
                        String monthquery = getReimbursementMonthCoparision(monthofreimbursements);
                        if(!query.contains('where'))
                        {
                            if(monthofreimbursements.size()>0)
                            {
                                queryingdata = ' where Month__c IN '+ monthquery + ' AND Contact_Id__r.Deactivated_Date__c >='+buildDate(tripStartDate)+' AND Contact_Id__r.Deactivated_Date__c <='+buildDate(tripEndDate)+' AND Contact_Id__c=\''+selectedManager+'\'' + ' AND Contact_Id__r.accountid=\''+accountid+'\'';
                                reimbursementquery = reimbursementquery +' where Month__c IN '+ monthquery + ' AND Contact_Id__r.Deactivated_Date__c >='+buildDate(tripStartDate)+' AND Contact_Id__r.Deactivated_Date__c <='+buildDate(tripEndDate)+' AND Contact_Id__c=\''+selectedManager+'\'' + ' AND Contact_Id__r.accountid=\''+accountid+'\'';
                            }
                            else {
                                queryingdata = ' where Contact_Id__r.Deactivated_Date__c >='+buildDate(tripStartDate)+' AND Contact_Id__r.Deactivated_Date__c <='+buildDate(tripEndDate)+' AND Contact_Id__c=\''+selectedManager+'\'' + ' AND Contact_Id__r.accountid=\''+accountid+'\'';
                                reimbursementquery = reimbursementquery +' where Contact_Id__r.Deactivated_Date__c >='+buildDate(tripStartDate)+' AND Contact_Id__r.Deactivated_Date__c <='+buildDate(tripEndDate)+' AND Contact_Id__c=\''+selectedManager+'\'' + ' AND Contact_Id__r.accountid=\''+accountid+'\'';
                            }
                                                   
                        }
                        else
                        {   // yes
                            if(monthofreimbursements.size()>0)
                            {
                                queryingdata = ' AND Month__c IN '+ monthquery + ' AND Contact_Id__r.Deactivated_Date__c >='+buildDate(tripStartDate)+' AND Contact_Id__r.Deactivated_Date__c <='+buildDate(tripEndDate)+' AND Contact_Id__c=\''+selectedManager+'\'' + ' AND Contact_Id__r.accountid=\''+accountid+'\'';
                                 reimbursementquery = reimbursementquery + ' AND Month__c IN '+ monthquery + ' AND Contact_Id__r.Deactivated_Date__c >='+buildDate(tripStartDate)+' AND Contact_Id__r.Deactivated_Date__c <='+buildDate(tripEndDate)+' AND Contact_Id__c=\''+selectedManager+'\'' + ' AND Contact_Id__r.accountid=\''+accountid+'\'';
                            }
                            else {
                                queryingdata = ' AND Contact_Id__r.Deactivated_Date__c >='+buildDate(tripStartDate)+' AND Contact_Id__r.Deactivated_Date__c <='+buildDate(tripEndDate)+' AND Contact_Id__c=\''+selectedManager+'\'' + ' AND Contact_Id__r.accountid=\''+accountid+'\'';
                                 reimbursementquery = reimbursementquery + ' AND Contact_Id__r.Deactivated_Date__c >='+buildDate(tripStartDate)+' AND Contact_Id__r.Deactivated_Date__c <='+buildDate(tripEndDate)+' AND Contact_Id__c=\''+selectedManager+'\'' + ' AND Contact_Id__r.accountid=\''+accountid+'\'';
                            }
                           
                        }
                    }
                    System.debug(reimbursementquery);
                    List<String> employeeReimbursementsIds = getReimbursmentIdsList(reimbursementquery,contactReimbursementMap);
                    if(employeeReimbursementsIds!=null && employeeReimbursementsIds.size()>0)
                    {
                        String idQuery = getReimbursementMonthCoparision(employeeReimbursementsIds);
                        if(!query.contains('where'))
                        {
                            query = query+' where ID IN '+ idQuery;
                        }
                        else {
                            query = query+' AND ID IN '+ idQuery;
                        } 
                        System.debug(query);                        
                    }
                    else {
                        query=query+queryingdata;
                    }
                    List<Employee_Reimbursement__c> reimbursementList = Database.query(query);
                    return JSON.serialize(reimbursementList);
                } 
            }  
            else if(reporttype=='Reimbursements Between 2 Dates For Month Range') 
            {
                List<String> monthofreimbursements= buildMonthForReimbursements(tripStartDate,tripEndDate);
                if((selectedManager==null || selectedManager=='')&&(monthofreimbursements!=null) && (monthofreimbursements.size()>0))
                {
                    String monthquery = getReimbursementMonthCoparision(monthofreimbursements);
                    if(!query.contains('where'))
                    {
                        query = query + ' where Month__c IN '+ monthquery + ' AND Contact_Id__r.accountid=\''+accountid+'\'';                        
                    }
                    else
                    {   // yes
                        query = query + ' AND Month__c IN '+ monthquery + ' AND Contact_Id__r.accountid=\''+accountid+'\'';                        
                    }
                  
                    List<Employee_Reimbursement__c> obj_contact_list = Database.query(query);                                        
                    return JSON.serialize(obj_contact_list);
                }            
                else if((selectedManager!=null && selectedManager!='')&&(monthofreimbursements!=null) && (monthofreimbursements.size()>0))
                {
                    if(driverormanager=='Manager')
                    {
                        String monthquery = getReimbursementMonthCoparision(monthofreimbursements);
                        if(!query.contains('where'))
                        {
                            query = query + ' where Month__c IN '+ monthquery+' AND Contact_Id__r.Manager__c=\''+selectedManager+'\'' + ' AND Contact_Id__r.accountid=\''+accountid+'\'';                        
                        }
                        else
                        {   // yes
                            query = query + ' AND Month__c IN '+ monthquery+' AND Contact_Id__r.Manager__c=\''+selectedManager+'\'' + ' AND Contact_Id__r.accountid=\''+accountid+'\'';                       
                        }
                       
                    }
                    else
                    {
                        String monthquery = getReimbursementMonthCoparision(monthofreimbursements);
                        if(!query.contains('where'))
                        {
                            query = query + ' where Month__c IN '+ monthquery+' AND Contact_Id__c=\''+selectedManager+'\'' + ' AND Contact_Id__r.accountid=\''+accountid+'\'';                        
                        }
                        else
                        {   // yes
                            query = query + ' AND Month__c IN '+ monthquery+' AND Contact_Id__c=\''+selectedManager+'\'' + ' AND Contact_Id__r.accountid=\''+accountid+'\'';                       
                        }
                      
                    }
                    List<Employee_Reimbursement__c> obj_contact_list = Database.query(query);                                        
                    return JSON.serialize(obj_contact_list);
                }
                else if((selectedManager!=null && selectedManager!='')&& ((monthofreimbursements==null) || (monthofreimbursements.size()==0)))
                {
                    if(driverormanager=='Manager')
                    {
                        if(!query.contains('where'))
                        {
                            query = query + ' where Contact_Id__r.Manager__c=\''+selectedManager+'\'' + ' AND Contact_Id__r.accountid=\''+accountid+'\'';                       
                        }
                        else
                        {   // yes
                            query = query + ' AND Contact_Id__r.Manager__c=\''+selectedManager+'\'' + ' AND Contact_Id__r.accountid=\''+accountid+'\'';                      
                        }
                       
                    }
                    else
                    {
                        if(!query.contains('where'))
                        {
                            query = query + ' where Contact_Id__c=\''+selectedManager+'\'' + ' AND Contact_Id__r.accountid=\''+accountid+'\'';                       
                        }
                        else
                        {   // yes
                            query = query + ' AND Contact_Id__c=\''+selectedManager+'\'' + ' AND Contact_Id__r.accountid=\''+accountid+'\'';                      
                        }
                       
                    }
                    
                    List<Employee_Reimbursement__c> obj_contact_list = Database.query(query);                                        
                    return JSON.serialize(obj_contact_list);
                } 
                else
                {
                    if(!query.contains('where'))
                    {
                        query = query + ' where Contact_Id__r.accountid=\''+accountid+'\'';                       
                    }
                    else
                    {   // yes
                        query = query + ' AND Contact_Id__r.accountid=\''+accountid+'\'';                      
                    }
                   
                    List<Employee_Reimbursement__c> obj_contact_list = Database.query(query);                                        
                    return JSON.serialize(obj_contact_list);
                }
            }  
            else if(reporttype=='Without Date Range') 
            {
                
                if(selectedManager !=null && selectedManager !='')
                {
                    if(driverormanager=='Manager')
                    {
                        if(!query.contains('where'))
                        {
                            query = query + ' where Contact_Id__r.Manager__c=\''+selectedManager+'\'' + ' AND Contact_Id__r.accountid=\''+accountid+'\'';
                        }
                        else
                        {
                            query = query +' AND Contact_Id__r.Manager__c=\''+selectedManager+'\'' + ' AND Contact_Id__r.accountid=\''+accountid+'\'';
                        }
                    }
                    else
                    {
                        if(!query.contains('where'))
                        {
                            query = query + ' where Contact_Id__c=\''+selectedManager+'\'' + ' AND Contact_Id__r.accountid=\''+accountid+'\'';
                        }
                        else
                        {
                            query = query +' AND Contact_Id__c=\''+selectedManager+'\'' + ' AND Contact_Id__r.accountid=\''+accountid+'\'';
                        }
                    }                
                }
                else 
                {
                    if(!query.contains('where'))
                    {
                        query = query + ' where Contact_Id__r.accountid=\''+accountid+'\'';
                    }
                    else
                    {
                        query = query +' AND Contact_Id__r.accountid=\''+accountid+'\'';
                    }
                }
                System.debug(query);
                List<Employee_Reimbursement__c> obj_contact_list = Database.query(query);                                      
                return JSON.serialize(obj_contact_list);
            }  
        }
        else if(query.contains('from Employee_Mileage__c'))
        {
         
            if(reporttype=='Mileages Created Between 2 Dates')
            {
                if(selectedManager==null || selectedManager=='')
                {
                    if(!query.contains('where'))
                    {
                        query = query+ ' where CreatedDate>='+buildDate(tripStartDate)+' AND CreatedDate<='+buildDate(tripEndDate) + ' AND EmployeeReimbursement__r.Contact_Id__r.accountid=\''+accountid+'\'';                       
                    }
                    else
                    {   // yes
                        query = query + ' AND CreatedDate>='+buildDate(tripStartDate)+' AND CreatedDate<='+buildDate(tripEndDate) + ' AND EmployeeReimbursement__r.Contact_Id__r.accountid=\''+accountid+'\'';
                    }
                   
                    List<Employee_Mileage__c> obj_contact_list = Database.query(query);                    
                    return JSON.serialize(obj_contact_list);
                }            
                else
                {
                    if(driverormanager=='Manager')
                    {
                        if(!query.contains('where'))
                        {
                            query = query+ ' where CreatedDate>='+buildDate(tripStartDate)+' AND CreatedDate<='+buildDate(tripEndDate)+' AND EmployeeReimbursement__r.Contact_Id__r.Manager__c=\''+selectedManager+'\''+ ' AND EmployeeReimbursement__r.Contact_Id__r.accountid=\''+accountid+'\'';                        
                        }
                        else
                        {   // yes
                            query = query + ' AND CreatedDate>='+buildDate(tripStartDate)+' AND CreatedDate<='+buildDate(tripEndDate)+' AND EmployeeReimbursement__r.Contact_Id__r.Manager__c=\''+selectedManager+'\''+ ' AND EmployeeReimbursement__r.Contact_Id__r.accountid=\''+accountid+'\'';
                        }
                    }
                    else
                    {
                        if(!query.contains('where'))
                        {
                            query = query+ ' where CreatedDate>='+buildDate(tripStartDate)+' AND CreatedDate<='+buildDate(tripEndDate)+' AND EmployeeReimbursement__r.Contact_Id__c=\''+selectedManager+'\''+ ' AND EmployeeReimbursement__r.Contact_Id__r.accountid=\''+accountid+'\'';                        
                        }
                        else
                        {   // yes
                            query = query + ' AND CreatedDate>='+buildDate(tripStartDate)+' AND CreatedDate<='+buildDate(tripEndDate)+' AND EmployeeReimbursement__r.Contact_Id__c=\''+selectedManager+'\''+ ' AND EmployeeReimbursement__r.Contact_Id__r.accountid=\''+accountid+'\'';
                        }
                    }                    
                    System.debug(query);
                    List<Employee_Mileage__c> obj_contact_list = Database.query(query);
                    return JSON.serialize(obj_contact_list);
                }
            }
            else if(reporttype=='Mileages Between 2 Deactivation Dates') 
            {
               
                if(selectedManager==null || selectedManager=='')
                {
                    if(!query.contains('where'))
                    {
                        query = query+ ' where EmployeeReimbursement__r.Contact_Id__r.Deactivated_Date__c>='+buildDate(tripStartDate)+' AND EmployeeReimbursement__r.Contact_Id__r.Deactivated_Date__c<='+buildDate(tripEndDate)+ ' AND EmployeeReimbursement__r.Contact_Id__r.accountid=\''+accountid+'\'';                        
                    }
                    else
                    {   // yes
                        query = query + ' AND EmployeeReimbursement__r.Contact_Id__r.Deactivated_Date__c>='+buildDate(tripStartDate)+' AND EmployeeReimbursement__r.Contact_Id__r.Deactivated_Date__c<='+buildDate(tripEndDate)+ ' AND EmployeeReimbursement__r.Contact_Id__r.accountid=\''+accountid+'\'';
                    }
                    System.debug(query);
                    List<Employee_Mileage__c> obj_contact_list = Database.query(query);
                    return JSON.serialize(obj_contact_list);
                }            
                else
                {
                    if(driverormanager=='Manager')
                    {
                        if(!query.contains('where'))
                        {
                            query = query+ ' where EmployeeReimbursement__r.Contact_Id__r.Deactivated_Date__c>='+buildDate(tripStartDate)+' AND EmployeeReimbursement__r.Contact_Id__r.Deactivated_Date__c<='+buildDate(tripEndDate)+' AND EmployeeReimbursement__r.Contact_Id__r.Manager__c=\''+selectedManager+'\''+ ' AND EmployeeReimbursement__r.Contact_Id__r.accountid=\''+accountid+'\'';                       
                        }
                        else
                        {   // yes
                            query = query + ' AND EmployeeReimbursement__r.Contact_Id__r.Deactivated_Date__c>='+buildDate(tripStartDate)+' AND EmployeeReimbursement__r.Contact_Id__r.Deactivated_Date__c<='+buildDate(tripEndDate)+' AND EmployeeReimbursement__r.Contact_Id__r.Manager__c=\''+selectedManager+'\''+ ' AND EmployeeReimbursement__r.Contact_Id__r.accountid=\''+accountid+'\'';
                        }
                    }
                    else
                    {
                        if(!query.contains('where'))
                        {
                            query = query+ ' where EmployeeReimbursement__r.Contact_Id__r.Deactivated_Date__c>='+buildDate(tripStartDate)+' AND EmployeeReimbursement__r.Contact_Id__r.Deactivated_Date__c<='+buildDate(tripEndDate)+' AND EmployeeReimbursement__r.Contact_Id__c=\''+selectedManager+'\''+ ' AND EmployeeReimbursement__r.Contact_Id__r.accountid=\''+accountid+'\'';                       
                        }
                        else
                        {   // yes
                            query = query + ' AND EmployeeReimbursement__r.Contact_Id__r.Deactivated_Date__c>='+buildDate(tripStartDate)+' AND EmployeeReimbursement__r.Contact_Id__r.Deactivated_Date__c<='+buildDate(tripEndDate)+' AND EmployeeReimbursement__r.Contact_Id__c=\''+selectedManager+'\''+ ' AND EmployeeReimbursement__r.Contact_Id__r.accountid=\''+accountid+'\'';
                        }
                    }
                    
                    System.debug(query);
                    List<Employee_Mileage__c> obj_contact_list = Database.query(query);
                    return JSON.serialize(obj_contact_list);
                }
            }  
            else if(reporttype=='Mileages Between 2 Trip Dates') 
            {
               
                if(selectedManager==null || selectedManager=='')
                {System.debug('tripStartDate'+tripStartDate);
                System.debug('tripEndDate'+tripEndDate);
                    if(!query.contains('where'))
                    {
                        query = query+ ' where Trip_Date__c>='+buildDateforTripDate(tripStartDate)+' AND Trip_Date__c<='+buildDateforTripDate(tripEndDate)+ ' AND EmployeeReimbursement__r.Contact_Id__r.accountid=\''+accountid+'\'';                        
                    }
                    else
                    {   // yes
                        query = query + ' AND Trip_Date__c>='+buildDateforTripDate(tripStartDate)+' AND Trip_Date__c<='+buildDateforTripDate(tripEndDate)+ ' AND EmployeeReimbursement__r.Contact_Id__r.accountid=\''+accountid+'\'';
                    }
                    System.debug(query);
                    List<Employee_Mileage__c> obj_contact_list = Database.query(query);
                    return JSON.serialize(obj_contact_list);
                }            
                else
                {
                    if(driverormanager=='Manager')
                    {
                        if(!query.contains('where'))
                        {
                            query = query+ ' where Trip_Date__c>='+buildDateforTripDate(tripStartDate)+' AND Trip_Date__c<='+buildDateforTripDate(tripEndDate)+' AND EmployeeReimbursement__r.Contact_Id__r.Manager__c=\''+selectedManager+'\''+ ' AND EmployeeReimbursement__r.Contact_Id__r.accountid=\''+accountid+'\'';                       
                        }
                        else
                        {   // yes
                            query = query + ' AND Trip_Date__c>='+buildDateforTripDate(tripStartDate)+' AND Trip_Date__c<='+buildDateforTripDate(tripEndDate)+' AND EmployeeReimbursement__r.Contact_Id__r.Manager__c=\''+selectedManager+'\''+ ' AND EmployeeReimbursement__r.Contact_Id__r.accountid=\''+accountid+'\'';
                        }
                    }
                    else
                    {
                        if(!query.contains('where'))
                        {
                            query = query+ ' where Trip_Date__c>='+buildDateforTripDate(tripStartDate)+' AND Trip_Date__c<='+buildDateforTripDate(tripEndDate)+' AND EmployeeReimbursement__r.Contact_Id__c=\''+selectedManager+'\''+ ' AND EmployeeReimbursement__r.Contact_Id__r.accountid=\''+accountid+'\'';                       
                        }
                        else
                        {   // yes
                            query = query + ' AND Trip_Date__c>='+buildDateforTripDate(tripStartDate)+' AND Trip_Date__c<='+buildDateforTripDate(tripEndDate)+' AND EmployeeReimbursement__r.Contact_Id__c=\''+selectedManager+'\''+ ' AND EmployeeReimbursement__r.Contact_Id__r.accountid=\''+accountid+'\'';
                        }
                    }
                    
                    System.debug(query);
                    List<Employee_Mileage__c> obj_contact_list = Database.query(query);
                    return JSON.serialize(obj_contact_list);
                }
            } 
            else if(reporttype=='Mileages Between 2 Dates for Month Range') 
            {
                
                List<String> monthofreimbursements= buildMonthForReimbursements(tripStartDate,tripEndDate);
                if((selectedManager==null || selectedManager=='')&&(monthofreimbursements!=null) && (monthofreimbursements.size()>0))
                {
                  
                    String monthquery = getReimbursementMonthCoparision(monthofreimbursements);
                    if(!query.contains('where'))
                    {
                        query = query + ' where EmployeeReimbursement__r.Month__c IN '+ monthquery+ ' AND EmployeeReimbursement__r.Contact_Id__r.accountid=\''+accountid+'\'';                        
                         
                    }
                    else
                    {   // yes
                    
                        query = query + ' AND EmployeeReimbursement__r.Month__c IN '+ monthquery+ ' AND EmployeeReimbursement__r.Contact_Id__r.accountid=\''+accountid+'\'';                        
                       
                    }
                   
                   List<Employee_Mileage__c> obj_contact_list = Database.query(query);
                    return JSON.serialize(obj_contact_list);
                }            
                else if((selectedManager!=null && selectedManager!='')&&(((monthofreimbursements!=null) && (monthofreimbursements.size()>0))))
                {
                    if(driverormanager=='Manager')
                    {
                        String monthquery = getReimbursementMonthCoparision(monthofreimbursements);
                        if(!query.contains('where'))
                        {
                            query = query + ' where EmployeeReimbursement__r.Month__c IN '+ monthquery+' AND EmployeeReimbursement__r.Contact_Id__r.Manager__c=\''+selectedManager+'\''+ ' AND EmployeeReimbursement__r.Contact_Id__r.accountid=\''+accountid+'\'';                       
                        }
                        else
                        {   // yes
                            query = query + ' AND EmployeeReimbursement__r.Month__c IN '+ monthquery+' AND EmployeeReimbursement__r.Contact_Id__r.Manager__c=\''+selectedManager+'\''+ ' AND EmployeeReimbursement__r.Contact_Id__r.accountid=\''+accountid+'\'';                       
                        } 
                    }
                    else
                    {
                        String monthquery = getReimbursementMonthCoparision(monthofreimbursements);
                        if(!query.contains('where'))
                        {
                            query = query + ' where EmployeeReimbursement__r.Month__c IN '+ monthquery+' AND EmployeeReimbursement__r.Contact_Id__c=\''+selectedManager+'\''+ ' AND EmployeeReimbursement__r.Contact_Id__r.accountid=\''+accountid+'\'';                       
                        }
                        else
                        {   // yes
                            query = query + ' AND EmployeeReimbursement__r.Month__c IN '+ monthquery+' AND EmployeeReimbursement__r.Contact_Id__c=\''+selectedManager+'\''+ ' AND EmployeeReimbursement__r.Contact_Id__r.accountid=\''+accountid+'\'';                       
                        } 
                    }                    
                   System.debug(query);
                    List<Employee_Mileage__c> obj_contact_list = Database.query(query);
                    system.debug('obj_contact_list========'+obj_contact_list);
                    return JSON.serialize(obj_contact_list);
                }
                else if((selectedManager!=null && selectedManager!='')&& (((monthofreimbursements==null) && (monthofreimbursements.size()==0))))
                {
                    if(driverormanager=='Manager')
                    {
                        if(!query.contains('where'))
                        {
                            query = query + ' where EmployeeReimbursement__r.Contact_Id__r.Manager__c=\''+selectedManager+'\''+ ' AND EmployeeReimbursement__r.Contact_Id__r.accountid=\''+accountid+'\'';                        
                        }
                        else
                        {   // yes
                            query = query + ' AND EmployeeReimbursement__r.Contact_Id__r.Manager__c=\''+selectedManager+'\''+ ' AND EmployeeReimbursement__r.Contact_Id__r.accountid=\''+accountid+'\'';                       
                        }
                    }
                    else
                    {
                        if(!query.contains('where'))
                        {
                            query = query + ' where EmployeeReimbursement__r.Contact_Id__c=\''+selectedManager+'\''+ ' AND EmployeeReimbursement__r.Contact_Id__r.accountid=\''+accountid+'\'';                        
                        }
                        else
                        {   // yes
                            query = query + ' AND EmployeeReimbursement__r.Contact_Id__c=\''+selectedManager+'\''+ ' AND EmployeeReimbursement__r.Contact_Id__r.accountid=\''+accountid+'\'';                       
                        }
                    }
                    
                    System.debug(query);
                    List<Employee_Mileage__c> obj_contact_list = Database.query(query);
                    system.debug('obj_contact_list========'+obj_contact_list);
                    return JSON.serialize(obj_contact_list);
                } 
                else
                {
                    if(!query.contains('where'))
                    {
                        query = query + ' where EmployeeReimbursement__r.Contact_Id__r.accountid=\''+accountid+'\'';                        
                    }
                    else
                    {   // yes
                        query = query + ' AND EmployeeReimbursement__r.Contact_Id__r.accountid=\''+accountid+'\'';                       
                    }
                   System.debug(query);
                   List<Employee_Mileage__c> obj_contact_list = Database.query(query);
                    return JSON.serialize(obj_contact_list);
                }
            }  
            else if(reporttype=='Without Date Range') 
            {
                System.debug(query);
                if(selectedManager !=null && selectedManager !='')
                {
                    if(driverormanager=='Manager')
                    {
                        if(!query.contains('where'))
                        {
                            query = query + ' where EmployeeReimbursement__r.Contact_Id__r.Manager__c=\''+selectedManager+'\''+ ' AND EmployeeReimbursement__r.Contact_Id__r.accountid=\''+accountid+'\'';
                        }
                        else
                        {
                            query = query +' AND EmployeeReimbursement__r.Contact_Id__r.Manager__c=\''+selectedManager+'\''+ ' AND EmployeeReimbursement__r.Contact_Id__r.accountid=\''+accountid+'\'';
                        }
                    }
                    else
                    {
                        if(!query.contains('where'))
                        {
                            query = query + ' where EmployeeReimbursement__r.Contact_Id__c=\''+selectedManager+'\''+ ' AND EmployeeReimbursement__r.Contact_Id__r.accountid=\''+accountid+'\'';
                        }
                        else
                        {
                            query = query +' AND EmployeeReimbursement__r.Contact_Id__c=\''+selectedManager+'\''+ ' AND EmployeeReimbursement__r.Contact_Id__r.accountid=\''+accountid+'\'';
                        }
                    }
                    
                    System.debug(query);

                }
                else
                {
                    if(!query.contains('where'))
                    {
                        query = query + ' where EmployeeReimbursement__r.Contact_Id__r.accountid=\''+accountid+'\'';                        
                    }
                    else
                    {   // yes
                        query = query + ' AND EmployeeReimbursement__r.Contact_Id__r.accountid=\''+accountid+'\'';                       
                    }
                   System.debug(query);
                   List<Employee_Mileage__c> obj_contact_list = Database.query(query);
                    return JSON.serialize(obj_contact_list);
                }
                
               List<Employee_Mileage__c> obj_contact_list = Database.query(query);
                return JSON.serialize(obj_contact_list);
            }  
        }
        return '';
    }
    
    public static String buildDateforactivation(String datefield)
    {
        Date myDate = date.parse(datefield);
        String monthString = String.valueof(myDate.month());
        monthString = myDate.month() < 10 ? '0' + monthString : monthString;
        String dayString = String.valueof(myDate.day());
        dayString = myDate.day() < 10 ? '0' + dayString : dayString;
        String value = myDate.year() + '-' + monthString + '-' + dayString;
        return value;    
    }
    public static String buildDateforTripDate(String param1){
        String delimiter = '/';
        String date1;
        if(param1.contains('/')){
            List<String> stringList = Utils.SplitStringToList(param1,delimiter);
            date1 = '20'+stringList[2]+'-'+stringList[0]+'-'+stringList[1];
        }
        else {
            date1 = param1;
        }
        system.debug('date1'+date1);
        return date1;
    }
    public static String buildDate(String datefield)
    {
        Date myDate = date.parse(datefield);
        Time myTime = Time.newInstance(0, 0, 0, 0);
        DateTime dt = DateTime.newInstance(myDate, myTime);
        return dt.format('yyyy-MM-dd\'T\'hh:mm:ss\'Z\'');    
    }    
    public static List<String> buildMonthForReimbursements(String startdate,String enddate)
    {
        List<String> obj_month_reimbursements = new List<String>();
        Date startdateformonth = date.parse(startdate);
        Date enddateformonth = date.parse(enddate);
        List<String> obj_startdatelist = new List<String>();
        if(String.valueOf(startdate).contains('-'))
        {
            obj_startdatelist = String.valueOf(startdate).split('-');
        }
        else if((String.valueOf(startdate).contains('/')))
        {
            obj_startdatelist = String.valueOf(startdate).split('/');                
        }
        List<String> obj_enddatelist = new List<String>();
        if(String.valueOf(enddate).contains('-'))
        {
            obj_enddatelist = String.valueOf(enddate).split('-');
        }
        else if((String.valueOf(enddate).contains('/')))
        {
            obj_enddatelist = String.valueOf(enddate).split('/');                
        }
        if(obj_startdatelist[2]==obj_enddatelist[2])
        {
           // both of them are in same year
            for(Integer i = Integer.valueOf(obj_startdatelist[0]);i<=Integer.valueOf(obj_enddatelist[0]);i++)
            {
                if(i<10)
                {
                    String month = '0'+String.valueOf(i)+'-'+String.valueOf(startdateformonth.year());
                    obj_month_reimbursements.add(month);
                }
                else
                {
                    String month = String.valueOf(i)+'-'+String.valueOf(startdateformonth.year());
                    obj_month_reimbursements.add(month);
                }                
            } 

        }
        else 
        {
            // both of them are not in same year
            for(Integer i = Integer.valueOf(obj_startdatelist[0]);i<=12;i++)
            {
                if(i<10)
                {
                    String month = '0'+String.valueOf(i)+'-'+String.valueOf(startdateformonth.year());
                    obj_month_reimbursements.add(month);
                }
                else
                {
                    String month = String.valueOf(i)+'-'+String.valueOf(startdateformonth.year());
                    obj_month_reimbursements.add(month);
                } 
            }
            for(Integer i = 1;i<=Integer.valueOf(obj_enddatelist[0]);i++)
            {
                if(i<10)
                {
                    String month ='0'+String.valueOf(i)+'-'+String.valueOf(enddateformonth.year()); 
                    obj_month_reimbursements.add(month);
                }
                else
                {
                    String month = String.valueOf(i)+'-'+String.valueOf(enddateformonth.year());
                    obj_month_reimbursements.add(month);
                } 
            }
        }
        return obj_month_reimbursements;
    }
    public static String getReimbursementMonthCoparision(List<String> obj_month_of_year)
    {       
        String editedquery = '( ';
        for(String s:obj_month_of_year)
        {
            editedquery = editedquery + '\''+s+ '\','; 
        }
        if(editedquery.endsWith(','))
        {
            editedquery = editedquery.removeEnd(',');
        }
        editedquery = editedquery+' )';
        
        return editedquery;
    }

    @AuraEnabled
    public static List<String> getReimbursmentIdsList(String query,Map<String,String> contactReimbursementMap)
    {
        List<Employee_Reimbursement__c> reimbursementList = Database.query(query);
        List<String> employeeReimbursementsIds = new List<String>();
        if(reimbursementList!=null && reimbursementList.size()>0)
        {
            for(Employee_Reimbursement__c currentReimbursement : reimbursementList)
            {
                if(contactReimbursementMap.containsKey(currentReimbursement.Contact_Id__c) && currentReimbursement.Month__c==contactReimbursementMap.get(currentReimbursement.Contact_Id__c))
                {
                    employeeReimbursementsIds.add(currentReimbursement.id);
                }
            }
        }
        return employeeReimbursementsIds;
    }
    @AuraEnabled
    public static String getAllReportHeaders1(String reportid)
    {
        List<String> obj_list_of_headers = new List<String>();
        String query = 'Select id,Report_Header__c from Custom_Report__c where id=\''+reportid+'\'';
        Custom_Report__c obj_Custom_Report = (Custom_Report__c)(((List<Custom_Report__c>)ExecuteQueryUtil.getRecordListFromsObject(query))[0]);
        if((obj_Custom_Report.Report_Header__c!=null) && (obj_Custom_Report.Report_Header__c.contains(',')))
        {
            obj_list_of_headers = obj_Custom_Report.Report_Header__c.split(',');
        }
        if(obj_list_of_headers.size()>0)
        {
            return JSON.serialize(obj_list_of_headers);
        }
        return '';
    }
}