({
    showSpinner: function (cmp) {
        var spinner = cmp.find("spinner");
        $A.util.removeClass(spinner, "slds-hide");
    },
    hideSpinner: function (cmp) {
        var spinner = cmp.find("spinner");
        $A.util.addClass(spinner, "slds-hide");
    },
    showDetail: function (cmp){
        cmp.set("v.show", true);
    },
    hideDetail: function (cmp){
        cmp.set("v.show", false);
    },
    doInit: function (cmp, event){
        var acctId = cmp.get("v.recordId");
        var action = cmp.get("c.getAccountById");
        action.setParams({
            acctId: acctId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state === "SUCCESS"){
                var acct = response.getReturnValue();
                cmp.set("v.account", acct);
                if(acct.hojinId__c != null){
                    this.getHojinInfo(cmp, acct.hojinId__c, true);
                }else{
                    this.hideDetail(cmp);
                }
            }
        });
        $A.enqueueAction(action);
    },
    getHojinInfo: function (cmp, hojinId, isExisting){
        var status = '法人インフォデータ検索中...';
        cmp.set("v.status", status);
        var action = cmp.get("c.getHojinInfoByHojinId");
        cmp.set("v.hojinId", hojinId);
        action.setParams({
            hojinId: hojinId
        });
        action.setCallback(this, function(response) {
            
            var state = response.getState();
            if(state === "SUCCESS"){
                var hojinJson = response.getReturnValue();
                var hojinParsed = JSON.parse(hojinJson);
                var hojinObj = hojinParsed.results.bindings[0];
                var isSame = false;
                if(hojinObj){
                    var acctName = hojinObj.corporateName.value;
                    hojinObj.formattedName = acctName.replace(/[Ａ-Ｚａ-ｚ０-９＆’’]/g, function(s) {
                      return String.fromCharCode(s.charCodeAt(0) - 0xFEE0);
                    });
                    var zip = hojinObj.zip.value;
                    hojinObj.formattedZip = zip.substr(0, 3)+'-'+zip.substr(3, 7);
                    if(isExisting){
                        var acct = cmp.get("v.account");
                        if(acct.Name == hojinObj.formattedName && 
                           acct.BillingPostalCode == hojinObj.formattedZip && 
                           acct.BillingState == hojinObj.prefecture.value && 
                           acct.BillingCity == hojinObj.city.value && 
                           acct.BillingStreet == hojinObj.street.value){
                            isSame = true;
                        }
                    }
                }
                status = '法人番号 "'+hojinId+'" の法人情報: ';
                cmp.set("v.status", status);
                cmp.set("v.isSame", isSame);
                cmp.set("v.hojinId", hojinId);
                cmp.set("v.hojinObj", hojinObj);
                cmp.set("v.isExisting", isExisting);
            }
        });
        $A.enqueueAction(action);
    },
    updateAccount: function(cmp, event){
        var hojinObj = cmp.get('v.hojinObj');
        var recordId = cmp.get('v.recordId');
        var acctName = hojinObj.corporateName.value.replace(/[Ａ-Ｚａ-ｚ０-９＆’’]/g, function(s) {
            return String.fromCharCode(s.charCodeAt(0) - 0xFEE0);
        });
        acctName = acctName.replace('　', ' ');
        
        var action = cmp.get("c.updateAccountRecord");
        action.setParams({
            acctId: recordId,
            hojinId: hojinObj.corporateID.value,
            acctName: acctName,
            zip: hojinObj.formattedZip,
            state: hojinObj.prefecture.value,
            city: hojinObj.city.value,
            street: hojinObj.street.value
        });
        action.setCallback(this, function(response) {
            var result = response.getReturnValue();
            if(result=='SUCCESS'){
                $A.get('e.force:refreshView').fire();
            }else{
                
            }
        });
        $A.enqueueAction(action);        
    },
})