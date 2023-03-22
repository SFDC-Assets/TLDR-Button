# TL;DR - Easily invokable experience that uses GPT for Summarization

*TL;DR Button! Summarizes content on any record on any field.* Fully declarative control - turnkey plug & play, drag this button on your page layout and you now have the ability to use GPT to help summarize data! If you’re not familiar with the lingo, TL;DR means Too Long; Didn’t Read and is used as a way to provide a summary.

*Do these **two small steps BEFORE** the install (1-min)*
- (1) Add a Remote Site Setting (Setup >> Remote Site Setting >> New). Call it GPT. And use this URL: http://gpt-sapi.us-e2.cloudhub.io. Click Save.
- (2) From Setup go to Custom Metadata Types and create one called TLDR (API name has to be TLDR__mdt). Add these 2 fields: Field Name (API name has to be Field_Name__c) and Object Name (API name has to be Object_Name__c). Mark Object Name field as Unique Case Insensitive.

*Disclaimer:* code is as-is and is intended for learning/demonstration purposes only. It is not to be used for implementation.

*Instructions on setup (1-min)* 
- (1) Go to Setup >> Custom Metadata Types >> find one called TLDR. Now, click into it and click "Manage TLDR." From there, add the object and its field you want to summarize within a record. Popular examples are as follows: Object: Task / Field Name: Description. Object: Case / Field Name: Description. Object: EmailMessage / Field Name: TextBody
- (2) Setup >> Global Actions >> New Action. Call this "Summarize" or whatever you'd like. Action Type: Lightning Component. Lightning Component: pick "c:TLDR_go." Height: go with 250px. Label: "Summarize." Now, you're able to drag this on any record page via Page Layouts - look for "Summarize" under Lightning Actions and drag it over. And based on what you did in Custom Metadata Types, it will listen to the Object you dragged it on and summarize the field in there. Example --> Object: Task / Field Name: Description

## Maintainers
- Arastun Russ Efendiyev
- Joel Davenport
