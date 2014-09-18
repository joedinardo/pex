trigger KMTrackLeadConversion on Lead (after update) {
  List<String> lead_ids = new List<String>();
  for(Lead lead : Trigger.new) {
    if(lead.IsConverted && !trigger.oldMap.get(lead.Id).IsConverted) {
      lead_ids.add(lead.Id);
    }
  }
  
  KMTracking.trackLeadsConverted(lead_ids);
}