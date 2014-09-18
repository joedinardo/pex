trigger KMTrackLeadCreation on Lead (after insert) {
  List<String> lead_ids = new List<String>();
  for(Lead lead : Trigger.new) {
    lead_ids.add(lead.Id);
  }

  KMTracking.trackLeadsCreated(lead_ids);
}