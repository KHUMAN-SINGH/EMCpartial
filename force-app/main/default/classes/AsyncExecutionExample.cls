public class AsyncExecutionExample implements Queueable {
    
     public Contact con ; 
    public String responseBody;
    public AsyncExecutionExample(Contact contact,String responseBody){
        this.con = contact ; 
        this.responseBody = responseBody;
    }
    public void execute(QueueableContext context) {
           if(con.TrueDialog_Contact_Id__c==null){    
                
                TrueDialogContact trueDialog = TrueDialogContact.parse(responseBody);   
                con.TrueDialog_Contact_Id__c = trueDialog.id;
                
                con.TrueDialog_SMS_Enabled__c = true;
                con.TrueDialog_MMS_Enabled__c = true;
                update con;
                
//                        conList.add(con);
            }
    }
}