public class HIFK_HojinInfo {

    @AuraEnabled 
    public static Account getAccountById(String acctId){
        return [Select id, name, hojinId__c, BillingPostalCode, BillingState, BillingCity, BillingStreet From Account Where Id = :acctId Limit 1];
    }
    
    @AuraEnabled
    public static String getHojinInfoByName(String acctName){
        String sparql = '';
        sparql += 'PREFIX  hj: <http://hojin-info.go.jp/ns/domain/biz/1#>\r\n';
        sparql += 'PREFIX  ic: <http://imi.go.jp/ns/core/rdf#>\r\n';
        sparql += ' SELECT DISTINCT ?corporateID ?corporateName ?prefecture ?city ?location ?classSType (COUNT(DISTINCT(?o)) AS ?count)\r\n';
        sparql += ' FROM <http://hojin-info.go.jp/graph/hojin>\r\n';
        sparql += ' FROM <http://hojin-info.go.jp/graph/chotatsu>\r\n';
        sparql += ' FROM <http://hojin-info.go.jp/graph/hyosho>\r\n';
        sparql += ' FROM <http://hojin-info.go.jp/graph/todokede>\r\n';
        sparql += ' FROM <http://hojin-info.go.jp/graph/hojyokin>\r\n';
        sparql += ' {\r\n';
        sparql += ' { GRAPH <http://hojin-info.go.jp/graph/hojin> {?s hj:法人基本情報 ?key. \r\n';
        sparql += ' ?key ic:名称/ic:表記 ?corporateName. \r\n';
        sparql += ' FILTER(contains(?corporateName, \''+acctName+'\')) \r\n';
        sparql += ' ?key ic:ID/ic:識別値 ?corporateID. \r\n';
        sparql += ' ?key ic:住所/ic:都道府県 ?prefecture. \r\n';
        sparql += ' ?key ic:住所/ic:市区町村 ?city.  \r\n';
        sparql += ' ?key ic:住所/ic:表記 ?location. \r\n';
        sparql += ' ?key hj:区分 _:keyName. \r\n';
        sparql += ' _:keyName ic:種別 \'処理区分\'. \r\n';
        sparql += ' _:keyName ic:表記 ?classSType.  \r\n';
        sparql += ' }} \r\n';
        sparql += ' OPTIONAL{?s hj:法人活動情報 ?o. \r\n';
        sparql += '          ?o ic:ID/ic:識別値 ?corporateID. } \r\n';
        sparql += ' } GROUP BY ?corporateID ?corporateName ?prefecture ?city ?location ?classSType \r\n';
        sparql += '   ORDER BY ?corporateName  LIMIT 1000\r\n';
        sparql = EncodingUtil.urlEncode(sparql,'UTF-8');

        String resBody;
        if (!Test.isRunningTest()){
            resBody = getInfoFromHojinInfoAPI(sparql).getBody();
            resBody = resBody.replaceAll('\n', '');
        }
        return resBody;
    }
    
    @AuraEnabled 
    public static String getHojinInfoByHojinId(String hojinId){
        String sparql = '';
        sparql += 'PREFIX  hj: <http://hojin-info.go.jp/ns/domain/biz/1#>\r\n';
        sparql += 'PREFIX  ic: <http://imi.go.jp/ns/core/rdf#>\r\n';
        
        sparql += 'SELECT DISTINCT ?corporateID ?corporateName ?corporateKana ?location ?zip ?prefecture ?city ?street ?moddate ?systemName ?classSInfo\r\n';
        sparql += 'FROM <http://hojin-info.go.jp/graph/hojin> {\r\n';
        sparql += '?s hj:法人基本情報 ?key.\r\n';
        sparql += '?key ic:ID/ic:識別値 \''+hojinId+'\'.\r\n';
        sparql += 'OPTIONAL{?key ic:ID/ic:識別値 ?corporateID .} \r\n';
        sparql += 'OPTIONAL{?key ic:名称/ic:表記 ?corporateName .} \r\n';
        sparql += 'OPTIONAL{?key ic:名称/ic:カナ表記 ?corporateKana .} \r\n';
        sparql += 'OPTIONAL{?key ic:住所/ic:表記 ?location .} \r\n';
        sparql += 'OPTIONAL{?key ic:住所/ic:郵便番号 ?zip .} \r\n';
        sparql += 'OPTIONAL{?key ic:住所/ic:都道府県 ?prefecture .} \r\n';
        sparql += 'OPTIONAL{?key ic:住所/ic:市区町村 ?city .} \r\n';
        sparql += 'OPTIONAL{?key ic:住所/hj:丁目番地等 ?street .} \r\n';
        sparql += 'OPTIONAL{?key hj:更新日時/ic:標準型日時 ?moddate .} \r\n';
        sparql += 'OPTIONAL{?key hj:システム名/ic:表記 ?systemName .} \r\n';
        sparql += 'OPTIONAL{?key hj:区分 _:keyStatus. \r\n';
        sparql += '_:keyStatus ic:種別 \'処理区分\'. \r\n';
        sparql += '_:keyStatus ic:表記 ?classSInfo .}\r\n';
        sparql += '} GROUP BY ?corporateID ?corporateName ?corporateKana ?location ?zip ?prefecture ?city ?street ?moddate ?systemName ?classSInfo \r\n';
        sparql = EncodingUtil.urlEncode(sparql,'UTF-8');
        
        String resBody;
        if (!Test.isRunningTest()){
            resBody = getInfoFromHojinInfoAPI(sparql).getBody();
            resBody = resBody.replaceAll('\n', '');
        }
        return resBody;
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
    @AuraEnabled
    public static String updateAccountRecord(String acctId, String hojinId, String acctName, String zip, String state, String city, String street){
        try{
            Account acct = [Select id, Name, hojinId__c From Account Where id = :acctId];
            acct.hojinId__c = hojinId;
            acct.Name = acctName;
            acct.BillingPostalCode = zip;
            acct.BillingState = state;
            acct.BillingCity = city;
            acct.BillingStreet = street;
            Update acct;
        }catch(Exception ex){
            return ex.getMessage();
        }
        return 'SUCCESS';
    }
}