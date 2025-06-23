/**
 * @name: Chris Salgado
 * @date: 6/20/2025
 * @description: LWC Controller for fetching child data and saving new child objects
 */
public with sharing class GenericCloneChildObjectController {

    public class TableColumn {
        @AuraEnabled
        public String label {get; set;}
        @AuraEnabled
        public String fieldName {get; set;}
        @AuraEnabled
        public String type {get; set;}
    }

    /**
     * @description Gets a List of Column Headers for the Table of Children records
     * @param childObjectApiName - String of the child object name
     * @param childFieldSetApiName - String of the field set name
     */
    @AuraEnabled(cacheable=true)
    public static List<TableColumn> getTableColumns(String childObjectApiName, String childFieldSetApiName) {
        try {
            List<TableColumn> tableColumnList = new List<TableColumn>();
            
            for(Schema.FieldSetMember member: UtilityClass.getDescribeSObjectResult(childObjectApiName).fieldSets.getMap().get(childFieldSetApiName).getFields()){
                if (member.getLabel() != 'Record Id') {
                    TableColumn tc = new TableColumn();
                    tc.label = member.getLabel();
                    tc.fieldName = member.getFieldPath();
                    tc.type = String.valueOf(member.getType()).toLowerCase();
                    tableColumnList.add(tc);
                }    
            }

            return tableColumnList;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    /**
     * @description Gets a List of Column Headers for the Table of Children records
     * @param parentId - Id of the parent record
     * @param childObjectApiName - String of the child object name
     * @param childColumns - List of table columns from child table
     * @param parentRelationshipField - String of the relationship field name
     */
    @AuraEnabled(cacheable=true)
    public static List<SObject> getChildren(Id parentId, String childObjectApiName, List<TableColumn> childColumns, String parentRelationshipField) {
        try{            
            List<SObject> objList = new List<SObject>();

            Set<String> childrenFields = new Set<String>{'Id'};
            for (TableColumn tempColumn : childColumns) {            
                if(tempColumn.fieldName != null){
                    childrenFields.add(tempColumn.fieldName);
                }
            }

            String queryString = 'SELECT ' + String.join(new List<String>(childrenFields), ',') + ' FROM ' + childObjectApiName + ' WHERE ' + parentRelationshipField + ' = \'' + parentId + '\'';                    
            objList = Database.query(queryString);
            return objList;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage() + ' - ' + e.getStackTraceString());
        }
    }

    /**
     * @description Create Children records
     * @param newParentId - Id of the newly created parent record
     * @param selectedRows - List of children records to clone     
     */
    @AuraEnabled
    public static void createChildren(Id newParentId, List<SObject> selectedRows, String parentRelationship, Map<String, List<String>> includeExcludeFieldsMap){
        if(newParentId == null){
            throw new AuraHandledException('No Parent Id Provided');
        }

        try {
            List<SObject> clonedChildren = UtilityClass.cloneChildren(newParentId, selectedRows, parentRelationship, includeExcludeFieldsMap);            
            if(clonedChildren.size() > 0){
                insert clonedChildren;
            }
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage() + ' - ' + e.getStackTraceString());
        }
    }
}