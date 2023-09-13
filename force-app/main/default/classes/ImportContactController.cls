public class ImportContactController {
// public Blob csvFileBody{get;set;}
    public String data{get;set;}
    //public Blob csvFileBody =  Blob.valueOf(data);
    public String accountid {get;set;}
    public string csvAsString{get;set;}
    
     public PageReference ReadFile(){ 
          ImportContactdatafromCSVController batch = new ImportContactdatafromCSVController(data, accountid);
        Database.executeBatch(batch,100);
       // ApexPages.addMessage(new ApexPages.message(ApexPages.severity.CONFIRM,'File uploaded successfully and Check Your Mail For Failure Records'));
        //r=true;
        return Null;
    } 
}