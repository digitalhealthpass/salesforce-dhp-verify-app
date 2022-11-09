/**
* @author Srikanth Kottam
* @date 05/06/2021
* @group Bluewolf an IBM Company
* @description Trigger handler class for DHP Verify Inbound trigger
**/
public with sharing class DHPVerifyInbountEventTriggerHandler {
    public static void OnAfterInsert(List<DHP_Verify_Inbound__e> dhpEventsList){
        List<Verify__c> verifyEventList = new List<Verify__c>();
        Id recId;
        String verifyStatus;
        if(!dhpEventsList.isEmpty()){
            for(DHP_Verify_Inbound__e dhpEvent : dhpEventsList){
                if(dhpEvent.RecordId__c != null && !String.isBlank(dhpEvent.RecordId__c)){
                    Verify__c verifyEventRec = new Verify__c();
                    verifyEventRec.Id = dhpEvent.RecordId__c;
                    if(!String.isBlank(dhpEvent.Status__c)){
                        verifyEventRec.Status__c = dhpEvent.Status__c;
                        verifyEventList.add(verifyEventRec);
                    }
                }
            }
        }
        
        if(!verifyEventList.isEmpty()){
            try{
                if(Schema.sObjectType.Verify__c.isUpdateable() && Schema.sObjectType.Verify__c.fields.Status__c.isUpdateable()){
                    update verifyEventList;
                }
            } catch(DmlException ex){
                System.debug('Update Failed Verify Record>>>'+ex.getMessage());
                Errorlogger.createLogs('Error while updating Verify Record', 'DHPVerifyInbountEventTriggerHandler',verifyEventList[0].Id);
            }
        }
    }
}