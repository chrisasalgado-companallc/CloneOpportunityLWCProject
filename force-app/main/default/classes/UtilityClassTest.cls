/**
 * @name: Chris Salgado
 * @date: 6/20/2025
 * @description: LWC Controller for fetching form data
 */
@isTest
private class UtilityClassTest {

    @isTest
    static void getDescribeSObjectResultTest() {
        Test.startTest();
        DescribeSObjectResult dsr = UtilityClass.getDescribeSObjectResult('Account');
        Test.stopTest();

        Assert.isNotNull(dsr, 'Method did not return a non null DescribeSObjectResult');
    }

    @isTest
    static void cloneChildrenTest(){
        Opportunity testOpp = TestFactory.createOpportunity('Test Opportunity', 'Prospecting', true);
        Product2 testProd = TestFactory.createProduct('Test Product', true);
        PricebookEntry testPBE = TestFactory.createPricebookEntry(Test.getStandardPricebookId(), testProd.Id, 10.00, true);
        OpportunityLineItem testOLI = TestFactory.createOpportunityLineItem(testOpp.Id, testPBE.Id, 1, 20.00, true);

        Test.startTest();
        Opportunity testOpp2 = TestFactory.createOpportunity('Test Opportunity 2', 'Prospecting', true);
        List<SObject> oppLineItemList = new List<SObject>{testOLI};
        String parentRelationshipField = 'OpportunityId';
        Map<String, List<String>> includeExcludeFieldsMap = new Map<String, List<String>>();
        includeExcludeFieldsMap.put('exclude', new List<String>{'createddate'});
        includeExcludeFieldsMap.put('include', new List<String>{'id'});
        List<SObject> clonedChildren = UtilityClass.cloneChildren(testOpp2.Id, oppLineItemList, parentRelationshipField, includeExcludeFieldsMap);
        Test.stopTest();

        Assert.isTrue(clonedChildren.size() > 0, 'Cloned children should be returned');
    }
}