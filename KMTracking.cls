public class KMTracking {
  @future(callout=true)
  public static void sendRequest(String json_payload, String event_name) {
    // This is the URL of your forwarding server
    String trackingEndpoint = 'http://requestb.in/abcdef';
    
    // This is a randomly-generated string to authenticate Salesforce to your forwarding server
    String webhookSecret = 'foobarbaz';
    
    // Make a single request to your forwarding server. The request body contains the SObjects to track.
    HttpRequest req = new HttpRequest();
    req.setMethod('POST');
    req.setBody(json_payload);
    req.setHeader('X-KM-Event-Name', event_name);
    req.setEndpoint(trackingEndpoint);
    req.setHeader('Authorization', 'Basic ' + webhookSecret);

    Http h = new Http();
    if (!Test.isRunningTest()) {
      h.send(req);
    }
  }

  public static void trackLeadsCreated(List<String> leads) {
    // When tracking leads being created, get the Lead Id, Email, and CreatedDate fields
    List<Lead> leadsToTrack = [SELECT Id, Email, CreatedDate FROM Lead WHERE Id in :leads];
    if (leadsToTrack.size() > 0) {
      sendRequest(JSON.serialize(leadsToTrack), 'Salesforce Lead Created');
    }
  }

  public static void trackLeadsConverted(List<String> leads) {
    // When tracking leads being converted, get the Lead Id, Email, and ConvertedDate fields
    List<Lead> leadsToTrack = [SELECT Id, Email, ConvertedDate FROM Lead WHERE Id in :leads];
    if (leadsToTrack.size() > 0) {
      sendRequest(JSON.serialize(leadsToTrack), 'Salesforce Lead Converted');
    }
  }

  public static void trackOpportunitiesWon(List<String> opptys) {
    // When tracking won opportunities, get the Opportunity Id, Amount, and Email__c fields
    // REALIZE THAT EMAIL__C IS A CUSTOM OPPORTUNITY FIELD
    List<Opportunity> opptysToTrack = [SELECT Id, Amount, Email__c FROM Opportunity WHERE Id in :opptys];
    if (opptysToTrack.size() > 0) {
      sendRequest(JSON.serialize(opptysToTrack), 'Salesforce Opportunity Closed (Won)');
    }
  }

  public static void trackOpportunitiesLost(List<String> opptys) {
    // When tracking lost opportunities, get the Opportunity Id, Amount, and Email__c fields
    // REALIZE THAT EMAIL__C IS A CUSTOM OPPORTUNITY FIELD
    List<Opportunity> opptysToTrack = [SELECT Id, Amount, Email__c FROM Opportunity WHERE Id in :opptys];
    if (opptysToTrack.size() > 0) {
      sendRequest(JSON.serialize(opptysToTrack), 'Salesforce Opportunity Closed (Lost)');
    }
  }
}