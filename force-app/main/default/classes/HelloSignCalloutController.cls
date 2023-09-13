public with sharing class HelloSignCalloutController {
    
     /*public static HttpResponse SignatureRequestCallout(String driverName, String driverEmail, String adminName, String adminEmail, ID versionId) {
        Http h = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint(URL.getSalesforceBaseUrl().toExternalForm() + '/services/data/v42.0/sobjects/ContentVersion/'+versionId+'/VersionData');
        req.setMethod('GET');
        req.setHeader('Authorization', 'OAuth ' + UserInfo.getSessionId());
        req.setHeader('Content-Type', 'application/json');
        HttpResponse res = h.send(req);
        system.debug(res.getBody());
        blob formBlob = blob.valueof(res.getBody());
        Http http = new Http(); 
        HttpRequest request = new HttpRequest();
        Endpoints__c endPointProvider = Endpoints__c.getValues(Constants.apiOwnerName);
        Blob headerValue = Blob.valueOf(endPointProvider.UserName__c + ':' + endPointProvider.Password__c);
        String authorizationHeader = 'BASIC ' + EncodingUtil.base64Encode(headerValue);
        request.setHeader('Authorization', authorizationHeader);
        request.setEndpoint(Constants.signatureRequestSendWithTemplate);
        request.setMethod('POST');
        String strbody = 'test_mode='+endPointProvider.TestMode__c+'&signers[0][name]='+driverName+'&signers[0][email_address]='+driverEmail+'&signers[1][name]='+adminName+'&signers[1][email_address]='+adminEmail+'&signers[0][order]=0&signers[1][order]=1';//+'&use_text_tags='+1+'&file='+formBlob;
        System.debug('strbody-->'+strbody);
        request.setBody(strbody);
        HttpResponse response = http.send(request);
        system.debug('Response Status Code : '+response.getStatusCode());
        system.debug('Response Body : '+response.getBody());
        return response;
    }
    public static HttpResponse GetSignatureRequestCallout(String endpointUrl, String signRequestJobId, String endpointMethod){
        Http http = new Http(); 
        HttpRequest request = new HttpRequest();
        Endpoints__c endPointProvider = Endpoints__c.getValues(Constants.apiOwnerName);
        Blob headerValue = Blob.valueOf(endPointProvider.UserName__c + ':' + endPointProvider.Password__c);
        String authorizationHeader = 'BASIC ' + EncodingUtil.base64Encode(headerValue);
        request.setHeader('Authorization', authorizationHeader);
        request.setEndpoint(endpointUrl + signRequestJobId);
        request.setMethod(endpointMethod);
        HttpResponse response = http.send(request);
        system.debug('Response Status Code : '+response.getStatusCode());
        system.debug('Response Body : '+response.getBody());
        return response;
    }
    public static HttpResponse GetSignedDocumentCallout(String apiOwnerName, String endpointUrl, String signatureRequestId, String endpointMethod){
        Http http = new Http(); 
        HttpRequest request = new HttpRequest();
        Endpoints__c endPointProvider = Endpoints__c.getValues(apiOwnerName);
        Blob headerValue = Blob.valueOf(endPointProvider.UserName__c + ':' + endPointProvider.Password__c);
        String authorizationHeader = 'BASIC ' + EncodingUtil.base64Encode(headerValue);
        request.setHeader('Authorization', authorizationHeader);
        request.setEndpoint(endpointUrl + signatureRequestId);
        request.setMethod(endpointMethod);
        HttpResponse response = http.send(request);
        system.debug('Response Status Code : '+response.getStatusCode());
        system.debug('Response Body : '+response.getBody());
        return response;
    }*/
}