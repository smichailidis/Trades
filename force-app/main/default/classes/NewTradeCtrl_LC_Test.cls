@isTest
public  class NewTradeCtrl_LC_Test {
    
    @isTest
    public static void testGetAllCurrenciesSuccess() {
        Test.setMock(HttpCalloutMock.class, new FixerIoGetCurrenciesSuccess());

        Test.startTest();
		String actualResponse = NewTradeCtrl_LC.getAllCurrencies();
		Test.stopTest();

        NewTradeCtrl_LC.wrapper res = (NewTradeCtrl_LC.wrapper) JSON.deserialize(actualResponse, NewTradeCtrl_LC.wrapper.Class);
        System.assertEquals(4, res.currencies.size());
        
    }
    @isTest
    public static void testGetAllCurrenciesFail() {
        Test.setMock(HttpCalloutMock.class, new FixerIoFail());

        Test.startTest();
		String actualResponse = NewTradeCtrl_LC.getAllCurrencies();
		Test.stopTest();

        NewTradeCtrl_LC.wrapper res = (NewTradeCtrl_LC.wrapper) JSON.deserialize(actualResponse, NewTradeCtrl_LC.wrapper.Class);
        System.assertEquals('There was a problem retrieving available currencies.', res.errorMsg);
        
    }

    @isTest
    public static void testgetRateSuccess() {
        Test.setMock(HttpCalloutMock.class, new FixerIoGetRateSuccess());

        Test.startTest();
		String actualResponse = NewTradeCtrl_LC.getRate('EUR', 'AUD');
		Test.stopTest();

        NewTradeCtrl_LC.wrapper res = (NewTradeCtrl_LC.wrapper) JSON.deserialize(actualResponse, NewTradeCtrl_LC.wrapper.Class);
        System.assertEquals(1.566015, res.rate);
        
    }
    @isTest
    public static void testgetRateFail() {
        Test.setMock(HttpCalloutMock.class, new FixerIoFail());

        Test.startTest();
		String actualResponse = NewTradeCtrl_LC.getRate('EUR', 'AUD');
		Test.stopTest();

        NewTradeCtrl_LC.wrapper res = (NewTradeCtrl_LC.wrapper) JSON.deserialize(actualResponse, NewTradeCtrl_LC.wrapper.Class);
        System.assertEquals('Failed to retrieve rate. Please try again with another currency.', res.errorMsg);
        
    }

    @isTest
    public static void testCreateTrade() {
        Test.startTest();
		String actualResponse = NewTradeCtrl_LC.createTrade('EUR',1.5, 'AUD', 5.8, 3.4);
		Test.stopTest();
        NewTradeCtrl_LC.wrapper res = (NewTradeCtrl_LC.wrapper) JSON.deserialize(actualResponse, NewTradeCtrl_LC.wrapper.Class);
        System.assertEquals(null, res.errorMsg);
        Trade__c[] newTrades = [SELECT Id, Sell_Currency__c, Sell_Amount__c,Buy_Currency__c, Buy_Amount__c, Rate__c FROM Trade__c];
        System.assertEquals(1, newTrades.size());
        System.assertEquals('EUR', newTrades[0].Sell_Currency__c);
        System.assertEquals(1.5, newTrades[0].Sell_Amount__c);
        System.assertEquals('AUD', newTrades[0].Buy_Currency__c);
        System.assertEquals(5.8, newTrades[0].Buy_Amount__c);
        System.assertEquals(3.4, newTrades[0].Rate__c);
    }

    /***********************************************************************************************
    * @author       Spyros Michailidis
    * @date         2022-09-04
    * @description  Mock response class simulating a Fixer_io success response returned after a 
    *               synchronous callout to Fixer_io /symbols endpoint
    * @return       (HttpResponse) the mock response
    ************************************************************************************************/
    public class FixerIoGetCurrenciesSuccess implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setBody('{"success": true, "symbols": { "AED": "United Arab Emirates Dirham", "AFN": "Afghan Afghani", "ALL": "Albanian Lek", "AMD": "Armenian Dram"}}');
            res.setStatusCode(200);
            return res;
        }
    }
    /***********************************************************************************************
    * @author       Spyros Michailidis
    * @date         2022-09-04
    * @description  Mock response class simulating a Fixer_io fail response returned after a 
    *               synchronous callout to any Fixer_io endpoint
    * @return       (HttpResponse) the mock response
    ************************************************************************************************/
    public class FixerIoFail implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setBody('Error');
            res.setStatusCode(404);
            return res;
        }
    }

    /***********************************************************************************************
    * @author       Spyros Michailidis
    * @date         2022-09-04
    * @description  Mock response class simulating a Fixer_io fail response returned after a 
    *               synchronous callout to Fixer_io /latest endpoint
    * @return       (HttpResponse) the mock response
    ************************************************************************************************/
    public class FixerIoGetRateSuccess implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setBody('{"success": true, "timestamp": 1519296206, "base": "EUR", "date": "2022-09-04", "rates": { "AUD": 1.566015 }}');
            res.setStatusCode(200);
            return res;
        }
    }
}