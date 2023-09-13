public class UpdateActivityStatusInMlogBatch implements Database.Batchable<sObject>,Database.AllowsCallouts{
    public Set<Id> reimbersumentIds;
    public Map<String,List<String>> approveReimwithTripIdMap;
    public static final String MLOGACCOUNT = System.Label.Triplog_New_URL + ',' + System.Label.Triplog_New_URL2;

    public UpdateActivityStatusInMlogBatch(Set<Id> recordIds) {
        this.reimbersumentIds = recordIds;
    }

    public Database.QueryLocator start(Database.BatchableContext BC) {
        
        String query = 'SELECT Id,EmployeeReimbursement__r.Contact_Id__r.Account.Triplog_API__c, ' +
                       ' From_Location__c, To_Location__c, FromLocationId__c, ToLocationId__c, Trip_Id__c, ' +
                       ' Trip_Origin_State__c, Trip_Destination_State__c, EmployeeReimbursement__c, EmployeeReimbursement__r.Contact_Id__r.Driving_States__c '+
                       ' FROM Employee_Mileage__c WHERE ' +
                       ' EmployeeReimbursement__r.Contact_Id__r.Account.Triplog_API__c != null ';
        if(reimbersumentIds != null && !reimbersumentIds.isEmpty())
            query += ' AND  EmployeeReimbursement__c In: reimbersumentIds';
            query += ' order by CreatedDate desc ' + ' LIMIT 49999';
            System.debug('query: '+query);
        return Database.getQueryLocator(query);
    }
    public void execute(Database.BatchableContext BC, List<sObject> scope) {
        approveReimwithTripIdMap = new Map<String, List<String>>();
        List<String> milesId = new List<String>();
        Map<String,List<String>> mileMap = new Map<String,List<String>>();
        List<String> lstStateValue = new List<String>();
        System.debug('scope: '+scope);

        for(Employee_Mileage__c miles : (List<Employee_Mileage__c>) scope) {
            System.debug('miles: '+miles.EmployeeReimbursement__r.Contact_Id__r.Driving_States__c);
            System.debug('miles Trip_Id__c : '+miles.Trip_Id__c);
            lstStateValue = miles.EmployeeReimbursement__r.Contact_Id__r.Driving_States__c.split(';');
            if( !lstStateValue.contains(miles.Trip_Origin_State__c) || !lstStateValue.contains(miles.Trip_Destination_State__c)){
                if (mileMap.containsKey(miles.EmployeeReimbursement__r.Contact_Id__r.Account.Triplog_API__c)) {
                    mileMap.get(miles.EmployeeReimbursement__r.Contact_Id__r.Account.Triplog_API__c).add(String.valueOf(miles.Trip_Id__c));
                }
                else {
                    mileMap.put(miles.EmployeeReimbursement__r.Contact_Id__r.Account.Triplog_API__c, new List<String>{ String.valueOf(miles.Trip_Id__c) });
                }
            }

            /*if (mileMap.containsKey(miles.EmployeeReimbursement__r.Contact_Id__r.Account.Triplog_API__c)) {
                mileMap.get(miles.EmployeeReimbursement__r.Contact_Id__r.Account.Triplog_API__c).add(String.valueOf(miles.Trip_Id__c));
            }
            else {
                mileMap.put(miles.EmployeeReimbursement__r.Contact_Id__r.Account.Triplog_API__c, new List<String>{ String.valueOf(miles.Trip_Id__c) });
            }*/
        }
        System.debug('mileMap: '+mileMap);
        if(mileMap.size() > 0){
            for(String miles : mileMap.keySet()){  
                System.debug('body: '+BuildBody( 'Pay Scheduled', mileMap.get(miles)));
                putHTTPUpdateTriplogActivity(miles,BuildBody( 'Uncategorized', mileMap.get(miles)));
            }
        }
    }
    public void finish(Database.BatchableContext BC) {}

    public static String BuildBody(String status, List<String> mileageIds) {
        return '{"activity":' + status + ',"ids":[' + String.join(mileageIds, ',') + ']}';
    }

    public static void putHTTPUpdateTriplogActivity(String ApiKey, String bodyOfReq) {
        String baseURL = !MLOGACCOUNT.Contains(ApiKey) ? StaticValues.TRIPLOG_BASEURL : StaticValues.MLOG_BASEURL;
        Http putHTTP = new Http(); 
        HttpRequest putReq = new HttpRequest();               
        HttpResponse putRes = new HttpResponse();
        putReq.setEndpoint(baseURL + '/api/tripStatus');
        putReq.setMethod('PUT');                 
        putReq.setBody(bodyOfReq);
        putReq.setTimeout(120000);
        putReq.setHeader('Authorization', 'apikey ' + ApiKey);

        if(!Test.IsRunningTest()) {
            putRes = putHTTP.send(putReq);
            System.debug('putRes: '+putRes);
            System.debug(putRes.getBody());
        }
    }
}