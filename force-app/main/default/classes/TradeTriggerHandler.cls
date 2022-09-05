public class TradeTriggerHandler {

    /***********************************************************************************************
    * @author       Spyros Michailidis
    * @date         2022-09-04
    * @description  It creates a new chatter post for every trade provided in the parameters
    * @return       (HttpResponse) the mock response
    ************************************************************************************************/
    public static void createChatterPost(List<Trade__c> trades) {
        CollaborationGroup[] groups =  [SELECT Id FROM CollaborationGroup WHERE name = 'Trade reviewers'];
        if(groups.size() != 1) return;
        FeedItem[] posts = new List<FeedItem>();
        for(Trade__c trade : trades) {
            FeedItem post = new FeedItem();
            post.ParentId = groups[0].Id; 
            post.Title = 'Trade ' + trade.Name; 
            post.IsRichText = true; 
            post.Body = '<p>A new trade has been created with the following data:</p>';
            post.Body += '<p>Sell Currency: ' + trade.Sell_Currency__c + '</p>';
            post.Body += '<p>Sell Amount: ' + trade.Sell_Amount__c + '</p>';
            post.Body += '<p>Buy Currency: ' + trade.Buy_Currency__c + '</p>';
            post.Body += '<p>Buy Amount: ' + trade.Buy_Amount__c + '</p>';
            post.Body += '<p>Rate: ' + trade.Rate__c + '</p>';
            post.Body += '<p>Booked Date: ' + trade.CreatedDate + '</p>';
            post.Body += '<p>You may find more details in the link below</p>';
            post.LinkUrl = '/' + trade.Id;
            postS.add(post);
        }
        insert posts;
    }
}
