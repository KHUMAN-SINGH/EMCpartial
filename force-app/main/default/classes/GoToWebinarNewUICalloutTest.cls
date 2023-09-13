@isTest
public class GoToWebinarNewUICalloutTest {
    @isTest
    Public static void GoToWebMethod(){
        Test.setMock(HttpCalloutMock.class, new GoToWebinarMockCallout());
        
       /* GoToWebinar__mdt gw = new GoToWebinar__mdt();
        gw.MasterLabel = 'G2W oAuth';
        gw.Access_Token__c = 'eyJraWQiOiI2MjAiLCJhbGciOiJSUzUxMiJ9.eyJzYyI6ImNhbGwtY29udHJvbC52MS5jYWxscy5jb250cm9sIGNhbGxzLnYyLmluaXRpYXRlIG1lc3NhZ2luZy52MS53cml0ZSByZWFsdGltZS52Mi5ub3RpZmljYXRpb25zLm1hbmFnZSBmYXgudjEucmVhZCBtZXNzYWdpbmcudjEubm90aWZpY2F0aW9ucy5tYW5hZ2UgbWVzc2FnaW5nLnYxLnNlbmQgZmF4LnYxLndyaXRlIGlkZW50aXR5OiBtZXNzYWdpbmcudjEucmVhZCB3ZWJydGMudjEucmVhZCB3ZWJydGMudjEud3JpdGUgY29sbGFiOiBjci52MS5yZWFkIGZheC52MS5ub3RpZmljYXRpb25zLm1hbmFnZSB1c2Vycy52MS5saW5lcy5yZWFkIiwic3ViIjoiMTE1MDY2NDU4OTIxMzI1MTU5MCIsImF1ZCI6IjY4OGRiZGM0LTdiOTQtNDFkZS04NDM1LTljOTczNmQ3NGNmOCIsIm9nbiI6InB3ZCIsImxzIjoiMTc5ZjhkN2QtMjJkMS00ZGNjLWEyNGItZWExNTdkZDFkZDU2IiwidHlwIjoiYSIsImV4cCI6MTY4NjcyMTQ4MiwiaWF0IjoxNjg2NzE3ODgyLCJqdGkiOiIxZTIyZjUwNC1mNGZiLTRiZjktODZhMS1iOGQ5NDExOGRmOWYifQ.RFWTcyDnweUf9Pdu1vgstuyDoArOsaDh7nZFZ3489-ZezFEHuC9A19kF0QSSL37c8JRaaV8fNyEd5-BH4PuwoksOUqajsAG-myWlaYes4ykcjy17oKP90HT_gIWY_7YOmG43sOrAhgM0slgBHwGmupXTxvub-5J6RnSeTtXP80IFUL1VaRPcE2EuQwiORUyaAtDkZEp2GOhx7BfJdFX6ogKSFhYrszM91YfVCxUhkW52uKD98KugZKWEfFJm8aujt2rk3kNyOFfEKO-JKXeDQosuuyY7sw_IAFmTV427w2Rx7P6MdTg9rVrX3de4_aQAnWQvlnYXzJeAzriMeNXpFw';
        gw.Organizer_Key__c = '1150664589213251590';
        gw.DeveloperName = 'G2W_oAuth';
        gw.Refresh_Token__c = 'eyJraWQiOiI2MjAiLCJhbGciOiJSUzUxMiJ9.eyJzYyI6ImNhbGwtY29udHJvbC52MS5jYWxscy5jb250cm9sIGNhbGxzLnYyLmluaXRpYXRlIG1lc3NhZ2luZy52MS53cml0ZSByZWFsdGltZS52Mi5ub3RpZmljYXRpb25zLm1hbmFnZSBmYXgudjEucmVhZCBtZXNzYWdpbmcudjEubm90aWZpY2F0aW9ucy5tYW5hZ2UgbWVzc2FnaW5nLnYxLnNlbmQgZmF4LnYxLndyaXRlIGlkZW50aXR5OiBtZXNzYWdpbmcudjEucmVhZCB3ZWJydGMudjEucmVhZCB3ZWJydGMudjEud3JpdGUgY29sbGFiOiBjci52MS5yZWFkIGZheC52MS5ub3RpZmljYXRpb25zLm1hbmFnZSB1c2Vycy52MS5saW5lcy5yZWFkIiwic3ViIjoiMTE1MDY2NDU4OTIxMzI1MTU5MCIsImF1ZCI6IjY4OGRiZGM0LTdiOTQtNDFkZS04NDM1LTljOTczNmQ3NGNmOCIsIm9nbiI6InB3ZCIsInR5cCI6InIiLCJleHAiOjE2ODkzMDk4ODIsImlhdCI6MTY4NjcxNzg4MiwianRpIjoiM2UyODcyYjktMGMyZS00NWZkLWI4OTAtNmExODA2ZjZhYmFjIn0.qesYWAUHt8IPB1wx0Lo8mIwK6iQE1ZiI3iJ2ctjZl2Suyndca5JzQ1_-qD3DTHi_7R3jNKVfGyDI-BYQX0Voj3FdsbOipnGe8wZrigWEvZHBqUUcpwzDLp13KDVspjsjvr7-QPBLiD8nMHcb6C4My63xjyxcqEqJKLWUldcwC3WyDDCSwvwmXbEu1298kmQh29qwQpxqPfSCfmeJAI8udEL00CW9RLfu8ddIx93AH73UHOLbvHpAT28SGnqAC3EQvUb5icnM88r9-5MCjjqmpqU9pbxiBbgJRETmdLV3HHezGsGB0iA73VuK0O5KllIiyCSwRlJpUgQZuCDwDpCfqQ';
        gw.Client_Id__c = '688dbdc4-7b94-41de-8435-9c9736d74cf8';
        gw.Client_Secret__c = 'uyqIROUJ05lItPluJNbdG8AH';
        gw.Authentication_Endpoint__c = 'https://authentication.logmeininc.com/oauth/';
        gw.Endpoint__c = 'https://api.getgo.com/G2W/rest/v2/';
        gw.Redirect_URL__c = 'https://mburse--partialdev.my.salesforce.com/apex/GoToWebinarAuthorization';
        gw.Site_URL__c = 'https://mburse--partialdev.sandbox.my.salesforce-sites.com/GoToWebinar/services/apexrest/gotowebinar/webhook';
        
        insert gw;
       */ 
        Test.startTest();
       // GoToWebinarController.executeCallout('POST','registrants',String requestBody,String webinarKey);
        Test.stopTest();
    }
}