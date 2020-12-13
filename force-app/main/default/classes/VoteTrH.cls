public with sharing class VoteTrH implements ITriggerHandler{
    public void beforeInsert(List<SObject> newItems){
        List<Vote__c> newVotes = (List<Vote__c>)newItems;
        List<Vote__c> votes = [SELECT Id, VoterId__c, CandidateNominationId__r.NominationId__c, CandidateNominationId__r.CampaignId__c
                                    FROM Vote__c];
        Map<Id,CandidateNomination__c> candNomMap = new Map<Id,CandidateNomination__c>();
        for (Vote__c v : newVotes) {
            candNomMap.put(v.CandidateNominationId__c, null);
        }
        candNomMap.putAll([SELECT Id, NominationId__c, CampaignId__c 
                            FROM CandidateNomination__c WHERE Id IN : candNomMap.keyset()]);  
        /*for(Vote__c v :newVotes) {
            v.NominationId__c = candNomMap.get(v.CandidateNominationId__c).NominationId__c;      
        }  */                 
        for (Vote__c vote : votes) {
            for (Vote__c newVote : newVotes){
                System.debug('vote.CandidateNominationId__c.NominationId__c' + vote.CandidateNominationId__r.NominationId__c);
                System.debug('newVote NominationId__c' + candNomMap.get(newVote.CandidateNominationId__c).NominationId__c);
                System.debug('newVote CampaignId__c' + candNomMap.get(newVote.CandidateNominationId__c).CampaignId__c);
              if ((vote.VoterId__c == newVote.VoterId__c)
                        && (vote.CandidateNominationId__r.NominationId__c == 
                        candNomMap.get(newVote.CandidateNominationId__c).NominationId__c)
                        && (vote.CandidateNominationId__r.CampaignId__c == 
                        candNomMap.get(newVote.CandidateNominationId__c).CampaignId__c)) {
                                    newVote.addError('You have already voted in this nomination.');
                                } else {
                                    System.debug('Your vote was taken into consideration');
                                }
                /*if (vote.VoterId__c == newVote.VoterId__c    
                            && vote.CandidateNominationId__r.NominationId__c == newVote.NominationId__c){
                       newVote.addError('You have already voted in this nomination.');
                    } else {
                        System.debug('Your vote was taken into consideration');
                    }*/
            }          
        }
    }
    public void beforeUpdate(Map<Id, SObject> newItems, Map<Id, SObject> oldItems){}
    public void beforeDelete(Map<Id, SObject> oldItems){}
    public void afterInsert(Map<Id, SObject> newItems){
        List<Vote__c> votes = [SELECT Id, VoterId__c, CandidateNominationId__r.MasterRecordId__c
                                FROM Vote__c
                                WHERE Id IN :newItems.keyset()];
        for (Vote__c vote : votes) {
            if (vote.CandidateNominationId__r.MasterRecordId__c != null) {
                vote.CandidateNominationId__c = vote.CandidateNominationId__r.MasterRecordId__c; 
            }
        }
        update votes;
    }
    public void afterUpdate(Map<Id, SObject> newItems, Map<Id, SObject> oldItems){}
    public void afterDelete(Map<Id, SObject> oldItems){}
    public void afterUndelete(Map<Id, SObject> oldItems){}
}
