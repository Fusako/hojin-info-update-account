global class HIFK_HojinInfoCalloutMockImpl implements HttpCalloutMock{
    global HTTPResponse respond(HTTPRequest req) {
        HttpResponse res = new HttpResponse();
        String resBody = '{ "head": { "link": [], "vars": ["corporateID", "corporateName", "corporateKana", "location", "moddate", "systemName", "classSInfo"] },  "results": { "distinct": false, "ordered": true, "bindings": [    { "corporateID": { "type": "literal", "value": "4010401076766" }	, "corporateName": { "type": "literal", "value": "\u682A\u5F0F\u4F1A\u793E\u30BB\u30FC\u30EB\u30B9\u30D5\u30A9\u30FC\u30B9\u30FB\u30C9\u30C3\u30C8\u30B3\u30E0" }	, "location": { "type": "literal", "value": "\u6771\u4EAC\u90FD\u5343\u4EE3\u7530\u533A\u4E38\u306E\u5185\uFF12\u4E01\u76EE\uFF17\u756A\uFF12\u53F7" }	, "moddate": { "type": "typed-literal", "datatype": "http://www.w3.org/2001/XMLSchema#dateTime", "value": "2015-10-26T00:00:00+09:00" }	, "systemName": { "type": "literal", "value": "\u6CD5\u4EBA\u60C5\u5831\u30B7\u30B9\u30C6\u30E0" }	, "classSInfo": { "type": "literal", "value": "01" }} ] } }';
        res.setHeader('Content-Type', 'application/json');
        res.setBody(resBody);
        res.setStatusCode(200);
        return res;
        
    }
    global HTTPResponse respondList(HTTPRequest req) {
        
        HttpResponse res = new HttpResponse();
        String resBody = '{ "head": { "link": [], "vars": ["corporateID", "corporateName", "prefecture", "city", "location", "classSType", "count"] },  "results": { "distinct": false, "ordered": true, "bindings": [    { "corporateID": { "type": "literal", "value": "3010001124430" }	, "corporateName": { "type": "literal", "value": "\u682A\u5F0F\u4F1A\u793E\u30BB\u30FC\u30EB\u30B9\u30D5\u30A9\u30FC\u30B9" }	, "prefecture": { "type": "literal", "value": "\u6771\u4EAC\u90FD" }	, "city": { "type": "literal", "value": "\u5343\u4EE3\u7530\u533A" }	, "location": { "type": "literal", "value": "\u6771\u4EAC\u90FD\u5343\u4EE3\u7530\u533A\u795E\u7530\u7F8E\u5009\u753A\uFF19\u756A\u5730" }	, "classSType": { "type": "literal", "value": "01" }	, "count": { "type": "typed-literal", "datatype": "http://www.w3.org/2001/XMLSchema#integer", "value": "0" }},    { "corporateID": { "type": "literal", "value": "4010401076766" }	, "corporateName": { "type": "literal", "value": "\u682A\u5F0F\u4F1A\u793E\u30BB\u30FC\u30EB\u30B9\u30D5\u30A9\u30FC\u30B9\u30FB\u30C9\u30C3\u30C8\u30B3\u30E0" }	, "prefecture": { "type": "literal", "value": "\u6771\u4EAC\u90FD" }	, "city": { "type": "literal", "value": "\u5343\u4EE3\u7530\u533A" }	, "location": { "type": "literal", "value": "\u6771\u4EAC\u90FD\u5343\u4EE3\u7530\u533A\u4E38\u306E\u5185\uFF12\u4E01\u76EE\uFF17\u756A\uFF12\u53F7" }	, "classSType": { "type": "literal", "value": "01" }	, "count": { "type": "typed-literal", "datatype": "http://www.w3.org/2001/XMLSchema#integer", "value": "1" }},    { "corporateID": { "type": "literal", "value": "5010901021980" }	, "corporateName": { "type": "literal", "value": "\u682A\u5F0F\u4F1A\u793E\u30AF\u30EA\u30A8\u30A4\u30C6\u30A3\u30D6\u30BB\u30FC\u30EB\u30B9\u30D5\u30A9\u30FC\u30B9" }	, "prefecture": { "type": "literal", "value": "\u9577\u5D0E\u770C" }	, "city": { "type": "literal", "value": "\u9577\u5D0E\u5E02" }	, "location": { "type": "literal", "value": "\u9577\u5D0E\u770C\u9577\u5D0E\u5E02\u4E07\u5C4B\u753A\uFF12\u756A\uFF12\uFF13\uFF0D\uFF11\uFF10\uFF10\uFF11\u53F7" }	, "classSType": { "type": "literal", "value": "01" }	, "count": { "type": "typed-literal", "datatype": "http://www.w3.org/2001/XMLSchema#integer", "value": "0" }} ] } }';   
        res.setHeader('Content-Type', 'application/json');
        res.setBody(resBody);
        res.setStatusCode(200);
        return res;
        
    }
}