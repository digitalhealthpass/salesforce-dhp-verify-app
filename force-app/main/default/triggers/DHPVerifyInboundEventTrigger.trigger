/**
* @author Srikanth Kottam
* @date 05/06/2021
* @group Bluewolf an IBM Company
* @description Trigger to capture the Verify Inbound details from Platform events
**/
trigger DHPVerifyInboundEventTrigger on DHP_Verify_Inbound__e (after insert) {
	try{
        system.debug('Event received>>>'+Trigger.New);
		DHPVerifyInbountEventTriggerHandler.OnAfterInsert(Trigger.New);
    } catch (Exception ex){
        system.debug('Exception on Inbound event>>>'+ ex);
        Errorlogger.createLogs('Error in Platform Event Trigger', 'DHP_Verify_Inbound__e',null);
    }
}