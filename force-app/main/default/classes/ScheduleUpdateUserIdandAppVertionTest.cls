@isTest
public with sharing class ScheduleUpdateUserIdandAppVertionTest {
   public static testmethod void method1(){
        Test.startTest();
        ScheduleUpdateUserIdandAppVertionBatch schBt  = new ScheduleUpdateUserIdandAppVertionBatch();
        String sch = '0 0 0 18 * ?';
        system.schedule('Test schedule',sch,schBt );
        Test.stopTest();
   }
}