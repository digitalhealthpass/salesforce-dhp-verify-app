/**
 * @author Srikanth Kottam
 * @date 5/7/2021
 * @group Bluewolf an IBM Company
 * @description Capture Errors while verifying
 **/
public with sharing class ErrorLogger {
    /**
    * @return Void
    * @description  Captures the log information when integration with DHP has gone wrong
    */
    public static void createLogs(String Error, String Location, String RecordId){
    
        Error_Logs__c log = new Error_Logs__c();
        
        log.Error__c = Error;
        log.RecordId__c = RecordId;
        log.Location__c = Location;
        
        if(Schema.sObjectType.Error_Logs__c.isCreateable() && 
           Schema.sObjectType.Error_Logs__c.fields.Error__c.isCreateable() &&
           Schema.sObjectType.Error_Logs__c.fields.Location__c.isCreateable() &&
           Schema.sObjectType.Error_Logs__c.fields.RecordId__c.isCreateable()){
            try{
                insert log;
            } catch(Exception ex){
                System.debug('Error inserting ErrorLogs>>>'+ex);
            }
        } else{
            system.debug('Cannot insert');
        }    
    }
}