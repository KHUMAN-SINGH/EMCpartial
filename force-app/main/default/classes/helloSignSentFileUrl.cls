public class helloSignSentFileUrl{

    private void uploadFile(String folderId,Attachment file,String token){
      String boundary = '----------------------------741e90d31eff';
      String header = '--'+boundary+'\nContent-Disposition: form-data; name="file"; filename="'+file.name+'";\nContent-Type: application/octet-stream';
      String footer = '--'+boundary+'--';             
      String headerEncoded = EncodingUtil.base64Encode(Blob.valueOf(header+'\r\n\r\n'));
      while(headerEncoded.endsWith('=')){
       header+=' ';
       headerEncoded = EncodingUtil.base64Encode(Blob.valueOf(header+'\r\n\r\n'));
      }
      String bodyEncoded = EncodingUtil.base64Encode(file.body);
    
      Blob bodyBlob = null;
      String last4Bytes = bodyEncoded.substring(bodyEncoded.length()-4,bodyEncoded.length());
     // GW: replacement section to get rid of padding without corrupting data
     if(last4Bytes.endsWith('==')) {
        last4Bytes = last4Bytes.substring(0,2) + '0K';
        bodyEncoded = bodyEncoded.substring(0,bodyEncoded.length()-4) + last4Bytes;
        String footerEncoded = EncodingUtil.base64Encode(Blob.valueOf(footer));
        bodyBlob = EncodingUtil.base64Decode(headerEncoded+bodyEncoded+footerEncoded);
      } else if(last4Bytes.endsWith('=')) {
        last4Bytes = last4Bytes.substring(0,3) + 'N';
        bodyEncoded = bodyEncoded.substring(0,bodyEncoded.length()-4) + last4Bytes;
        footer = '\n' + footer;
        String footerEncoded = EncodingUtil.base64Encode(Blob.valueOf(footer));
        bodyBlob = EncodingUtil.base64Decode(headerEncoded+bodyEncoded+footerEncoded);              
      } else {
        footer = '\r\n' + footer;
        String footerEncoded = EncodingUtil.base64Encode(Blob.valueOf(footer));
        bodyBlob = EncodingUtil.base64Decode(headerEncoded+bodyEncoded+footerEncoded);  
      }
    
      String sUrl = 'https://upload.box.com/api/2.0/files/content?parent_id='+folderId;
      HttpRequest req = new HttpRequest();
      req.setHeader('Content-Type','multipart/form-data; boundary='+boundary);
      req.setMethod('POST');
      req.setEndpoint(sUrl);
      req.setBodyAsBlob(bodyBlob);
      req.setTimeout(60000);
      req.setHeader('Authorization', 'Bearer '+token);
      req.setHeader('Content-Length',String.valueof(req.getBodyAsBlob().size()));
      Http http = new Http();
      HTTPResponse res = http.send(req);
    }
}