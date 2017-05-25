({
    showSpinner: function (cmp, event) {
        var spinner = cmp.find("spinner");
        $A.util.removeClass(spinner, "slds-hide");
    },
    hideSpinner: function (cmp, event) {
        var spinner = cmp.find("spinner");
        $A.util.addClass(spinner, "slds-hide");
    }
})