import { LightningElement, api } from 'lwc';
import GET_TABLE_COLUMNS from '@salesforce/apex/GenericCloneChildObjectController.getTableColumns';
import GET_CHILDREN from '@salesforce/apex/GenericCloneChildObjectController.getChildren';
import CREATE_CHILDREN from '@salesforce/apex/GenericCloneChildObjectController.createChildren';

export default class GenericCloneChildObject extends LightningElement {
    @api recordId;
    @api tableLabel;
    @api childObjectApiName;
    @api childFieldSetApiName;
    @api parentRelationshipField;
    @api includeExcludeFieldsMap;
    columns;
    childrenData = [];

    connectedCallback(){
        this.loadData();
    }

    async loadData(){
        try{
            this.columns = await GET_TABLE_COLUMNS({childObjectApiName: this.childObjectApiName, childFieldSetApiName: this.childFieldSetApiName});
            console.log("TABLE COLUMNS DATA: ", this.columns);
            this.childrenData = await GET_CHILDREN({parentId: this.recordId, childObjectApiName: this.childObjectApiName, childColumns: this.columns, parentRelationshipField: this.parentRelationshipField});
            console.log("CHILDREN DATA: ", this.childrenData);
        }
        catch(error){
            console.log("ERROR: ", error);
            const errorEvent = new CustomEvent('error', { detail: 'Error Loading Opportunity Products'});
            this.dispatchEvent(errorEvent);
        }
    }

    @api
    async createChildren(pushNewRecordId){        
        const dataTable = this.template.querySelector("lightning-datatable");
        //Create Children if Rows Selected
        if (dataTable.getSelectedRows().length > 0) {
            console.log('Create Children');
            try{
            await CREATE_CHILDREN({newParentId: pushNewRecordId, selectedRows: dataTable.getSelectedRows(), parentRelationship: this.parentRelationshipField, includeExcludeFieldsMap: this.includeExcludeFieldsMap});
            //Dispatch done event
            let doneEvent = new CustomEvent('done');
            this.dispatchEvent(doneEvent);
            } catch(error){
                console.log("ERROR: ", error);
                const errorEvent = new CustomEvent('error', { detail: 'Error Creating Opportunity Products'});
                this.dispatchEvent(errorEvent);
            }
        } else {
            console.log('No Children to Create');
            //Dispatch done event
            let doneEvent = new CustomEvent('done');
            this.dispatchEvent(doneEvent);
        }
    }
}