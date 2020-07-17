@isTest
public class TLDR_Test {

    @isTest
    public static void TestTLDR(){
        Case c = new Case();
        c.Status = 'New';
        c.Origin = 'Email';
        c.Subject = 'XYX Issue';
        c.Description = 'Hi. Hello. Hi Again. Bye. Bye Bye. Oh Hello.';
        insert c;
        TLDR myTLDR = new TLDR();
        System.assertEquals(TLDR.deriveFieldFromMetadata(c.Id), c.Description);
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new TLDRCalloutMock()); 
        Test.stopTest();
        String response = TLDR.go(c.Id);
        System.assertEquals(response, 'Hi');
    }
    
}