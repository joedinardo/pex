@isTest
public class KMTrackingLeadTest {
  @isTest static void createOneLead(){
    Lead lead = TestFactory.createLead();
    System.assertEquals(lead.IsDeleted, false);
  }

  @isTest static void convertOneLead(){
    Lead lead = TestFactory.createLead();

    List<Lead> leadsToConvert = new List<Lead>();
    leadsToConvert.add(lead);

    Database.LeadConvert lc = new Database.LeadConvert();
    lc.setLeadId(lead.id);

    LeadStatus convertStatus = [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted=true LIMIT 1];
    lc.setConvertedStatus(convertStatus.MasterLabel);
    Database.LeadConvertResult lcr = Database.convertLead(lc);
    System.assert(lcr.isSuccess());
  }
}