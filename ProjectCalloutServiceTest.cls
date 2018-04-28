@isTest
private class ProjectCalloutServiceTest {

    @TestSetup
    static void testSetupData() {
    	Account acc = new Account(Name = 'Test Account');
        insert acc;
        acc = [Select Id from Account where Name = 'Test Account'];
        List<Opportunity> opps = new List<Opportunity>();
        Opportunity opp1 = new Opportunity(Name = 'Opp1',
                                           Type = 'New Project',
                                           CloseDate = Date.today(),
                                           StageName = 'Prospecting',
                                           Amount = 10000);
        opps.add(opp1);
        Opportunity opp2 = new Opportunity(Name = 'Opp2',
                                           Type = 'New Project',
                                           CloseDate = Date.today(),
										   StageName = 'Prospecting',
                                           Amount = 10000);
        opps.add(opp2);
        insert opps;
        ServiceTokens__c servToken = new ServiceTokens__c();
        servToken.Name = 'ProjectServiceToken';
        servToken.Token__c = 'hueuuweouieoeefoeoffeo';
        insert servToken;
}
  	@isTest 
    static void testPostCalloutsuccess() {
        //ProjectCalloutServiceTest.testSetupData();
        Opportunity opp = [Select Id, Name from Opportunity where Name = 'Opp1' Limit 1];
        List<Id> oppid = new List<Id>();
        oppid.add(opp.Id);
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new ProjectCalloutServiceMock()); 
        ProjectCalloutService.postOpportunityToPMS(oppid);
        Test.stopTest();
        opp = [Select Id, StageName from Opportunity where Id =: opp.Id];
        System.assertEquals('Submitted Project', opp.StageName);
}
    
  	@isTest
    static void testPostCalloutfailure() {
        //ProjectCalloutServiceTest.testSetupData();
        Opportunity opp = [Select Id, Name from Opportunity where Name = 'Opp2' Limit 1];
        List<Id> oppid = new List<Id>();
        oppid.add(opp.Id);
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new ProjectCalloutServiceMockFailure()); 
        ProjectCalloutService.postOpportunityToPMS(oppid);
        Test.stopTest();
        opp = [Select Id, StageName from Opportunity where Id =: opp.Id];
        System.assertEquals('Resubmit Project', opp.StageName);
}
}