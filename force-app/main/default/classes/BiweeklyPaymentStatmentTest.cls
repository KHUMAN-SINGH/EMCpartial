@isTest
public with sharing class BiweeklyPaymentStatmentTest {
    static testmethod void testPaymentSchedule(){
        Test.startTest();
        ScheduleBiweeklyPaymentStatment obj =new ScheduleBiweeklyPaymentStatment();
        obj.execute(null);
        Test.stopTest();
    }
}