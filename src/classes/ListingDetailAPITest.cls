@isTest
private class ListingDetailAPITest {
	
    private static List<Properties__c> lProperties;
    private static Account acc;
    private static Contact con;
    private static User usr;
    private static AMI__c ami;
    static  ID listingID, listing1ID ;
    static List<Id> listListingId;
    static String preferenceName ;
    
    static void setupTestData() {
        Id rtId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Household').getRecordTypeId();
        acc = new Account();
        acc.Name = 'Test Account';
        acc.RecordTypeId = rtId;
        acc.AccountNumber = '12345';
        insert acc;
        
        Development__c dev = new Development__c();
        dev.Name_of_Development__c = 'amli';
        insert dev;
      
        Building__c build = new Building__c();
        build.Development__c = dev.Id;
        build.Developer__c = acc.Id;
       	insert build;
        
        Listing__c listing = new Listing__c();
        listing.name='somelisting';
        listing.Building__c  = build.id;
        listing.Account__c = acc.Id;
        listing.Status__c = 'Active';
        listing.Does_Match__c = true;
        insert listing;
        
        Listing__c listing1 = new Listing__c();
        listing1.name='somelisting';
        listing1.Building__c  = build.id;
        listing1.Account__c = acc.Id;
        listing1.Status__c = 'Active';
        listing1.Does_Match__c = true;
        insert listing1;
        
        listingID = listing.id;
        listing1ID = listing1.id;
        listListingId = new List<Id>();
        listListingId.add(listingID);
        
        Unit__c unit = new Unit__c();
        unit.property__c  = build.id;
        unit.BMR_Rent_Monthly__c = 400;
        unit.Rent_Multiple__c=3;
        unit.of_AMI_for_Pricing_Unit__c=55;
        unit.Listing__c = listing.id;
        unit.Maximum_Household_Size__c  = 8;
        unit.Number_of_Bedrooms__c = 3;
        insert unit;
        
        Unit__c unit1 = new Unit__c();
        unit1.property__c  = build.id;
        unit1.BMR_Rent_Monthly__c = 400;
        unit1.Rent_Multiple__c=3;
        unit1.of_AMI_for_Pricing_Unit__c=55;
        unit1.Listing__c = listing1.id;
        unit1.Maximum_Household_Size__c  = 8;
        unit1.Number_of_Bedrooms__c = 3;
        insert unit1;
        
        Lottery_Preference__c lp = new Lottery_Preference__c();
        lp.Name = 'Test Lottery Preference';
        lp.Status__c = 'New';
        insert lp;
       	preferenceName = lp.Name;
        
        Listing_Lottery_Preference__c llp = new Listing_Lottery_Preference__c();
        llp.Listing__c = listing.Id;
        llp.Lottery_Preference__c = lp.Id;
        insert llp;
        
        ami = new AMI__c();
        ami.name='Test Lottery Preference';
        ami.amount__c = 40000;
        ami.Num_of_HouseHold__c=2;
        ami.Percent_of_Median__c=100;
        insert ami;
        
    }
        
    static testMethod void doGetById() {
        setupTestData();
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        
        req.requestURI = '/listings/'+listingID;  
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = res;
        //this should return  record with the specific id
        system.assert(ListingDetailAPI.doGet().size() == 1);
        //ListingDetailAPI.doGet();
    }
    static testMethod void doGetByIdParam() {
        setupTestData();
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = '/listings';  
        req.addParameter('id', listingID);
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = res;
        //this should return  record with the specific id
        system.assert(ListingDetailAPI.doGet().size() == 1);
        

        
    }
     static testMethod void doGetByIds() {
         setupTestData();
         RestRequest req = new RestRequest(); 
         RestResponse res = new RestResponse();
         req.requestURI = '/listings';  
         req.addParameter('ids', listingID + ',' + listing1ID);
         req.httpMethod = 'GET';
         RestContext.request = req;
         RestContext.response = res;
		 //this should return  record with the specific ids 
         system.assert(ListingDetailAPI.doGet().size() == 2);
         
     }
    
     static testMethod void doGetByCriteria() {
         setupTestData();
         RestRequest req = new RestRequest(); 
         RestResponse res = new RestResponse();
         req.requestURI = '/listings';  
         //req.addParameter('ids', listingID);
         req.addParameter('incomelevel', '20');
         req.addParameter('householdsize', '4');
         req.addParameter('childrenUnder6', '2');
         req.addParameter('preferenceName', 'Test Lottery Preference');
         req.httpMethod = 'GET';
         RestContext.request = req;
         RestContext.response = res;
         //this should return all record that met this criteria
         system.assert(ListingDetailAPI.doGet().size() == 2);
         
     }
}