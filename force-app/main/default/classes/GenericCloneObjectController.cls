/**
 * @name: Chris Salgado
 * @date: 6/20/2025
 * @description: LWC Controller for fetching form data
 */
public with sharing class GenericCloneObjectController {
    
    public class FieldSummary{
        @AuraEnabled
        public Integer keyValue {get; set;}
        @AuraEnabled
        public String fieldApiName {get; set;}
        @AuraEnabled
        public String objectApiName {get; set;}      
    }

    /**
     * @description Gets a List of Fields for the Edit Form from a Field Set
     * @param objectApiName - String of the object name
     * @param fieldSetApiName - String of the field set name
     */
    @AuraEnabled(cacheable=true)
    public static List<FieldSummary> getFieldList(String objectApiName, String fieldSetApiName){
        try {   
            Integer counter = 1;
            List<FieldSummary> fieldSummaryList = new List<FieldSummary>();
            
            for(Schema.FieldSetMember member: UtilityClass.getDescribeSObjectResult(objectApiName).fieldSets.getMap().get(fieldSetApiName).getFields()){
                FieldSummary fs = new FieldSummary(); 
                fs.fieldApiName = member.getFieldPath();
                fs.objectApiName = objectApiName;
                fs.keyValue = counter;
                fieldSummaryList.add(fs);
                counter = counter+1;
            }

            return fieldSummaryList;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}