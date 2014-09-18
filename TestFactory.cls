@isTest
public class TestFactory {
  public static Lead createLead() {
    Lead lead = new Lead(
      LastName = 'Testman',
      Company = 'Testco',
      Email = 'tester@test.co',
      Business_Type__c = 'Unknown At This Time',
      Status = 'New'
    );
    insert lead;
    return lead;
  }

  public static Opportunity createOpportunity(Account account) {
    Opportunity oppty = new Opportunity(
      Name = 'Test Opportunity',
      AccountId = account.id,
      StageName = '1-Discovery',
      CloseDate = Date.today().addDays(30),
      Type = 'New Bus',
      Amount = 1200
    );
    insert oppty;
    return oppty;
  }
}