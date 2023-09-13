global class DemoDriverDashboardController {
    @AuraEnabled
    // public static Employee_Mileage__c[] getMileages(string searchKey,String clickedMonth,String year,String contactId) {
    public static List<String> getMileages(String searchKey,String clickedMonth,String year,String contactId) {
        // return [FIND :searchKey IN ALL FIELDS RETURNING Employee_Mileage__c(Id,Trip_Date__c,Origin_Name__c,Destination_Name__c,Mileage__c)][0];
        // List<String> jj = getMileages('mumbai','May','2022','0030Z00003RBqVsQAL');
        // System.debug('Mileages>>>>>>'+jj);

        // List<String> po = WrapperUtils.getMileages1('May','2022','0030Z00003RBqVsQAL');
        // System.debug('getMileages>>>>>>'+po);
        // return WrapperUtils.getMileages1(clickedMonth,year,contactId);

        System.debug('aaa');
        List<String> po = DemoWrapperUtil.getMileages1('','May','2022','0030Z00003RBqVsQAL');
        System.debug('getMileages>>>>>>'+po);
        return DemoWrapperUtil.getMileages1(searchKey,clickedMonth,year,contactId);
    }
}
// @AuraEnabled
//     public static List<String> getMileages(String clickedMonth,String year,String contactId) {
//         List<String> po = WrapperUtils.getMileages1('May','2022','0030Z00003RBqVsQAL');
//             System.debug('getMileages>>>>>>'+po);
//         return WrapperUtils.getMileages1(clickedMonth,year,contactId);
//     }