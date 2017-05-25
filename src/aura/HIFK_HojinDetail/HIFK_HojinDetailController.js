({
    doInit: function(cmp, event, helper){
        helper.doInit(cmp, event);
    },
    hojinSelected: function(cmp, event, helper) {
        var hojinId = event.getParam('hojinId');
        helper.getHojinInfo(cmp, hojinId, false);
        helper.showDetail(cmp);
    },
    updateAccount: function(cmp, event, helper){
        helper.updateAccount(cmp, event); 
    },
    showList : function(cmp, event, helper) {
        helper.hideDetail(cmp);
        var hojinId = cmp.get('v.hojinId');
        var evt = $A.get("e.c:HIFK_ShowHojinList");
        evt.fire();
    },
    showSpinner: function (cmp, event, helper) {
        helper.showSpinner(cmp);
    },
    hideSpinner: function (cmp, event, helper) {
        helper.hideSpinner(cmp);
    }
})