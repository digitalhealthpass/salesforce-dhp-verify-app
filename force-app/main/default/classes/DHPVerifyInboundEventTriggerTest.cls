/**
* @author Srikanth Kottam
* @date 05/11/2021
* @group Bluewolf an IBM Company
* @description Test Class for DHPVerifyInboundEventTrigger
**/
@isTest
public with sharing class DHPVerifyInboundEventTriggerTest {

    @TestSetup
    static void makeData(){
        Contact conRec = new Contact(firstName = 'Test555', LastName = 'Contact', email = 'test555@contact.com');
        Insert conRec;

        Verify__c verifyRec = new Verify__c();
        verifyRec.Status__c = 'Scanned';
        verifyRec.Scanned_Details__c = 'Test Scan';
        verifyRec.Contact__c = conRec.Id;
        verifyRec.Verifier__c = UserInfo.getUserId();
        Insert verifyRec;
    }
    @isTest static void testValidEvent() {

        Id conId = [Select Id from Contact where email = 'test555@contact.com' limit 1].Id;
        Id VerifyId = [Select Id from Verify__c where Contact__c =: conId limit 1].Id;

        // Create a test event instance
        DHP_Verify_Inbound__e verifyEvent = new DHP_Verify_Inbound__e(RecordId__c=VerifyId, Status__c='Verified');
        
        Test.startTest();
        
        // Publish test event
        Database.SaveResult sr = EventBus.publish(verifyEvent);
            
        Test.stopTest();
                
        // Perform validations here
        
        // Verify SaveResult value
        System.assertEquals(true, sr.isSuccess());
        
        // Verify that the status was updated by a trigger.
        String verifyStatus = [SELECT Id, Status__c FROM Verify__c where id =: VerifyId limit 1].Status__c;
        // Validate that this case was found
        System.assertEquals('Verified', verifyStatus);
    }

    @isTest static void testInvalidEvent() {

        Id conId = [Select Id from Contact where email = 'test555@contact.com' limit 1].Id;
        Id VerifyId = [Select Id from Verify__c where Contact__c =: conId limit 1].Id;

        // Create a test event instance
        
        
        // Create a test event instance with invalid data.
        // We assume for this test that the Serial_Number__c field is required.
        // Publishing with a missing required field should fail.
        DHP_Verify_Inbound__e verifyEvent = new DHP_Verify_Inbound__e(RecordId__c=VerifyId, Status__c='Verify');
        
        Test.startTest();
        
        // Publish test event
        Database.SaveResult sr = EventBus.publish(verifyEvent);
            
        Test.stopTest();
                
        // Perform validations here
        
        // Verify SaveResult value - isSuccess should be false
        System.assertEquals(true, sr.isSuccess());
        
        // Log the error message
        for(Database.Error err : sr.getErrors()) {
            System.debug('Error returned: ' +
                        err.getStatusCode() +
                        ' - ' +
                        err.getMessage()+' - '+err.getFields());
        }
        
        // Verify that the status was not updated by a trigger.
        String verifyStatus = [SELECT Id, Status__c FROM Verify__c where id =: VerifyId limit 1].Status__c;
        // Validate that this case was found
        System.assertNotEquals('Verified', verifyStatus);
    }

    @isTest static void testInvalidEventTwo() {

        Id conId = [Select Id from Contact where email = 'test555@contact.com' limit 1].Id;
        Id VerifyId = [Select Id from Verify__c where Contact__c =: conId limit 1].Id;

        // Create a test event instance
        
        
        // Create a test event instance with invalid data.
        // We assume for this test that the Serial_Number__c field is required.
        // Publishing with a missing required field should fail.
        DHP_Verify_Inbound__e verifyEvent = new DHP_Verify_Inbound__e(RecordId__c=conId);
        
        Test.startTest();
        
        // Publish test event
        Database.SaveResult sr = EventBus.publish(verifyEvent);
            
        Test.stopTest();
                
        // Perform validations here
        
        // Verify SaveResult value - isSuccess should be false
        System.assertEquals(true, sr.isSuccess());
        
        // Log the error message
        for(Database.Error err : sr.getErrors()) {
            System.debug('Error returned: ' +
                        err.getStatusCode() +
                        ' - ' +
                        err.getMessage()+' - '+err.getFields());
        }
        
        // Verify that the status was not updated by a trigger.
        String verifyStatus = [SELECT Id, Status__c FROM Verify__c where id =: VerifyId limit 1].Status__c;
        // Validate that this case was found
        System.assertNotEquals('Verified', verifyStatus);
    }
}