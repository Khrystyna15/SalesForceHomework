public with sharing class CandidateNominationTrH implements ITriggerHandler{

    // public static Boolean TriggerDisabled = false;

    // public Boolean IsDisabled()
    // {
    //     if (TriggerSettings__c.CandidateNominationTriggerDisabled__c = true)
    //         return true;
    //     else
    //         return TriggerDisabled;
    // }
    

    public void beforeInsert(List<SObject> newRecord) {

        List<CandidateNomination__c> masterCandidates = [SELECT ID, NominationId__c, Nominees__c, Description__c, CampaignId__c
                                                        FROM CandidateNomination__c WHERE Type__c = 'Master'];
        for (CandidateNomination__c cc : (List<CandidateNomination__c>)newRecord) {
            cc.Type__c='Master';
            for (CandidateNomination__c  ccmaster : masterCandidates) {
                if(cc.NominationId__c == ccmaster.NominationId__c 
                    && cc.Nominees__c == ccmaster.Nominees__c
                    && cc.CampaignId__c == ccmaster.CampaignId__c){
                        cc.Type__c = 'Child';
                        cc.MasterRecordID__c = ccmaster.Id;
                }
            }
        }
    }

    public void beforeDelete(Map<Id, SObject> delRecord) {
        Set<String> deleted_cc_id = new Set<String>();
        for(CandidateNomination__c cc : (List<CandidateNomination__c>)delRecord.values()){
            deleted_cc_id.add(cc.id);
        }
        List<CandidateNomination__c> masterList =  [SELECT ID, 
                                                (SELECT ID, NominationId__c, Nominees__c, Description__c, CampaignId__c FROM ChildCandidateNominations__r)
                                                FROM CandidateNomination__c where ID IN :deleted_cc_id AND Type__c = 'Master'];
        List<CandidateNomination__c> childsForChangesList = new List<CandidateNomination__c>();
        for (CandidateNomination__c ccmaster :masterList) {
            List<CandidateNomination__c> childList = ccmaster.ChildCandidateNominations__r;
            if(!childList.isEmpty()){
                childList[0].Type__c = 'Master';
                childList[0].MasterRecordID__c = NULL;
                for(Integer i = 1;i < childList.size(); i++){
                    childList[i].MasterRecordID__c = childList[0].ID;
                }
                childsForChangesList.addAll(childList);
            } 
        }
        update childsForChangesList;
    }

    public void beforeUpdate(Map<Id, SObject> newItems, Map<Id, SObject> oldItems){}
    public void afterInsert(Map<Id, SObject> newItems){}
    public void afterUpdate(Map<Id, SObject> newItems, Map<Id, SObject> oldItems){}
    public void afterDelete(Map<Id, SObject> oldItems){}
    public void afterUndelete(Map<Id, SObject> oldItems){}

}