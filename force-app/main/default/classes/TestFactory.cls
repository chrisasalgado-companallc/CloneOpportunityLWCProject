/**
 * @name: Chris Salgado
 * @date: 6/21/2025
 * @description: Test data factory class
 */
@isTest
public class TestFactory {
    
    public static Account createAccount(String name, Boolean toInsert) { 
        Account acct = new Account(Name = name);
        if(toInsert) {
            insert acct;
        }
        return acct;
    }

    public static Opportunity createOpportunity(String name, String stage, Boolean toInsert) { 
        Opportunity opp = new Opportunity(
            Name = name,
            StageName = stage,
            CloseDate = Date.today() + 7
        );
        if(toInsert) {
            insert opp;
        }
        return opp;
    }

    public static Product2 createProduct(String name, Boolean toInsert) { 
        Product2 product = new Product2(Name = name);
        if(toInsert) {
            insert product;
        }
        return product;
    }

    public static PricebookEntry createPricebookEntry(Id pricebookId, Id productId, Decimal price, Boolean toInsert) {
        PricebookEntry pbe = new PricebookEntry(
            IsActive = true,
            Product2Id = productId,
            Pricebook2Id = pricebookId,
            UnitPrice = price            
        );
        if(toInsert) {
            insert pbe;
        }
        return pbe;        
    }

    public static OpportunityLineItem createOpportunityLineItem(Id oppId, Id pricebookEntryId, Integer qty, Decimal price, Boolean toInsert){
        OpportunityLineItem oppLineItem = new OpportunityLineItem(
            OpportunityId = oppId,
            PricebookEntryId = pricebookEntryId,
            Quantity = qty,
            UnitPrice = price
        );
        if(toInsert) {
            insert oppLineItem;
        }
        return oppLineItem;
    }
}