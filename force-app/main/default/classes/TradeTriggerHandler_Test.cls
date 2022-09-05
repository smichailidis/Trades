@isTest(SeeAllData=True)
public class TradeTriggerHandler_Test {


    @isTest
    public static void testCreateChatterPost() {
        CollaborationGroup tradeReviewers = [SELECT Id FROM CollaborationGroup WHERE Name = 'Trade reviewers'];
        Trade__c t1 = new Trade__c();
        t1 = new Trade__c();
        t1.Sell_Currency__c = 'EUR';
        t1.Sell_Amount__c = 5.5;
        t1.Buy_Currency__c = 'USD';
        t1.Buy_Amount__c = 4.6;
        t1.Rate__c = 1.1;
        Trade__c t2 = t1.clone();
        insert new List<Trade__c>{t1,t2};

        FeedItem[] posts = [SELECT Id FROM FeedItem WHERE ParentId =: tradeReviewers.Id];
        System.assertEquals(2, posts.size());
    }
}
