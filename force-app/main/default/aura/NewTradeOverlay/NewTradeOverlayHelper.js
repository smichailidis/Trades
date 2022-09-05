({
    navigateToUrl: function (c, url) {
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": '/' + url
        });
        urlEvent.fire();
    }
})
