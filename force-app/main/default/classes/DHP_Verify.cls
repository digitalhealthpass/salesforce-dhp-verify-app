/**
* @author Srikanth Kottam
* @date 05/04/2021
* @group Bluewolf an IBM Company
* @description Class for to Verify scanned QRCode from LWC
**/
public with sharing class DHP_Verify {
    /**
    * @params: Input String and returns RecordId
    * @description: Method to check if scanned QRCode credential is valid
    **/
    @AuraEnabled
    public static String validateQRCode(String qrCode) {
        
        String firstName;
        String lastName;
        String email;
        String phone;
        String dob;
        
        if(!String.isBlank(qrCode)){
            Map<String, Object> qrCodeMap = (Map<String, Object>)JSON.deserializeUntyped(qrCode);
            if(qrCodeMap.containsKey('credentialSubject')){
                Map<String, Object> credentialSubjectMap = (Map<String, Object>)qrCodeMap.get('credentialSubject');
                if(credentialSubjectMap.containsKey('subject')){
                    Map<String, Object> subjectMap = (Map<String, Object>)credentialSubjectMap.get('subject');
                    if(subjectMap.containsKey('email')){
                        email = String.valueOf(subjectMap.get('email'));
                    }
                    if(subjectMap.containsKey('phone')){
                        phone = String.valueOf(subjectMap.get('phone'));
                    }
                    if(subjectMap.containsKey('birthDate')){
                        dob = String.valueOf(subjectMap.get('birthDate'));
                    }

                    if(subjectMap.containsKey('name')){
                        Map<String, Object> nameMap = (Map<String, Object>)subjectMap.get('name');
                        if(nameMap.containsKey('given')){
                            firstName = String.valueOf(nameMap.get('given'));
                        }
                        if(nameMap.containsKey('family')){
                            lastName = String.valueOf(nameMap.get('family'));
                        }
                    }
                }                
            }            
        }


        Id conId;
        // Create contact or retrieve contact details
        List<Contact> conList = [Select Id, email from contact where 
                                Email =: email and firstName =: firstName and lastName =: lastName 
                                limit 1];
        if(!conList.isEmpty()){
            conId = conList[0].Id;
        } else {
            Contact contactRec = new Contact();
            contactRec.firstName = firstName;
            contactRec.lastName = lastName;
            contactRec.Phone = phone;
            contactRec.Email = email;
            if(dob != null && !String.isBlank(dob)){
                contactRec.Birthdate = Date.valueOf(dob);
            }
            
            try{
                Insert contactRec;
                conId = contactRec.Id;
            } catch(Exception ex){
                System.debug('DML Exception>>>'+ex);
                Errorlogger.createLogs('Error while Inserting Contact Record', 'DHP_Verify.validateQRCode',null);
            }            
        }

        String verifyId;
        Id verifierId = UserInfo.getUserId();
        Verify__c verifyRec = new Verify__c();
        verifyRec.Status__c = 'Scanned';
        verifyRec.Scanned_Details__c = qrCode;
        verifyRec.Verifier__c = verifierId;
        if(conId != null){
            verifyRec.Contact__c = conId;
        }
        try{
            Insert verifyRec;
        } catch (Exception ex){
            System.debug('DML Exception>>>'+ex);
            Errorlogger.createLogs('Error while Inserting Verify Record', 'DHP_Verify.validateQRCode',null);
        }
        

        //Publish the Event to DHP Outbound
        // Create an instance of the event and store it in the DHP Outbound Event variable
        DHP_Verify_Outbound__e postEvent = new DHP_Verify_Outbound__e(
            RecordId__c = verifyRec.Id,
            Payload__c = qrCode);
        // Call method to publish events
        Database.SaveResult sr = EventBus.publish(postEvent);
        // Inspect publishing result
        if (sr.isSuccess()) {
            verifyId = verifyRec.Id;
        } else {
            String errorMessage;
            for(Database.Error err : sr.getErrors()) {
                errorMessage = err.getMessage();
                System.debug('Error returned: ' +
                                err.getStatusCode() +
                                ' - ' +
                                err.getMessage());
            }
            Errorlogger.createLogs('Error while Posting Verify Credential Details using Platform Events', 'DHP_Verify.validateQRCode',  verifyRec.Id);
            return null;
        } 
        return verifyId;
    }

    /**
    * @params: Input String(VerifyId), returns a String(Verify record Status)
    * @description: Method to return Verify record status
    **/
    @AuraEnabled
    public static String verifyCredential(String verifyId) {
        String verifyStatus = '';
        if(!String.isBlank(verifyId)){
            List<Verify__c> verifyList = [Select Id, Status__c from Verify__c where Id =: verifyId limit 1];
            if(!verifyList.isEmpty()){
                verifyStatus = verifyList[0].Status__c;                
            }         
        }
        return verifyStatus;
    }
}