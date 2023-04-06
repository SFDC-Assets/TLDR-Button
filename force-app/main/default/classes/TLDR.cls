public class TLDR {    
    
    @AuraEnabled(cacheable=true)
    public static String go(Id providedId){ 
        String result = '';
        // See helper method below - fetches requested field based on metadata
        String ourDerivedField = TLDR.deriveFieldFromMetadata(providedId);
        
        JSONGenerator gen = JSON.createGenerator(true);
        gen.writeStartObject();
        gen.writeStringField('content', ourDerivedField);
        gen.writeEndObject();
        Http http = new Http();
        HttpRequest request = new HttpRequest();
	request.setTimeout(30000);
        request.setEndpoint('http://gpt-sapi.us-e2.cloudhub.io/api/summarize');
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json');
        request.setBody(gen.getAsString());
        HttpResponse response = http.send(request);       
        if(response.getStatusCode() == 200) {
            Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
            result = (String)results.get('summary'); 
        }
        System.debug(result);
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
	// Return it back to the main TLDR class; also strip away any tags if it was a rich text field alternative below optional (as done in MuleSoft)    
        return ourDerivedField;
        //return ourDerivedField.stripHtmlTags(); 
    }
        
}
