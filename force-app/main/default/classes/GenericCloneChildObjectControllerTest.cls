@isTest
private class GenericCloneChildObjectControllerTest {

    @isTest
    static void getTableColumnsTest() {
        String childObjectApiName = 'OpportunityLineItem';
        String childFieldSetApiName = 'Clone_Opportunity_Product_Fields';

        Test.startTest();
        List<GenericCloneChildObjectController.TableColumn> tableColumnList = GenericCloneChildObjectController.getTableColumns(childObjectApiName, childFieldSetApiName);
        Test.stopTest();

        Assert.isTrue(tableColumnList.size() > 0, 'Table Columns should be returned.');
    }

    @isTest
    static void getTableColumnsTest_Error() {
        String childObjectApiName = 'Account';
        String childFieldSetApiName = 'Test_Field_Set';

        Test.startTest();
        try{
            List<GenericCloneChildObjectController.TableColumn> tableColumnList = GenericCloneChildObjectController.getTableColumns(childObjectApiName, childFieldSetApiName);
        }
        catch(Exception e){
            Assert.isTrue(e != null, 'Exception should be thrown');
        }
        Test.stopTest();
    }

    @isTest
    static void getChildrenTest(){
        String childObjectApiName = 'OpportunityLineItem';
        String childFieldSetApiName = 'Clone_Opportunity_Product_Fields';
        List<GenericCloneChildObjectController.TableColumn> tableColumnList = GenericCloneChildObjectController.getTableColumns(childObjectApiName, childFieldSetApiName);

        Opportunity testOpp = TestFactory.createOpportunity('Test Opportunity', 'Prospecting', true);
        Product2 testProd = TestFactory.createProduct('Test Product', true);
        PricebookEntry testPBE = TestFactory.createPricebookEntry(Test.getStandardPricebookId(), testProd.Id, 10.00, true);
        OpportunityLineItem testOLI = TestFactory.createOpportunityLineItem(testOpp.Id, testPBE.Id, 1, 20.00, true);

        Test.startTest();
        List<sObject> childrenList = GenericCloneChildObjectController.getChildren(testOpp.Id, 'OpportunityLineItem', tableColumnList, 'OpportunityId');        
        Test.stopTest();

        Assert.isTrue(childrenList.size() > 0, 'No children returned.');
    }

    @isTest
    static void createChildrenTest(){
        Opportunity testOpp = TestFactory.createOpportunity('Test Opportunity', 'Prospecting', true);
        Product2 testProd = TestFactory.createProduct('Test Product', true);
        PricebookEntry testPBE = TestFactory.createPricebookEntry(Test.getStandardPricebookId(), testProd.Id, 10.00, true);
        OpportunityLineItem testOLI = TestFactory.createOpportunityLineItem(testOpp.Id, testPBE.Id, 1, 20.00, true);

        Test.startTest();
        Opportunity testOpp2 = TestFactory.createOpportunity('Test Opportunity 2', 'Prospecting', true);
        List<SObject> oppLineItemList = new List<SObject>{testOLI};
        String parentRelationshipField = 'OpportunityId';
        Map<String, List<String>> includeExcludeFieldsMap = new Map<String, List<String>>();
        includeExcludeFieldsMap.put('exclude', new List<String>{'totalprice'});
        includeExcludeFieldsMap.put('include', new List<String>{'pricebookentryid'});     
        GenericCloneChildObjectController.createChildren(testOpp2.Id, oppLineItemList, parentRelationshipField, includeExcludeFieldsMap);
        Test.stopTest();

        List<OpportunityLineItem> clonedOLIList = [SELECT Id FROM OpportunityLineItem WHERE OpportunityId = :testOpp2.Id];
        Assert.isTrue(clonedOLIList.size() > 0, 'No Opportunity Line Items cloned.');
    }
}