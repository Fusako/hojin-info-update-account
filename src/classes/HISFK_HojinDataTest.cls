@isTest
private class HISFK_HojinDataTest {
     @isTest static void testCallout() {
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new HIFK_HojinInfoCalloutMockImpl());
        
        String sparql = '';
        HttpResponse res = HISFK_HojinData.getInfoFromHojinInfoAPI(sparql);
        
        // Verify response received contains fake values
        String contentType = res.getHeader('Content-Type');
        System.assert(contentType == 'application/json');
        String actualValue = res.getBody();
        String expectedValue = '{ "head": { "link": [], "vars": ["corporateID", "corporateName", "corporateKana", "location", "moddate", "systemName", "classSInfo"] },  "results": { "distinct": false, "ordered": true, "bindings": [    { "corporateID": { "type": "literal", "value": "4010401076766" }	, "corporateName": { "type": "literal", "value": "\u682A\u5F0F\u4F1A\u793E\u30BB\u30FC\u30EB\u30B9\u30D5\u30A9\u30FC\u30B9\u30FB\u30C9\u30C3\u30C8\u30B3\u30E0" }	, "location": { "type": "literal", "value": "\u6771\u4EAC\u90FD\u5343\u4EE3\u7530\u533A\u4E38\u306E\u5185\uFF12\u4E01\u76EE\uFF17\u756A\uFF12\u53F7" }	, "moddate": { "type": "typed-literal", "datatype": "http://www.w3.org/2001/XMLSchema#dateTime", "value": "2015-10-26T00:00:00+09:00" }	, "systemName": { "type": "literal", "value": "\u6CD5\u4EBA\u60C5\u5831\u30B7\u30B9\u30C6\u30E0" }	, "classSInfo": { "type": "literal", "value": "01" }} ] } }';
        System.assertEquals(actualValue, expectedValue);
        System.assertEquals(200, res.getStatusCode());
    }
    
    @isTest static void test1(){
        String hojinId = '4010401076766';
        String name = 'test';
        String zip = '100-0000';
        String state = '東京都';
        String city = '千代田区';
        String street = '丸の内';
        String startDate = '2017/03/01';
        String endDate = '2017/05/01';
        String modStartDate = '2017/03/01';
        String modEndDate = '2017/05/01';
        Account acct = new Account(Name = 'Test', HojinId__c = hojinId);
        Insert acct;
        HISFK_HojinData.updateAccountRecord( hojinId,  name,  zip,  state,  city,  street);
        HISFK_HojinData.insertAccountRecord( hojinId,  name,  zip,  state,  city,  street);
        HISFK_HojinData.getAllData( startDate,  endDate,  modStartDate,  modEndDate);
    }
}