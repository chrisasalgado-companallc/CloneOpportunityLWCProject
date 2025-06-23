import { LightningElement, api } from 'lwc';
import { showToast } from 'c/utility';

export default class CloneOpportunityButton extends LightningElement {
    @api recordId;
    newRecordId;
    objectApiName = 'Opportunity';
    objectFieldSetApiName = 'Clone_Opportunity_Fields';
    childObjectApiName = 'OpportunityLineItem';
    childTableLabel = 'Opportunity Products';
    childFieldSetApiName = 'Clone_Opportunity_Product_Fields';
    parentRelationshipField = 'OpportunityId';
    excludeFields = ['totalprice'];
    includeFields = ['pricebookentryid'];

    get includeExcludeFieldsMap() {
        return {
            include: this.includeFields,
            exclude: this.excludeFields
        };
    }

    handleSaveButton() {
        console.log('SAVE');
        this.template.querySelector('c-generic-clone-object').saveObject();        
    }

    handleSave(event) {
        console.log('SAVE EVENT');
        this.newRecordId = event.detail;
        this.template.querySelector('c-generic-clone-child-object').createChildren(this.newRecordId);
    }

    handleError(event) {
        console.log('ERROR EVENT');
        showToast(this, 'Error', event.detail, 'error', 'dismissible');
    }

    handleDone(event) {
        console.log('DONE EVENT');
        showToast(this, 'Success', 'Opportunity & Opportunity Products Cloned!', 'success', 'dismissible');
    }

}