# TL;DR

*TL;DR Button! Summarizes content on any record on any field.* Fully declarative control - turnkey plug & play, drag this button on your page layout and specify the brevity you prefer. Default is it summarizes the text you’re reading in 5 sentences unless the text is small in nature, in which it will be 3 sentences max. You can override these defaults declaratively. Uses LexRank algorithm & general natural language facility to find you the most relevant sentences and create a TL;DR summary. If you’re not familiar with the lingo, TL;DR means Too Long; Didn’t Read and is used as a way to provide a summary. Below are details - with captured screenshots of it in action, how you can plug it in, and how it works. It’s also a practical way to quickly articulate an example of integration and how Heroku enriches Salesforce core.

*Screenshots of this in action*
Click me (https://docs.google.com/presentation/d/1Rj_iVlcAmnthU0MN_kLjfPRaDXDoFQC4j0irPLhuymE/edit?usp=sharing). Screenshots show Case description, Email body, and task description be summarized. Think of how many times we can use that. Whether it’s you’re short on time before a meeting that’s about to start or you’re an exec and you want to summarize opportunity/task/logged-email to help you make a decision. Or if you’re helping triage a case and you want to get a quick gist because perhaps it’s best for someone else to take over it. Matter of fact, sharing this with Business Technology. I think something like this (in some form or fashion) could be a great use-case for us for our own Salesforce org!

*How You Can Plug It In & Downloads*
How to Plug it in: https://salesforce.quip.com/8B2NAWbLjoiA
Download: https://q-demo-components.herokuapp.com/#/demo-component/a012M00000h1cXdQAI
Alternative Download (if you prefer the source code):
TL;DR Button (SF): this is it
TL;DR Service (Heroku): (to update shortly)

*How it works*
_LexRank itself_.  
LexRank NPM package source code: https://github.com/linanqiu/lexrank 
About LexRank: https://www.aaai.org/Papers/JAIR/Vol22/JAIR-2214.pdf

_How was it built_. When you click the TL;DR button it invokes LWC. LWC does a REST callout. Based on your configured settings, it will fetch the desired field for the end user and do a REST Callout to my hosted NodeJS Heroku service, the service applies LexRank using LexRank npm package and replies back with the summary to your end user in the LWC. Note that I had to put in a tiny Aura shim since LWC still can’t be invoked as a global action (will remove the Aura shim whenever that can happen organically). Also note that I decided to host the Heroku service rather than requiring you to spin one up. Saves you time. You’re welcome. Also, a disclaimer that the summarization itself may not always be perfect. But it’s pretty useful. Always rely on the full text for full assurance.

Inspired by my need to dig myself out of emails/communication from coming back from my OOO. If I have free time (irony), thinking of making this:

