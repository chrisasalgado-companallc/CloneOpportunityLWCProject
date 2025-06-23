import { LightningElement, api, wire } from 'lwc';
import GET_FIELD_LIST from "@salesforce/apex/GenericCloneObjectController.getFieldList";

export default class GenericCloneObject extends LightningElement {    
    @api recordId;
    @api objectApiName;
    @api objectFieldSetApiName;
    newRecordId;
    fieldList_leftSection = [];
    fieldList_rightSection = [];

    @wire(GET_FIELD_LIST, {
        objectApiName: "$objectApiName",
        fieldSetApiName: "$objectFieldSetApiName"
    })
    getFieldList({error, data}){
        if (error) {
            console.log("ERROR: ", error);
        } else if (data === undefined) {
            console.log("FIELD LIST DATA: undefined");
        } else {
            console.log("FIELD LIST DATA: ", data);
            let halfDataLength = data.length / 2;
            this.fieldList_leftSection = data.slice(0, halfDataLength);
            this.fieldList_rightSection = data.slice(halfDataLength, data.length);
        }
    }

    @api
    saveObject() {
        this.template.querySelector('[data-id="create_button"]').click();
    }

    //Triggered by Create Button click
    submitHandler(event) {
        event.preventDefault();        
        //Submit the dummy form with the data from edit form
        const createForm = this.template.querySelector('[data-id="dummy_form"]');
        createForm.submit(event.detail.fields);
    }

    successHandler(event) {
        this.newRecordId = event.detail.id;
        const saveEvent = new CustomEvent('save', { detail: this.newRecordId });
        this.dispatchEvent(saveEvent);
    }
    
    errorHandler(event) {
        const errorEvent = new CustomEvent('error', { detail: 'Error Creating Opportunity'});
        this.dispatchEvent(errorEvent);
    }
}