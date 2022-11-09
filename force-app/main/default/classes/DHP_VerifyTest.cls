/**
* @author Srikanth Kottam
* @date 05/11/2021
* @group Bluewolf an IBM Company
* @description Test Class for DHP_Verify
**/
@isTest
public with sharing class DHP_VerifyTest {

    static testMethod void DHP_VerifyTestPass() {
        test.startTest();
        String qrCode = '{"proof":{"type":"EcdsaSecp256r1Signature2019","signatureValue":"MEYCIQCk8bd5NzZKQ9Zxq0YwwXgmXEHT1DHARpO3k9PA4rAsTgIhAJvlnKEbyrOOJuZSaNob9VCKLUuEoWInKd1ho4o80vtZ","nonce":"23bd5e6a-0f4b-4c1c-bf2a-786b70179e5b","creator":"did:hpass:19b0cf0d5fc7017dd66ddd2374fbd9b796d988aced083d709abbaa0f7480b474:3b42369798836305f6e7cd61911b00d07d53a96d75f2a13f75be5fd094d0864e#key-1","created":"2021-04-09T13:58:00Z"},"credentialSubject":{"vaccineCode":"91300-0001A","vaccine":"Pfizer-Biontech Covid-19 Vaccine","type":"Vaccination Card","targetDisease":"Covid-19","subject":{"phone":"2123455432","name":{"given":"Test555","family":"Contact"},"identity":[{"value":"DL1234567","type":"Driver\'s License Number","Sourcesystem":null}],"gender":"Male","email":"test555@contact.com","birthDate":"2000-03-08","address":"System.Address[getCity=City;getCountry=USA;getCountryCode=null;getGeocodeAccuracy=null;getPostalCode=12345;getState=State;getStateCode=null;getStreet=123 Street;]"},"status":"in-progress","occurrenceDateTime":"2021-03-23","manufacturer":"Pfizer","lotNumber":"Pfizer","history":[{"vaccineCode":"VC4566","vaccine":"Pfizer-Biontech Covid-19 Vaccine","occurrenceDateTime":"2021-03-23","manufacturer":"Pfizer","lotNumber":"LA567"}],"display":"grey"},"credentialSchema":{"type":"JsonSchemaValidator2018","id":"did:hpass:19b0cf0d5fc7017dd66ddd2374fbd9b796d988aced083d709abbaa0f7480b474:c4d1492e81bfcb951d028c0a4bd3c1edec16d32aed77a608c76ed917f3231f7e;id=vaccinationcard;version=0.2"},"expirationDate":"2023-03-15T12:00:00Z","issuanceDate":"2021-04-09T13:58:00Z","issuer":"did:hpass:19b0cf0d5fc7017dd66ddd2374fbd9b796d988aced083d709abbaa0f7480b474:3b42369798836305f6e7cd61911b00d07d53a96d75f2a13f75be5fd094d0864e","type":["VerifiableCredential"],"id":"did:hpass:19b0cf0d5fc7017dd66ddd2374fbd9b796d988aced083d709abbaa0f7480b474:3b42369798836305f6e7cd61911b00d07d53a96d75f2a13f75be5fd094d0864e#vc-d4f4045c-5c9b-4226-854a-3656c239ed20","@context":["https://www.w3.org/2018/credentials/v1"]}';
        String verifyId = DHP_Verify.validateQRCode(qrCode);
        system.assertNotEquals(null, verifyId);
        if(!String.isBlank(verifyId)){
            String verifyStatus = DHP_Verify.verifyCredential(verifyId);
            system.assertNotEquals(null, verifyStatus);
        }
        test.stopTest();
    }

    static testMethod void DHP_VerifyTestFail() {
        test.startTest();
        String qrCode = '{"proof":{"type":"EcdsaSecp256r1Signature2019","signatureValue":"MEYCIQCk8bd5NzZKQ9Zxq0YwwXgmXEHT1DHARpO3k9PA4rAsTgIhAJvlnKEbyrOOJuZSaNob9VCKLUuEoWInKd1ho4o80vtZ","nonce":"23bd5e6a-0f4b-4c1c-bf2a-786b70179e5b","creator":"did:hpass:19b0cf0d5fc7017dd66ddd2374fbd9b796d988aced083d709abbaa0f7480b474:3b42369798836305f6e7cd61911b00d07d53a96d75f2a13f75be5fd094d0864e#key-1","created":"2021-04-09T13:58:00Z"},"credentialSubject":{"vaccineCode":"91300-0001A","vaccine":"Pfizer-Biontech Covid-19 Vaccine","type":"Vaccination Card","targetDisease":"Covid-19","subject":{"phone":"","name":{"given":"","family":""},"identity":[{"value":"DL1234567","type":"Driver\'s License Number","Sourcesystem":null}],"gender":"Male","email":"","birthDate":"","address":"System.Address[getCity=City;getCountry=USA;getCountryCode=null;getGeocodeAccuracy=null;getPostalCode=12345;getState=State;getStateCode=null;getStreet=123 Street;]"},"status":"in-progress","occurrenceDateTime":"2021-03-23","manufacturer":"Pfizer","lotNumber":"Pfizer","history":[{"vaccineCode":"VC4566","vaccine":"Pfizer-Biontech Covid-19 Vaccine","occurrenceDateTime":"2021-03-23","manufacturer":"Pfizer","lotNumber":"LA567"}],"display":"grey"},"credentialSchema":{"type":"JsonSchemaValidator2018","id":"did:hpass:19b0cf0d5fc7017dd66ddd2374fbd9b796d988aced083d709abbaa0f7480b474:c4d1492e81bfcb951d028c0a4bd3c1edec16d32aed77a608c76ed917f3231f7e;id=vaccinationcard;version=0.2"},"expirationDate":"2023-03-15T12:00:00Z","issuanceDate":"2021-04-09T13:58:00Z","issuer":"did:hpass:19b0cf0d5fc7017dd66ddd2374fbd9b796d988aced083d709abbaa0f7480b474:3b42369798836305f6e7cd61911b00d07d53a96d75f2a13f75be5fd094d0864e","type":["VerifiableCredential"],"id":"did:hpass:19b0cf0d5fc7017dd66ddd2374fbd9b796d988aced083d709abbaa0f7480b474:3b42369798836305f6e7cd61911b00d07d53a96d75f2a13f75be5fd094d0864e#vc-d4f4045c-5c9b-4226-854a-3656c239ed20","@context":["https://www.w3.org/2018/credentials/v1"]}';
        String verifyId = DHP_Verify.validateQRCode(qrCode);
        system.assertNotEquals(null, verifyId);
        if(!String.isBlank(verifyId)){
            String verifyStatus = DHP_Verify.verifyCredential(verifyId);
            system.assertNotEquals(null, verifyStatus);
        }
        test.stopTest();
    }
}