public class AddOrUpdateInsuranceMessage {
    public AddOrUpdateInsuranceMessage(String conId) {
        updateInsuranceMessage(conId);
    }
    public Static void updateInsuranceMessage(String conId){
        System.debug('conId: '+conId);
        List<Message__c> msgListUpdate = new List<Message__c>();
        for(Message__c msgList : [Select Id,Contacts__c,Notification_Message__c,Unread__c from Message__c where Contacts__c =: conId ]){
            System.debug('msgList: '+msgList);
            if(msgList.Notification_Message__c != null && msgList.Notification_Message__c.contains('Thanks for uploading your insurance, we will evaluate your insurance shortly.')){
                System.debug('msgList.Notification_Message__c: '+msgList.Notification_Message__c);
                msgList.Unread__c = True;
                if(msgList != null){
                    msgListUpdate.add(msgList);
                }
            }
        }
        if(msgListUpdate.size() > 0){
            update msgListUpdate;
        }else{
            Message__c newMessage = new Message__c();
            newMessage.Notification_Message__c = 'Thanks for uploading your insurance, we will evaluate your insurance shortly.';
            newMessage.Unread__c = True;
            newMessage.Contacts__c = conId;
            insert newMessage;
        }
    }
}