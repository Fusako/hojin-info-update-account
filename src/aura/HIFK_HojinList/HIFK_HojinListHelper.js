({
    showSpinner: function (cmp) {
        var spinner = cmp.find("spinner");
        $A.util.removeClass(spinner, "slds-hide");
    },
    hideSpinner: function (cmp) {
        var spinner = cmp.find("spinner");
        $A.util.addClass(spinner, "slds-hide");
    },
    doInit: function (cmp) {
        this.showSpinner(cmp);
        var status = '法人インフォデータ検索中...';
        cmp.set("v.status", status);
        var show = cmp.get("v.show");
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
                if(acct.hojinId__c == null || show == true){
                    cmp.set("v.show", true);
                    var acctName = acct.Name;
                    acctName = acctName.replace(/[A-Za-z0-9&',·'\.\-]/g, function(s) {
                        return String.fromCharCode(s.charCodeAt(0) + 0xFEE0);
                    });
                    this.getHojinList(cmp, acctName);
                }else{
                    cmp.set("v.show", false);
                }
            }
        });
        $A.enqueueAction(action);
    },
    getHojinList: function(cmp, acctName){
        var numOfList = 3;
        var action = cmp.get("c.getHojinInfoByName");
        action.setParams({
            acctName: acctName
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state === "SUCCESS"){
                var hojinJson = response.getReturnValue();
                var hojinParsed = JSON.parse(hojinJson);
                var hojinListAll = hojinParsed.results.bindings;
                var hojinListToShow = [];
                
                cmp.set("v.hojinListAll", hojinListAll);
                if(hojinListAll.length > numOfList){
                    for(var i = 0; i < numOfList ; i++){
                        hojinListToShow.push(hojinListAll[i]);
                    }
                    cmp.set("v.hojinListSmall", hojinListToShow);
                }else{
                    hojinListToShow = hojinListAll;
                }
                
                var status = '法人名 "'+acctName+'" での検索結果: ';
                cmp.set("v.status", status);
                cmp.set("v.hojinListToShow", hojinListToShow);
                this.hideSpinner(cmp);
            }
            
        });
        $A.enqueueAction(action);
    }
})