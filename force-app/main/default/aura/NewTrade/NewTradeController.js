({
    init : function(c, e, h) {
        h.retrieveCurrencies(c)
    },

    onChange : function(c, e, h) {
        if(h.areCurrenciesSelected(c)) {
            c.set("v.showSpinner", true)
            c.set("v.isDisabled", h.isSaveBtnDisabled(c))
            h.getRate(c, c.get("v.sellCurrency"), c.get("v.buyCurrency"))
        }
    },

    onRateChange: function(c, e, h) {
        if(c.get('v.sellAmnt') != '') {
            h.calcualteBuyAmount(c)
        }
    },

    getBuyAmount : function(c, e, h) {
        if(h.areCurrenciesSelected(c)) {
            h.calcualteBuyAmount(c)
        }
    },

    onButtonClick : function(c, e, h) {
        let buttonId = e.getSource().getLocalId();
        let sellCurrency = c.get("v.sellCurrency")
        let sellAmnt = c.get("v.sellAmnt")
        let buyCurrency = c.get("v.buyCurrency")
        let buyAmnt = c.get("v.buyAmnt")
        let rate = c.get("v.rate")
        if(buttonId == "saveTrade"){
            c.set('v.showSpinner', true)
            c.set("v.isDisabled", h.isSaveBtnDisabled(c))
            h.createTradeRecord(c, sellCurrency, sellAmnt, buyCurrency, buyAmnt, rate)
            h.navigateToUrl(c, 'lightning/o/Trade__c/home')
        } else if(buttonId == "cancel"){
            h.navigateToUrl(c, 'lightning/o/Trade__c/home')
        }

    }
})
