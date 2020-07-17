public class TLDR {    
    
    @AuraEnabled(cacheable=true)
    public static String go(Id providedId){ 
        // See helper method below - fetches requested field based on metadata
        String ourDerivedField = TLDR.deriveFieldFromMetadata(providedId);
        // Default sentences TLDR summarizes for        
        Integer mySummaryTotal = 5;
        // Override TLDR default sentence amount if need be
        List<TLDR_Setting__mdt> myNewSummaryTotal = [SELECT DeveloperName, Summary__c, Amount_If_Text_Is_Small__c, Small_Text_Character_Amount__c FROM TLDR_Setting__mdt WHERE DeveloperName = 'TLDR' LIMIT 1];
        /*
         * Reference above metadata type query to see the logic
         * If the text is "small", then summarize it in metadata type outlined amount of sentences sentences: Amount_If_Text_Is_Small__c
         * What is "small" - that's the amount of characters defined by metadata type's Small_Text_Character_Amount__c
         * If it's not small, then use the metadata type's Summary__c field
         * FYI: Defaults for metadata type are placed in and are required anyway
         * Small = less than or equal to 1000 characters because that's about the size of 3 tweets (280 max characters * 5)
         */ 
        if(myNewSummaryTotal.size() > 0){
            if(ourDerivedField.length() <= Integer.valueOf(myNewSummaryTotal[0].Small_Text_Character_Amount__c)){
                mySummaryTotal = Integer.valueOf(myNewSummaryTotal[0].Amount_If_Text_Is_Small__c);
            } else {
                mySummaryTotal = Integer.valueOf(myNewSummaryTotal[0].Summary__c);
            }
        } else {
            // Below is a safeguard if someone misuses the metadata type :) 
            // If nothing is specified, anything at 1000 or less characters gets summed to 3 sentences
            // And anything longer than that gets summed to 5 sentences (which is the default as per above)
            if (ourDerivedField.length() <= 1000){
                mySummaryTotal = 3;
            }
        }

		// Request/response with API & etc
		JSONGenerator gen = JSON.createGenerator(true);
        gen.writeStartObject();
        gen.writeStringField('givenInput', ourDerivedField);
        gen.writeStringField('givenLength', String.valueOf(mySummaryTotal));
		gen.writeEndObject();
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://tldr-parser.herokuapp.com/provide_summary');
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json;charset=UTF-8');
        request.setBody(gen.getAsString());
        HttpResponse response = http.send(request);        
        String result = (String)response.getBody();
        return result;        
    }

    public static String deriveFieldFromMetadata(Id providedId){
        // Get object in scope
        String objectInScope = providedId.getSObjectType().getDescribe().getName();
        // Find where it matches metadata
        TLDR__mdt myTLDRLocation = [SELECT Object_Name__c, Field_Name__c FROM TLDR__mdt WHERE Object_Name__c = :objectInScope LIMIT 1];
        // Field used to TLDR        
        String fieldInScope = myTLDRLocation.Field_Name__c;
        // Query based on Field we grabbed above
        String ourQuery = 'SELECT Id, ' + fieldInScope + ' FROM ' + objectInScope + ' WHERE Id = ' + '\'' + providedId + '\'' + ' LIMIT 1';
        // Query result as an SObject
        SObject ourData = Database.query(ourQuery);
        // Represent the above result as a map
        Map<String,Object> mapOutput = ourData.getPopulatedFieldsAsMap();
        //Derive the field in scope with its actual value
        String ourDerivedField = String.valueOf(mapOutput.get(fieldInScope));
        // Return it back to the main TLDR class; also strip away any tags if it was a rich text field
        return ourDerivedField.stripHtmlTags();
    }
        
}