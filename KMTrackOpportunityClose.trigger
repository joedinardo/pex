trigger KMTrackOpportunityClose on Opportunity (after update) {
  List<String> won_ids = new List<String>();
  List<String> lost_ids = new List<String>();
  for(Opportunity o : Trigger.new) {
    if(o.IsClosed && !trigger.oldMap.get(o.Id).IsClosed) {
      if(o.IsWon) {
        won_ids.add(o.Id);
      } else {
        lost_ids.add(o.Id);      
      }
    }
  }

  KMTracking.trackOpportunitiesWon(won_ids);
  KMTracking.trackOpportunitiesLost(lost_ids);
}