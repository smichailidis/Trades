trigger Trade_Trigger on Trade__c (after insert) {

    TradeTriggerHandler.createChatterPost(Trigger.new);
}