global class ProjectCalloutService {
    //Complete the implementation for business and callout logic
	@InvocableMethod
    public static void postOpportunityToPMS(List<Id> oppids){        
        ID jobId = System.enqueueJob(new QueueablePMSCall(oppids[0]));
        System.debug('Queue ID: '+ jobId);
    }
    public class QueueablePMSCall implements Queueable,Database.AllowsCallouts{
        private String Id;
        public QueueablePMSCall(Id oppId){
            this.Id = oppId;
        }
    	public void execute(QueueableContext context) {
            Opportunity opp = [Select Id, Name, Account.Name, CloseDate, Amount from Opportunity where Id=:Id];
            String servicetoken = ServiceTokens__c.getValues('ProjectServiceToken').token__c;        
            Http http = new Http();
            HttpRequest request = new HttpRequest();
            request.setEndpoint('callout:ProjectService');
            request.setMethod('POST');
            request.setHeader('token', servicetoken);
            request.setHeader('Content-Type', 'application/json;charset=UTF-8');
            request.setBody('{"opportunityId": "'+opp.Id+'","opportunityName": "'+opp.Name+'","accountName": "'+opp.Account.Name+'","closeDate": "'+String.valueOf(opp.CloseDate).mid(0,10)+'","amount": '+opp.Amount+'}');
            HttpResponse response = http.send(request);
            // Parse the JSON response
            if (response.getStatusCode() != 201) {
                	System.debug('The status code returned was not expected: ' +
                    response.getStatusCode() + ' ' + response.getStatus());
					opp.StageName = 'Resubmit Project';
            } else {
                	System.debug(response.getBody());
                	opp.StageName = 'Submitted Project';
            }
            update opp;
    }
}
}