import { LightningElement, api, wire, track } from 'lwc';
import go from '@salesforce/apex/TLDR.go';

export default class TLDR extends LightningElement {    

    @api providedId;    

    @wire(go, {providedId: '$providedId'}) 
    mySummary;    
}