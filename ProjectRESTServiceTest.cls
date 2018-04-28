@isTest
private class ProjectRESTServiceTest {
  //Implement Apex REST service tests here
  @TestSetup
    static void testsetup(){
        Opportunity opp = new Opportunity(Name = 'test',
                                          CloseDate = date.valueOf('2018-04-20'),
                                          StageName = 'Prospecting');
        insert opp;
    }
  @isTest
    static void testpostProjectDataSuccess(){
        Opportunity opp = [Select Id, DeliveryInstallationStatus__c from Opportunity where Name = 'test'];
        Test.startTest();
        String str = ProjectRESTService.postProjectData('Bigfoot Sighting', 'Test', opp.Id,
                                                       date.valueOf('2018-04-20'),date.valueOf('2018-04-26'),
                                                       10000, 'Running');
        Test.stopTest();
        opp = [Select Id, DeliveryInstallationStatus__c from Opportunity where Name = 'test'];
        System.assertEquals('In progress', opp.DeliveryInstallationStatus__c);
        System.assertEquals('OK', str);
    }
    @isTest
    static void testpostProjectDataFailure(){
        Opportunity opp = [Select Id from Opportunity where Name = 'test'];
        Test.startTest();
        String str = ProjectRESTService.postProjectData('Bigfoot Sighting', 'Test', 'opp.Id',
                                                       date.valueOf('2018-04-20'),date.valueOf('2018-04-26'),
                                                       10000, 'Running');
        Test.stopTest();
        //System.assertEquals('In Progress', opp.DeliveryInstallationStatus__c);
        System.assertNotEquals('OK', str);
    }
}