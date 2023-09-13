global class SchedulesendMileageReminderforDelta implements Schedulable

{

     global void execute(SchedulableContext sc)

     {

     SendMileageReminderforDelta milReminder = new SendMileageReminderforDelta();

       database.executeBatch(milReminder);

     }

}