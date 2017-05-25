public class HISFK_HojinData {
    @AuraEnabled public String hojinList{get;set;}
    @AuraEnabled public List<String> hojinIds{get;set;}
    
    @AuraEnabled
    public static String updateAccountRecord(String hojinId, String name, String zip, String state, String city, String street){
        Account a = [Select Id, name, BillingPostalCode, BillingState, BillingCity, BillingStreet From Account Where hojinId__c = :hojinId Limit 1];
        a.name = name;
        a.BillingPostalCode = zip;
        a.BillingState = state;
        a.BillingCity = city;
        a.BillingStreet = street;
        Update a;
        System.debug('a.Id: '+a.Id);
        return a.Id;
    }
    
    @AuraEnabled
    public static String insertAccountRecord(String hojinId, String name, String zip, String state, String city, String street){
    	Account a = new Account();
        a.name = name;
        a.hojinId__c = hojinId;
        a.BillingPostalCode = zip;
        a.BillingState = state;
        a.BillingCity = city;
        a.BillingStreet = street;
        Insert a;
        return a.Id;
    }
    
    @AuraEnabled
    public static HISFK_HojinData getAllData(String startDate, String endDate, String modStartDate, String modEndDate) {
        
        List<String> hojinIdArray = new List<String>();
        Account[] accts = [SELECT id, name, hojinId__c FROM Account Where hojinId__c != null Limit 20000];
        for(Account a : accts){
            hojinIdArray.add(a.hojinId__c);
        }
        
        String sparql = '';
        sparql += 'PREFIX  hj: <http://hojin-info.go.jp/ns/domain/biz/1#>\r\n';
        sparql += 'PREFIX  ic: <http://imi.go.jp/ns/core/rdf#>\r\n';
        sparql += ' SELECT DISTINCT ?corporateID ?corporateName ?zip ?prefecture ?city ?street ?location ?moddate ?establishDate ?classSType (COUNT(DISTINCT(?o)) AS ?count)\r\n';
        sparql += ' FROM <http://hojin-info.go.jp/graph/hojin>\r\n';
        sparql += ' FROM <http://hojin-info.go.jp/graph/chotatsu>\r\n';
        sparql += ' FROM <http://hojin-info.go.jp/graph/hyosho>\r\n';
        sparql += ' FROM <http://hojin-info.go.jp/graph/todokede>\r\n';
        sparql += ' FROM <http://hojin-info.go.jp/graph/hojyokin>\r\n';
        sparql += ' {\r\n';
        sparql += ' ?s hj:法人活動情報 ?o2. \r\n';
        sparql += ' ?o2 ic:設立日/ic:標準型日付 ?establishDate.\r\n';
        if(startDate!=null && startDate != '' && endDate!=null && endDate != ''){
            sparql += ' FILTER (?establishDate >= "'+startDate+'"^^xsd:date && ?establishDate <= "'+endDate+'"^^xsd:date) \r\n';
        }
        if(startDate!=null && modStartDate != '' && modEndDate!=null && modEndDate != ''){
            sparql += ' FILTER (?moddate >= "'+modStartDate+'"^^xsd:date && ?moddate <= "'+modEndDate+'"^^xsd:date) \r\n';
        }
        sparql += ' ?o2 hj:資格/ic:表記 ?qualificationGrade. \r\n';
        sparql += ' ?s hj:法人基本情報 ?key2. \r\n';
        sparql += ' ?key2 ic:ID/ic:識別値 ?corporateID.\r\n';
        sparql += ' ?key2 ic:住所/ic:表記 ?location. \r\n';
        sparql += ' ?key2 ic:名称/ic:表記 ?corporateName. \r\n';
        sparql += ' ?key2 ic:住所/ic:郵便番号 ?zip. \r\n';
        sparql += ' ?key2 ic:住所/ic:都道府県 ?prefecture. \r\n';
        sparql += ' ?key2 ic:住所/ic:市区町村 ?city. \r\n';
        sparql += ' ?key2 ic:住所/hj:丁目番地等 ?street. \r\n';
        sparql += ' ?key2 hj:区分 _:keyName. \r\n';
        sparql += ' OPTIONAL{?key2 hj:更新日時/ic:標準型日時 ?moddate .} \r\n';
        sparql += ' _:keyName ic:種別 \'処理区分\'. \r\n';
        sparql += ' _:keyName ic:表記 ?classSType.  \r\n';
        sparql += ' OPTIONAL{ ?s hj:法人活動情報 ?o.} \r\n';
        sparql += ' } GROUP BY ?corporateID ?corporateName ?zip ?prefecture ?city ?street ?location ?moddate ?establishDate ?classSType \r\n';
        sparql += ' ORDER BY ?establishDate ?moddate LIMIT 1000\r\n';
        System.debug('sparql: '+sparql);
        sparql = EncodingUtil.urlEncode(sparql,'UTF-8');

        System.debug('sparql: '+sparql);
        String resBody;
        if (!Test.isRunningTest()){
            resBody = getInfoFromHojinInfoAPI(sparql).getBody();
            System.debug('resBody: '+resBody);
        }
        
        HISFK_HojinData obj = new HISFK_HojinData();
        obj.hojinList = resBody;
        obj.hojinIds = hojinIdArray;
        return obj;   
    }
    
    public static HttpResponse getInfoFromHojinInfoAPI(String sparql){
        String strReq = '';
        strReq += 'http://api.hojin-info.go.jp/sparql?query='+sparql+'&format=json';
        
        HttpRequest req = new HttpRequest();
        req.setTimeout(120000);
        req.setEndpoint(strReq);
        req.setMethod('GET');
      
        Http http = new Http();
        HTTPResponse res = http.send(req);
        
        return res;
    }
}