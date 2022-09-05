({
    retrieveCurrencies: function (c) {
        let action = c.get('c.getAllCurrencies')
        action.setParams({
           
        })
        action.setCallback(this, function (resp) {
            let wrapper = JSON.parse(resp.getReturnValue())
            if (resp.getState() === "SUCCESS") {
                if(wrapper.errorMsg != null) {
                    this.showErrorToast(c, wrapper.errorMsg)
                }
                c.set('v.currencies', wrapper.currencies)
            } else if (resp.getState() === "ERROR") {
                let errors = resp.getError();
                let message = '';

                if (errors && Array.isArray(errors) && errors.length > 0) {
                    message = errors[0].message;
                }
                this.showErrorToast(c, message);
            } else {
                this.showErrorToast(c, resp.getReturnValue())
            }
            c.set('v.isDisabled', this.isSaveBtnDisabled(c))
            c.set('v.showSpinner', false)

        })
        $A.enqueueAction(action)
    },

    getRate: function (c, sellCurrency, buyCurrency ) {
        let action = c.get('c.getRate')
        action.setParams({
            "sellCurrency" : sellCurrency,
            "buyCurrency" : buyCurrency
        })
        action.setCallback(this, function (resp) {
            let wrapper = JSON.parse(resp.getReturnValue())
            if (resp.getState() === "SUCCESS") {
                if(wrapper.errorMsg != null) {
                    this.showErrorToast(c, wrapper.errorMsg)
                }
                c.set('v.rate', wrapper.rate)
                if(c.get('v.sellAmnt') != '') {
                    this.calcualteBuyAmount(c)
                }
            } else if (resp.getState() === "ERROR") {
                let errors = resp.getError();
                let message = '';

                if (errors && Array.isArray(errors) && errors.length > 0) {
                    message = errors[0].message;
                }
                this.showErrorToast(c, message);
            } else {
                this.showErrorToast(c, '')
            }
            c.set('v.isDisabled', this.isSaveBtnDisabled(c))
            c.set('v.showSpinner', false)

        })
        $A.enqueueAction(action)
    },

    calcualteBuyAmount: function (c) {
        let sellAmnt = c.get('v.sellAmnt')
        let rate = c.get('v.rate')
        c.set('v.buyAmnt', sellAmnt * rate)
        c.set('v.isDisabled', this.isSaveBtnDisabled(c))
        c.set('v.showSpinner', false)
    },

    createTradeRecord: function (c, sellCurrency, sellAmnt, buyCurrency, buyAmount, rate) {
        let action = c.get('c.createTrade')
        action.setParams({
            "sellCurrency" : sellCurrency,
            "sellAmnt" : sellAmnt,
            "buyCurrency" : buyCurrency,
            "buyAmnt" : buyAmount,
            "rate" : rate
        })
        action.setCallback(this, function (resp) {
            let wrapper = JSON.parse(resp.getReturnValue())
            if (resp.getState() === "SUCCESS") {
                if(wrapper.errorMsg != null) {
                    this.showErrorToast(c, wrapper.errorMsg)
                }
                this.navigateToUrl(c, 'lightning/o/Trade__c/home')
            } else if (resp.getState() === "ERROR") {
                let errors = resp.getError();
                let message = '';

                if (errors && Array.isArray(errors) && errors.length > 0) {
                    message = errors[0].message;
                }
                this.showErrorToast(c, message);
            } else {
                this.showErrorToast(c, '')
            }
            c.set('v.isDisabled', this.isSaveBtnDisabled(c))
            c.set('v.showSpinner', false)
        })
        $A.enqueueAction(action)
    },

    areCurrenciesSelected : function (c) {
        return c.get("v.sellCurrency") != '' && c.get("v.buyCurrency") != ''
    },

    isSaveBtnDisabled : function (c) {
        return !(this.areCurrenciesSelected(c) && c.get("v.sellAmnt") != '')
    },

    navigateToUrl: function (c, url) {
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": '/' + url
        });
        urlEvent.fire();
    }, 

    showErrorToast: function (c, message) {
        c.find('notifLib').showToast({
            title: 'Something went wrong',
            message: message,
            duration: ' 5000',
            key: 'info_alt',
            variant: 'error',
            mode: 'dismissible'
        });
    }
})
