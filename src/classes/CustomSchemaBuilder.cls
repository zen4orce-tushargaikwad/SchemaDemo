public with sharing class CustomSchemaBuilder {
		
		static String objectName{get;set;}
		public List<string> logData{get;set;}
		
    	// Create Text, TextArea and TextAreaLong Fields 
		Public static void CSVData(map<string,map<string,string>> mapfilelds,string objName)
		{
            objectName=objName;
			map<String,String> mapAPIName=new map<String,String>();
			MetadataService.CustomField customAttribute = new MetadataService.CustomField();
			string mapppedColumnName;
        	for(FieldTypeDetails__mdt mappedColumn : [select CSVColumnName__c,ColumnAPIName__c from FieldTypeDetails__mdt where Primary__c='FieldType' ]){
        		mapppedColumnName = mappedColumn.CSVColumnName__c;
        	} 
            for(FieldTypeDetails__mdt mappedColumn1 : [select CSVColumnName__c,ColumnAPIName__c from FieldTypeDetails__mdt]){
                mapAPIName.put(mappedColumn1.ColumnAPIName__c.trim(), mappedColumn1.CSVColumnName__c.trim());
        	}
			for(String fieldApi : mapfilelds.keySet()){     
        	Map<String, String> innerMap1 = mapfilelds.get(fieldApi);
        	customAttribute = CommonOptionValues(innerMap1,objName,mapAPIName);

        	if(innerMap1.get(mapppedColumnName).equalsIgnoreCase('AutoNumber')){
        			customAttribute=createAutoNumer(innerMap1,customAttribute,mapAPIName);
        	}
            else if(innerMap1.get(mapppedColumnName).equalsIgnoreCase('Text')){
        			customAttribute=createTextField(innerMap1,customAttribute,mapAPIName);
        	}
        	else if(innerMap1.get(mapppedColumnName).equalsIgnoreCase('LongTextArea')){
        			customAttribute=createLongTextField(innerMap1,customAttribute,mapAPIName);
        		}
        	else if(innerMap1.get(mapppedColumnName).equalsIgnoreCase('Checkbox')){
        			customAttribute=createCheckbox(innerMap1,customAttribute,mapAPIName);
        		}
        	else if(innerMap1.get(mapppedColumnName).equalsIgnoreCase('MasterDetail')||innerMap1.get(mapppedColumnName).equalsIgnoreCase('Lookup')){
        			customAttribute=createRelatioShip(innerMap1,customAttribute,mapAPIName);
        		}
        	else if(innerMap1.get(mapppedColumnName).equalsIgnoreCase('Number')||innerMap1.get(mapppedColumnName).equalsIgnoreCase('Currency')){
        			customAttribute=createNumber_Currency(innerMap1,customAttribute,mapAPIName);
        		}
        	else if(innerMap1.get(mapppedColumnName).equalsIgnoreCase('EncryptedText')){
        			customAttribute=createEncryptedText(innerMap1,customAttribute,mapAPIName);
        		}
        	else if(innerMap1.get(mapppedColumnName).equalsIgnoreCase('Location')){
        			customAttribute=createLocation(innerMap1,customAttribute,mapAPIName);
        		}
        	else if(innerMap1.get(mapppedColumnName).equalsIgnoreCase('Summary')){
        			customAttribute=createSummary(innerMap1,customAttribute,mapAPIName);
        		}
        	else if(innerMap1.get(mapppedColumnName).equalsIgnoreCase('Picklist')){
        			customAttribute=createPicklist(innerMap1,customAttribute,mapAPIName);
        		}
        	else if(innerMap1.get(mapppedColumnName).equalsIgnoreCase('MultiselectPicklist')){
        			customAttribute=createMultiselectPicklist(innerMap1,customAttribute,mapAPIName);
        		}
        	// Insert Field into Salesforce	
        	CustomSchemaBuilder cd = new CustomSchemaBuilder();							
        	cd.CommitDB(customAttribute);
		}
		}
		public static MetadataService.CustomField createAutoNumer(Map<String, String> innerMap1,MetadataService.CustomField customAttribute,Map<String, String> mapAPIName){
			customAttribute.displayFormat = innerMap1.get(mapAPIName.get('displayFormat'));
        	return customAttribute;
		}	
		public static MetadataService.CustomField createTextField(Map<String, String> innerMap1,MetadataService.CustomField customAttribute,Map<String, String> mapAPIName){
			customAttribute.length = Integer.valueOf(innerMap1.get(mapAPIName.get('length')));
        	customAttribute.defaultValue= innerMap1.get(mapAPIName.get('defaultValue'));
        	return customAttribute;
		}
		public static MetadataService.CustomField createLongTextField(Map<String, String> innerMap1,MetadataService.CustomField customAttribute,Map<String, String> mapAPIName){
			customAttribute.length = Integer.valueOf(innerMap1.get(mapAPIName.get('length')));
        	customAttribute.defaultValue= innerMap1.get(mapAPIName.get('defaultValue'));
            String Vlines = innerMap1.get(mapAPIName.get('visibleLines')); 
        	customAttribute.visibleLines = Integer.valueOf(Vlines.trim()); 
        	return customAttribute;
		}
		public static MetadataService.CustomField createCheckbox(Map<String, String> innerMap1,MetadataService.CustomField customAttribute,Map<String, String> mapAPIName){
        	customAttribute.defaultValue= innerMap1.get(mapAPIName.get('defaultValue'));
        	return customAttribute;
		}
		public static MetadataService.CustomField createRelatioShip(Map<String, String> innerMap1,MetadataService.CustomField customAttribute,Map<String, String> mapAPIName){
        	customAttribute.relationshipLabel = innerMap1.get(mapAPIName.get('relationshipName'));
        	customAttribute.relationshipName = innerMap1.get(mapAPIName.get('relationshipName'));
        	customAttribute.referenceTo = innerMap1.get(mapAPIName.get('referenceTo'));
        	return customAttribute;
		}
		public static MetadataService.CustomField createNumber_Currency(Map<String, String> innerMap1,MetadataService.CustomField customAttribute,Map<String, String> mapAPIName){
            Integer length = Integer.valueOf(innerMap1.get(mapAPIName.get('length')));
            Integer decimalNumber=Integer.valueOf(innerMap1.get(mapAPIName.get('scale')));
            Integer Precn=length+decimalNumber;
            customAttribute.precision = Precn;
        	customAttribute.scale = decimalNumber ;
        	customAttribute.defaultValue= innerMap1.get(mapAPIName.get('defaultValue'));
        	return customAttribute;
		}
		public static MetadataService.CustomField createEncryptedText(Map<String, String> innerMap1,MetadataService.CustomField customAttribute,Map<String, String> mapAPIName){
        	customAttribute.maskChar='X';
        	customAttribute.maskType='All';
        	customAttribute.length = Integer.valueOf(innerMap1.get(mapAPIName.get('length')));
        	return customAttribute;
		}
		public static MetadataService.CustomField createLocation(Map<String, String> innerMap1,MetadataService.CustomField customAttribute,Map<String, String> mapAPIName){
        	customAttribute.displayLocationInDecimal=true;	         
     		customAttribute.scale = Integer.valueOf(innerMap1.get(mapAPIName.get('scale')));
        	return customAttribute;
		}
		public static MetadataService.CustomField createSummary(Map<String, String> innerMap1,MetadataService.CustomField customAttribute,Map<String, String> mapAPIName){
            customAttribute.summarizedField=objectName+'.'+innerMap1.get(mapAPIName.get('summarizedField'));
           	customAttribute.summaryForeignKey=objectName+'.'+innerMap1.get(mapAPIName.get('summaryForeignKey'));
           	String operation = innerMap1.get(mapAPIName.get('summaryOperation'));
            customAttribute.summaryOperation=operation.trim();
        	return customAttribute;
		}
		public static MetadataService.CustomField createPicklist(Map<String, String> innerMap1,MetadataService.CustomField customAttribute,Map<String, String> mapAPIName){
        	String pickListValues = innerMap1.get(mapAPIName.get('PicklistValue'));
        	MetadataService.Picklist pick = new MetadataService.Picklist();
        	List<MetadataService.PicklistValue> sObjectlst = new List<MetadataService.PicklistValue>();
      		pick.sorted = false;
       		pick.picklistValues = new List<MetadataService.PicklistValue>();
        	for (String columns : pickListValues.split('\\|')) {
        		MetadataService.PicklistValue pValue= new MetadataService.PicklistValue();
    	    	pValue.fullName = columns;
        		pValue.default_x = false;
        		sObjectlst.add(pValue);	
        	}
        	for(MetadataService.PicklistValue mp : sObjectlst){
        		pick.picklistValues.add(mp)	;
        	}
        	customAttribute.picklist = pick;
        	return customAttribute;
		}
		public static MetadataService.CustomField createMultiselectPicklist(Map<String, String> innerMap1,MetadataService.CustomField customAttribute,Map<String, String> mapAPIName){
        	customAttribute.visibleLines = 3;
        	String pickListValues = innerMap1.get(mapAPIName.get('PicklistValue'));
        	MetadataService.Picklist pick = new MetadataService.Picklist();
        	List<MetadataService.PicklistValue> sObjectlst = new List<MetadataService.PicklistValue>();
      		pick.sorted = false;
       		pick.picklistValues = new List<MetadataService.PicklistValue>();
        	for (String columns : pickListValues.split('\\|')) {
	        	MetadataService.PicklistValue pValue= new MetadataService.PicklistValue();
    		    pValue.fullName = columns;
        		pValue.default_x = false;
        		sObjectlst.add(pValue);	
        	}
        	for(MetadataService.PicklistValue mp : sObjectlst){
        		pick.picklistValues.add(mp)	;
        	}
        	customAttribute.picklist = pick;
        	return customAttribute;
		}
		public static MetadataService.CustomField CommonOptionValues(Map<String, String> innerMap1,string objName,Map<String, String> mapAPIName){
			MetadataService.CustomField customField1 = new MetadataService.CustomField();
        	customField1.fullName = objName+'.'+innerMap1.get(mapAPIName.get('fullName'));
        	customField1.type_x = innerMap1.get(mapAPIName.get('type_x'));
        	customField1.label = innerMap1.get(mapAPIName.get('label')); 
            customField1.required=(Boolean.valueOf(innerMap1.get(mapAPIName.get('required')))==true)?true:false;
        	customField1.description= innerMap1.get(mapAPIName.get('description'));
        	customField1.inlineHelpText = innerMap1.get(mapAPIName.get('inlineHelpText'));
        	customField1.externalId=(Boolean.valueOf(innerMap1.get(mapAPIName.get('externalId')))==true)?true:false;
        	customField1.unique=(Boolean.valueOf(innerMap1.get(mapAPIName.get('unique')))==true)?true:false;
        	return customField1;
		}
		public void CommitDB(MetadataService.CustomField custom){
			logData = new List<String>();
		try{	
			MetadataService.MetadataPort service = createService();    
         	List<MetadataService.SaveResult> results =
            service.createMetadata(
                new MetadataService.Metadata[] { custom });
        	handleSaveResults(results[0]);
            ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM,'Record Created Successfully.Thank you!'));
        	
		}
		catch(Exception e)
		{
			logData.add(String.valueOf(e.getMessage()));
            ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'FieldName '+custom.fullName+' is not created Reason : '+e.getMessage()));
		}
			
		}
		   
   // Method for handle exception 
 public class MetaDataAPIExamplesException extends Exception { }
   // Method for creating connection and session
    public static MetadataService.MetadataPort createService(){
        MetadataService.MetadataPort service = new MetadataService.MetadataPort();
        service.SessionHeader = new MetadataService.SessionHeader_element();
        service.SessionHeader.sessionId = UserInfo.getSessionId();
        return service;
    }
    
     /**
     * Example helper method to interpret a SaveResult, throws an exception if errors are found
     **/
    public static void handleSaveResults(MetadataService.SaveResult saveResult) {
        // Nothing to see?
        if(saveResult==null || saveResult.success)
            return;
        // Construct error message and throw an exception
        if(saveResult.errors!=null){
            List<String> messages = new List<String>();
            messages.add(
                (saveResult.errors.size()==1 ? 'Error ' : 'Errors ') +
                    'occured processing component ' + saveResult.fullName + '.');
            for(MetadataService.Error error : saveResult.errors)
                messages.add(
                    error.message + ' (' + error.statusCode + ').' +
                    ( error.fields!=null && error.fields.size()>0 ?
                        ' Fields ' + String.join(error.fields, ',') + '.' : '' ) );
            if(messages.size()>0)
                throw new MetaDataAPIExamplesException(String.join(messages, ' '));
        }
        if(!saveResult.success)
            throw new MetaDataAPIExamplesException('Request failed with no specified error.'+saveResult);
    }
    

    
    
      public static final Map<DisplayType, String> FLOWTYPEBYDISPLAYTYPE = 
            new Map<DisplayType, String>{ 
                DisplayType.anytype => 'String',
                DisplayType.base64 => 'String',
                DisplayType.Boolean => 'Boolean', 
                DisplayType.Combobox => 'String',
                DisplayType.Currency => 'Currency',
                DisplayType.Date => 'Date',
                DisplayType.DateTime => 'DateTime', 
                DisplayType.Double => 'Number',
                DisplayType.Email => 'String',
                DisplayType.EncryptedString => 'String',
                DisplayType.Id => 'String',
                DisplayType.Integer => 'Number',
                DisplayType.MultiPicklist => 'Multipicklist',
                DisplayType.Percent => 'Number', 
                DisplayType.Phone => 'String',
                DisplayType.Picklist => 'Picklist',
                DisplayType.Reference => 'Reference',
                DisplayType.String => 'String',
                DisplayType.TextArea => 'String',
                DisplayType.Time => 'String',
                DisplayType.URL => 'String'};
  

	

}