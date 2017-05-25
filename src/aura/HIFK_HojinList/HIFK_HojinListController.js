({
    selectHojin : function(cmp, evt, helper) {
        var event = $A.get("e.c:HIFK_HojinSelected");
        event.setParams({"hojinId": evt.target.id});
        event.fire();
    },
    doInit: function(cmp, event, helper){
        cmp.set("v.show", false);
        helper.doInit(cmp);
    },
    showList: function(cmp, event, helper) {
        cmp.set("v.show", true);
        helper.doInit(cmp);
    },
    showAll: function(cmp, event, helper) {
        cmp.set("v.showAll", true);
        var hojinListAll = cmp.get("v.hojinListAll");
        cmp.set("v.hojinListToShow", hojinListAll);
    },
    showFewer: function(cmp, event, helper) {
        cmp.set("v.showAll", false);
        var hojinListSmall = cmp.get("v.hojinListSmall");
        cmp.set("v.hojinListToShow", hojinListSmall);
    },
    showSpinner: function (cmp, event, helper) {
        helper.showSpinner(cmp);
    },
    hideSpinner: function (cmp, event, helper) {
        helper.hideSpinner(cmp);
    }
})