({
    init : function(c, e, h) {
        var modalBody;
        var modalFooter;
        $A.createComponents([
            ["c:NewTrade",{}]
        ],
         function(cs, status){
             if (status === "SUCCESS") {
                 modalBody = cs[0];
                 c.find('overlayLib').showCustomModal({
                     header: "New Trade",
                     body: modalBody,
                     footer: modalFooter,
                     showCloseButton: true,
                     cssClass: "my-modal,my-custom-class,my-other-class",
                     closeCallback: function() {
                        h.navigateToUrl(c, 'lightning/o/Trade__c/home')
                     }
                 });
             }
         });
    },
})