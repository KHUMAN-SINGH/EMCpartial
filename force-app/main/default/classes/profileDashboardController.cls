public with sharing class profileDashboardController {
    public profileDashboardController() { }
    @RemoteAction
    public static PageReference redirectOnPage(Boolean checkBiWeek,String checkRole,String accID,String conId,Boolean showTeam) {
        system.debug('****redirectOnPage****');
        PageReference pageRef = new PageReference('/app/admindashboard?accid='+accID+'&id='+conId+'&showteam='+String.valueOf(showTeam)+'&role=admin');
        system.debug('****pageRef****'+pageRef);
        return pageRef;
    }
}