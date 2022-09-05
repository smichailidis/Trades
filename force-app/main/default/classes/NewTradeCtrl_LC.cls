/******************************************************************************
* @author       Spyros Michailidis
* @date         2022-09-04
* @description  Apex Controller for the NewTrade aura component
*******************************************************************************/
public class NewTradeCtrl_LC {

    public class wrapper {
		@AuraEnabled
		public List<String> currencies;
		@AuraEnabled
		public Decimal rate;
		@AuraEnabled
		public String errorMsg;
	}

    /********************************************************************************************
    * @author       Spyros Michailidis
    * @date         2022-09-04
    * @description  It returns a list with all available currencies proviDed by Fixed_io.
    *               The first time it calls the API and stores the values to cache.
    *               After that and in order to reduce API calls, it returns the cached list.
    *               In a new session, it will call again the API to retrieve and store to
    *               the cache the list of currencies.
	* @return		(String) the serialized wrapper class that contains the currencies
    *********************************************************************************************/
    @AuraEnabled
	public static String getAllCurrencies() {
        wrapper w = new wrapper();
        if(!Cache.Session.contains('currencies')) {
            try {
                Http http = new Http();
                HttpRequest request = new HttpRequest();
                request.setEndpoint('callout:Fixer_io/symbols');
                //request.setHeader('apikey', 'YthyFMO5x0ajVSUjHdUTe26dCYGHj7LD');
                request.setHeader('apikey', 'N6Yj34qf0zjhXy6mCZdLgvpEhdTP0iUN');
                request.setMethod('GET');
                HttpResponse response = http.send(request);
                Map<String, Object> resp = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
                Map<String, String> currencies = (Map<String, String>) JSON.deserialize( JSON.serialize(resp.get('symbols')), Map<String, String>.Class);
                Cache.Session.put('currencies', currencies.keySet());
            } catch (Exception e) {
                w.errorMsg = 'There was a problem retrieving available currencies.';
                return JSON.serialize(w);
            }
        }
        w.currencies = new List<String>((Set<String>)Cache.Session.get('currencies'));
        return JSON.serialize(w);
	}

    /******************************************************************************
    * @author       Spyros Michailidis
    * @date         2022-09-04
    * @description  It calls Fixer_io API and returns a rate value, based on the 
    *               selected sell & buy currencies
    * @param		sellCurrency (String): the currency to sell
    * @param		buyCurrency (String): the currency to buy
	* @return		(String) the serialized wrapper class that contains the rate
    *******************************************************************************/
    @AuraEnabled
	public static String getRate(String sellCurrency, String buyCurrency) {
        wrapper w = new wrapper();
        try {
            Http http = new Http();
            HttpRequest request = new HttpRequest();
            request.setEndpoint('callout:Fixer_io/latest?symbols=' + buyCurrency +'&base=' + sellCurrency);
            //request.setHeader('apikey', 'YthyFMO5x0ajVSUjHdUTe26dCYGHj7LD');
            request.setHeader('apikey', 'N6Yj34qf0zjhXy6mCZdLgvpEhdTP0iUN');
            system.debug('test');
            request.setMethod('GET');
            HttpResponse response = http.send(request);
            Map<String, Object> resp = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
            Map<String, Decimal> rates = (Map<String, Decimal>) JSON.deserialize(JSON.serialize(resp.get('rates')), Map<String, Decimal>.Class);
            w.rate = rates.get(buyCurrency);
		} catch (Exception e) {
			w.errorMsg = 'Failed to retrieve rate. Please try again with another currency.';
		}
        return JSON.serialize(w);
	}

    /************************************************************************************
    * @author       Spyros Michailidis
    * @date         2022-09-04
    * @description  It creates a new Trade__c record, with the values provided
    * @param		sellCurrency (String): the currency to sell
    * @param		sellAmnt (String): the amount to sell
    * @param		buyCurrency (String): the currency to buy
    * @param		buyAmnt (String): the amount to buy
    * @param		rate (String): the rate of the trade for the specific currencies
	* @return		(String) the serialized wrapper
    *************************************************************************************/
    @AuraEnabled
	public static String createTrade(String sellCurrency, Decimal sellAmnt, String buyCurrency, Decimal buyAmnt, Decimal rate) {
        wrapper w = new wrapper();
        Trade__c newTrade;
        try {
            newTrade = new Trade__c();
            newTrade.Sell_Currency__c = sellCurrency;
            newTrade.Sell_Amount__c = sellAmnt;
            newTrade.Buy_Currency__c = buyCurrency;
            newTrade.Buy_Amount__c = buyAmnt;
            newTrade.Rate__c = rate;
            insert newTrade;
		} catch (Exception e) {
			w.errorMsg = 'There was a problem saving the trade. Please try again.';
		}
        return JSON.serialize(w);
	}
}
