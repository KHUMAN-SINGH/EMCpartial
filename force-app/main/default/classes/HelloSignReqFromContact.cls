public class HelloSignReqFromContact {
    public static void sendDriverPacket(String email){
        System.debug('Email from Contact : '+ email);
        Set<String> newUserEmailSet = new Set<String>();
        newUserEmailSet.add(email);
        if(newUserEmailSet.size()>0){
			HelloSignIntegrationHandler.sendSignatureRequestForDriver(newUserEmailSet);
        }
    }
}