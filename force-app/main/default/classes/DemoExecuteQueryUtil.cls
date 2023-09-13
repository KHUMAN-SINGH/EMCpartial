public with sharing class DemoExecuteQueryUtil {
    public DemoExecuteQueryUtil() {

    }
    public static List<sObject> getRecordListFromsObject(String query)
    {

        if(query!=null && query !='')
        {
            return Database.query(query);
        }
        else
        {
            return null;
        }
    }
}