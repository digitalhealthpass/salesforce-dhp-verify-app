/**
* @author Srikanth Kottam
* @date 04/12/2021
* @group Bluewolf an IBM Company
* @description LWC Component to Verify credential by scanning QRCode and validating
**/
import { LightningElement } from 'lwc';
import { getBarcodeScanner } from 'lightning/mobileCapabilities';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import validateQRCode from '@salesforce/apex/DHP_Verify.validateQRCode';
import verifyCredential from '@salesforce/apex/DHP_Verify.verifyCredential';

export default class DhpQRCodeScan extends LightningElement {

    myScanner;
    scanButtonDisabled = false;
    scannedBarcode = '';

    isSpinner = false;      // Spinner
    verifyId;
    customError = false;

    // When component is initialized, detect whether to enable Scan button
    connectedCallback() {
        this.myScanner = getBarcodeScanner();
        if (this.myScanner == null || !this.myScanner.isAvailable()) {
            this.scanButtonDisabled = true;
        }
    }

    handleScanQR(event) {
        this.customError = false;
        // Reset scannedBarcode to empty string before starting new scan
        this.scannedBarcode = '';

        if (this.myScanner != null && this.myScanner.isAvailable()) {
            const scanningOptions = {
                barcodeTypes: [this.myScanner.barcodeTypes.QR]
            };
            // Perform scanning operations
            this.myScanner.beginCapture(scanningOptions)
                .then((result) => {
                    // Do something with the result of the scan
                    this.scannedBarcode = result.value;
                    this.initiateVerificationProcess(this.scannedBarcode);
                })
                .catch((error) => {
                    // Handle cancellation and scanning errors here
                    this.customError = true;
                    //alert('error while scan>>>'+error);
                    // Inform the user we ran into something unexpected
                    let errorMsg = 'There was a problem scanning the barcode: ' + JSON.stringify(error) + ' Please try again.';
                    this.statusNotification('Barcode Scanner Error',
                                            errorMsg,
                                            'error',
                                            'sticky');
                })
                .finally(() => {
                    this.myScanner.endCapture();
                    if(!this.customError){
                        this.isSpinner = true;      // Spinner      
                    }                                  
                });
        }
        else {
            // Scanner not available
            // Not running on hardware with a scanner
            // Handle with message, error, beep, and so on
            this.customError = true;
            // Let user know they need to use a mobile phone with a camera
            this.statusNotification('Barcode Scanner Is Not Available',
                                    'Try again from the Salesforce app on a mobile device.',
                                    'error',
                                    'dismissible');
        }
    }

    initiateVerificationProcess(scannedpayload){
        if(scannedpayload){
            //Imperative call
            validateQRCode({qrCode: scannedpayload})
            .then(result => {
                this.verifyId = result;
                this.verifyCredentials(this.verifyId);
            })
            .catch(error => {
                this.error = error;
                this.customError = true;
                //this.loginRequired = true;
                // Inform the user we ran into error while verifying
                this.statusNotification('Verification Failed',
                                        this.error,
                                        'error',
                                        'sticky');
            });
        } 
    }

    verifyCredentials(verificationId){
        let self = this;
        // Using Timer function because Platform Event listening doesn't support Salesforce Mobile App
        // Execute the function after time delay - 8 sec delay
        setTimeout(function(){ 
            // Imperative call to verify credential
            verifyCredential({verifyId: verificationId})
            .then(result => {
                self.isSpinner = false;
                let verifyStatus = result;
                if(verifyStatus == 'Verified'){
                    // Notify the verifier -- successfully verified
                    self.statusNotification('Success',
                                            'Verified successfully',
                                            'success',
                                            'sticky');
                } else if(verifyStatus == 'Rejected') {
                    // Notify the verifier -- successfully verified
                    self.statusNotification('Rejected',
                                            'QRCode is not valid, please contact the provider.',
                                            'error',
                                            'sticky');
                } else if(verifyStatus == 'Revoked') {
                    // Notify the verifier -- successfully verified
                    self.statusNotification('Revoked',
                                            'QRCode is revoked, please contact the provider.',
                                            'error',
                                            'sticky');
                } else {
                    // Notify the verifier -- successfully verified
                    self.statusNotification('Failed',
                                            'Unable to verify, please verify after sometime.',
                                            'error',
                                            'sticky');
                } 
            })
            .catch(error => {
                self.error = error;
                self.isSpinner = false;
                // Inform the user we ran into error while updating the record status
                self.statusNotification('Verification Failed',
                                        'Please try again or verify after sometime.',
                                        'error',
                                        'sticky');
            });
         }, 8000);
    }

    // Notification to user
    statusNotification(toastTitle, toastMessage, toastVariant, toastMode){
        this.dispatchEvent(
            new ShowToastEvent({
                title: toastTitle,
                message: toastMessage,
                variant: toastVariant,
                mode: toastMode
            })
        );
    }
}