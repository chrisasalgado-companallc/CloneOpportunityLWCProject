/**
 * @name: Chris Salgado
 * @date: 6/20/2025
 * @description: Reusable utility methods for Apex Classes
 */
public inherited sharing class UtilityClass {
    /**
     * @description Gets the Type of SObject from the provided SObject Name, creates a new instance of the SObject, and casts it to the generic SObject Type then gets the SObject Type Token
     * Returns the DescribeSObjectResult of the derived SObject Type Token
     * @param objectApiName - String of the object name
     * @return DescribeSObjectResult - Object description of the SObject Type
     */
    public static DescribeSObjectResult getDescribeSObjectResult (String objectApiName){        
        SObjectType sObjType = ((SObject) Type.forName(objectApiName).newInstance()).getSObjectType();
        //DEFERRED - Lazy-load child relationships; do not load all child relationships at the time of first invocation of the method.
        return sObjType.getDescribe(SObjectDescribeOptions.DEFERRED);
    }

    /**
     * @description Clones records and changes the related Parent record
     * @param newParentId - Id of the new parent record
     * @param originalChildren - List of records to clone
     * @param parentRelationshipField - String of the relationship field name
     * @return List<SObject> - List of cloned records
     */
    public static List<SObject> cloneChildren(Id newParentId, List<SObject> originalChildren, String parentRelationshipField, Map<String ,List<String>> includeExcludeFieldsMap){                
        List<String> excludeFields = includeExcludeFieldsMap.get('exclude');
        List<String> includeFields = includeExcludeFieldsMap.get('include');
        
        //Get List of Child Ids for query
        List<String> childrenIds = new List<String>();
        for (sObject tempObj : originalChildren) {
            childrenIds.add('\'' + String.valueOf(tempObj.Id) + '\'');
        }
        
        //Check if object is NOT editable
        Schema.DescribeSObjectResult childObjDescribeResult = originalChildren[0].getSObjectType().getDescribe();
        if(!childObjDescribeResult.isUpdateable()){
            throw new System.NoAccessException();
        }

        //Get Name of object
        String childObjectName = childObjDescribeResult.getName();

        //Get editable fields to query
        Map<String, Schema.SObjectField> fieldMap = childObjDescribeResult.fields.getMap();
        
        List<String> writableFieldApiNames = new List<String>();
        for (String fieldApiName : fieldMap.keySet()) {
            //Get DescribeFieldResult for each field
            Schema.DescribeFieldResult fieldDescribe = fieldMap.get(fieldApiName).getDescribe();
            //Check if field is editable and NOT on exclusion list
            if ((fieldDescribe.isCreateable() && !excludeFields.contains(fieldApiName)) || includeFields.contains(fieldApiName)) {
                writableFieldApiNames.add(fieldApiName);
            }            
        }

        //Query for original full records
        String queryString = 'SELECT ' + String.join(writableFieldApiNames, ',') +' FROM ' + childObjectName + ' WHERE Id IN (' + String.join(childrenIds, ',') + ')';
        List<SObject> fullRecords = Database.query(queryString);

        //Clone records
        List<SObject> clonedChildren = new List<SObject>();
        for(SObject tempObj : fullRecords){            
            SObject clonedChild = tempObj.clone(false, true, false, false);
            clonedChild.put(parentRelationshipField, newParentId);
            clonedChildren.add(clonedChild);
        }

        return clonedChildren;
    }
}