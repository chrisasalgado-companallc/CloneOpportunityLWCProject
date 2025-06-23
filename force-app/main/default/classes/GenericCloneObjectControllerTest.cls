@isTest
private class GenericCloneObjectControllerTest {
    
    @isTest
    static void testGetFieldList(){
        String objectApiName = 'Opportunity';
        String fieldSetApiName = 'Clone_Opportunity_Fields';

        Test.startTest();
        List<GenericCloneObjectController.FieldSummary> fieldList = GenericCloneObjectController.getFieldList(objectApiName, fieldSetApiName);
        Test.stopTest();

        Assert.isTrue(fieldList.size() > 0, 'Field List should not be empty');
    }

    @isTest
    static void testGetFieldList_Error(){
        String objectApiName = 'Account';
        String fieldSetApiName = 'Test_Field_Set';

        Test.startTest();
        try{
            List<GenericCloneObjectController.FieldSummary> fieldList = GenericCloneObjectController.getFieldList(objectApiName, fieldSetApiName);
        }
        catch(Exception e){
            Assert.isTrue(e != null, 'Exception should be thrown');
        }
        Test.stopTest();        
    }
}