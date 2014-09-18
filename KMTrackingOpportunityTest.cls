@isTest
public class KMTrackingOpportunityTest {
  @isTest static void loseOneOpportunity(){
    Opportunity o = new Opportunity(
      Name = 'Test Opportunity',
      StageName = '1-Discovery',
      CloseDate = Date.today(),
      Amount = 9000.00
    );
    insert o;

    o.StageName = '7-Closed Lost';
    o.Lost_Reason__c = 'Price/Value';
    update o;

    Opportunity closed_o = [SELECT Id, IsClosed, IsWon FROM Opportunity WHERE Id=:o.id][0];
    System.assertEquals(closed_o.IsClosed, true);
    System.assertEquals(closed_o.IsWon, false);
  }
}