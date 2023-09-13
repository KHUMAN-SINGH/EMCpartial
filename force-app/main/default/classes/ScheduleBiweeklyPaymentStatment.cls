global class ScheduleBiweeklyPaymentStatment implements Schedulable {
         global void execute(SchedulableContext SC) {
			yearToDateBiWeeklyReimbursmentStatment ytdBatchObj=new yearToDateBiWeeklyReimbursmentStatment();
       		 database.executebatch(ytdBatchObj);
    	}
        public static  void scheduleThis()
        {
                List<String> PaydateList;
                String PaydateListLabel =Label.BiweeklyReimbursmentPaymentDate;
                if(PaydateListLabel!=null)
                {
                    PaydateList=PaydateListLabel.split(',');
                }
                for(integer i=0;i<PaydateList.size();i++){
                Date currentDate =(Date.parse(PaydateList[i]));
                String CRON_EXP = '0 0 0'+currentDate.day()+' '+currentDate.month()+' ? '+currentDate.year();  
                               
                system.schedule('Send Biweekly Payment Statment Email', CRON_EXP, new ScheduleBiweeklyPaymentStatment());
            }
        }
    }