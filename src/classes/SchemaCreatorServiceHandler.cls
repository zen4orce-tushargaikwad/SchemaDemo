public with sharing class SchemaCreatorServiceHandler {
	string nameFile;
	String[] filelines = new String[]{};
	String[] filecolumns = new String[]{};
	set<string> lstString ;
	Map<string,Map<string,string>> mapCSV = new Map<string,Map<string,string>>();
	List<string> lstMatchedColumns;
	List<string> lstUnMatchedColumns;
	set<String> setFieldType;
	Map<String, String> innerMap1;
	public static Boolean summaryPage;
	
	public List<Selectoption> getAllObjects(){
        map<String,schema.SObjectType> globalDescribe=schema.getGlobalDescribe();
        List<String> objList=new List<String>();
        List<SelectOption> objects=new List<SelectOption>();
        objList.addAll(globalDescribe.keySet());
        Schema.DescribeSObjectResult[] results= Schema.DescribeSObjects(objList);
		objects.add(new selectOption('Select','Select'));
        for(Schema.DescribeSObjectResult res:results){
            if(res.isCreateable() && res.isqueryable() && !res.isCustomSetting() && res.getRecordTypeInfos().size()>0 )
            objects.add(new selectOption(res.getName(),res.getName()));
        }
        return objects;
    }
    
	//returns list<list<String>> for help table    
    public  List<List<String>> cont(){
	    List<FieldTypeDetails__mdt> lstCMTFields=new List<FieldTypeDetails__mdt>();
	    List<String> lstCMT;
	    lstCMTFields=SelectorClass.selectCMTFields();
	    List<List<String>> lstlstCMTFields = new List<List<string>>();
	    for(FieldTypeDetails__mdt f : lstCMTFields)
    	{
        		lstCMT=new List<String>();
		    	lstCMT.add('"'+f.CSVColumnName__c+'"'); 
	    		lstCMT.add('"'+f.ColumnAPIName__c+'"');
    			lstCMT.add('"'+f.DataType__c+'"');
    			lstCMT.add('"'+f.Description__c+'"');
    			lstlstCMTFields.add(lstCMT); 
    	}
    	return lstlstCMTFields;
    }
    
    //for getting xls help Data
    public String parseJSONString() {
		StaticResource sr=SelectorClass.selectStaticResource();
		String body = sr.Body.toString();
	    map<String,String> mapAPIName=new map<String,String>();
	    List<FieldTypeDetails__mdt> MappedColumnName=new List<FieldTypeDetails__mdt>();
	    MappedColumnName=SelectorClass.selectlstColumnAndAPIName();
		for(FieldTypeDetails__mdt mappedColumn1 : MappedColumnName){
			 mapAPIName.put(mappedColumn1.ColumnAPIName__c.trim(), mappedColumn1.CSVColumnName__c.trim());
		}
		string xlsString ='';
		string xlsString1 = mapAPIName.get('fullName')
		+'\\t'+mapAPIName.get('label')
		+'\\t'+mapAPIName.get('length')
		+'\\t'+mapAPIName.get('required')
		+'\\t'+mapAPIName.get('type_x')
		+'\\t'+mapAPIName.get('inlineHelpText')
		+'\\t'+mapAPIName.get('externalId')
		+'\\t'+mapAPIName.get('description')
		+'\\t'+mapAPIName.get('defaultValue')
		+'\\t'+mapAPIName.get('PicklistValue')
		+'\\t'+mapAPIName.get('referenceTo')
		+'\\t'+mapAPIName.get('relationshipName')
		+'\\t'+mapAPIName.get('sorted')
		+'\\t'+mapAPIName.get('unique')
		+'\\t'+mapAPIName.get('summarizedField')
		+'\\t'+mapAPIName.get('summaryForeignKey')
		+'\\t'+mapAPIName.get('summaryOperation')
		+'\\t'+mapAPIName.get('displayFormat')
		+'\\t'+mapAPIName.get('scale')
		+'\\t'+mapAPIName.get('visibleLines')+'\\n';
		// Parse entire JSON response.
		JSONParser parser = JSON.createParser(body);
		while (parser.nextToken() != null) {
			// Start at the array of template.
		    if (parser.getCurrentToken() == JSONToken.START_ARRAY) {
			    while (parser.nextToken() != null) {
			    	// Advance to the start object marker to
			        //  find next row statement object.
		    	    if (parser.getCurrentToken() == JSONToken.START_OBJECT) {
		        		SchemaAttribute inv = (SchemaAttribute)parser.readValueAs(SchemaAttribute.class);
		            	//xlsString +=string.valueOf(inv) ;
			            xlsString1 += inv.fullName+'\\t';
			            xlsString1 += inv.label+'\\t';
			            xlsString1 += inv.length+'\\t';
		    	        xlsString1 += inv.required+'\\t';
		        	    xlsString1 += inv.type_x+'\\t';
		            	xlsString1 +=inv.inlineHelpText+'\\t';
			            xlsString1 +=inv.externalId+'\\t';
			            xlsString1 +=inv.description+'\\t';
			            xlsString1 +=inv.defaultValue+'\\t';
		    	        xlsString1 +=inv.PicklistValue+'\\t';
		        	    xlsString1 +=inv.referenceTo+'\\t';
		            	xlsString1 +=inv.relationshipName+'\\t';
			            xlsString1 +=inv.sorted+'\\t';
			            xlsString1 +=inv.unique+'\\t';
			            xlsString1 +=inv.summarizedField+'\\t';
		    	        xlsString1 +=inv.summaryForeignKey+'\\t';
		        	    xlsString1 +=inv.summaryOperation+'\\t';
		            	xlsString1 +=inv.displayFormat+'\\t';
			            xlsString1 +=inv.scale+'\\t';
			            xlsString1 +=inv.visibleLines+'\\n';
        	           // system.debug('Field Type: ' + inv.FieldType);
            	       // system.debug('decimal : ' + inv.decimalN);   
                	   // String s = JSON.serialize(inv);
	                   //system.debug('Serialized invoice: ' + s);
    	               // Skip the child start array and start object markers.
        	            parser.skipChildren();
            	    }
	            }
    	    }
	    }
  		return xlsString1;
	} 
    public String generateSampleTemplate(){
		//List<FieldTypeDetails__mdt> lstCSVNameMetadata =new List<FieldTypeDetails__mdt>([select CSVColumnName__c from FieldTypeDetails__mdt]);
		set<FieldTypeDetails__mdt> lstCSVNameMetadata=new set<FieldTypeDetails__mdt>();
		lstCSVNameMetadata=SelectorClass.selectAllCSVColumnNames();
        String csvFileString=''; 
		for(FieldTypeDetails__mdt  csvColumnName: lstCSVNameMetadata){  
        	csvFileString += '	'+ csvColumnName.CSVColumnName__c.replace(',','	');
        } 
        csvFileString = csvFileString.trim();
		Blob csvBlob = Blob.valueOf(csvFileString);
        System.debug('String'+csvFileString);
        return csvFileString;
	}
	public String generateHelp()
    {
    	List<FieldTypeDetails__mdt> lstCSVNameMetadata =new List<FieldTypeDetails__mdt>();
    	lstCSVNameMetadata=SelectorClass.selectHelpData();
        String csvFileString=''; 
        system.debug('Help');
        csvFileString +=  'CSVColumnName'+'\\t';
        csvFileString +=  'DataType'+'\\t';
        csvFileString +=  'Description'+'\\n';
		for(FieldTypeDetails__mdt  csvColumnName: lstCSVNameMetadata){  
        	csvFileString += csvColumnName.CSVColumnName__c.replace(',','')+'\\t';
        	csvFileString += csvColumnName.DataType__c.replace(',','')+'\\t';
        	csvFileString += csvColumnName.Description__c.replace(',','	')+'\\n';
        }
        //system.debug('Help csv'+csvFileString); 
        csvFileString = csvFileString.trim();
        return csvFileString;
    }
    public Boolean checkBlankCSV(Blob contentFile){
    	nameFile=contentFile.toString();
        filelines = nameFile.split('\n');
        if(filelines.size()<2){
            return false;
        }
      return true;  	     
    }
    //CSV into MAP<FieldNameAPI,map<ColumnName,RowValue>> Format
    public map<string,map<string,string>> csvToMap(Blob contentFile){
        Map<string,string> innerMap ;
        Integer primaryColumnIndex;
        String primaryColumn;
        List<FieldTypeDetails__mdt> lstPrimaryCSVColumnName=new List<FieldTypeDetails__mdt>();
        lstPrimaryCSVColumnName=SelectorClass.selectPrimaryColumn();
        //for(FieldTypeDetails__mdt ft : [select CSVColumnName__c from FieldTypeDetails__mdt where Primary__c='True']){
        for(FieldTypeDetails__mdt ft : lstPrimaryCSVColumnName){	
        	primaryColumn = String.valueOf(ft.CSVColumnName__c);
        }
        nameFile=contentFile.toString();
        filelines = nameFile.split('\n');
        filecolumns = filelines[0].split(',');
        for(Integer i=0;i<filecolumns.size();i++){
            if(filecolumns[i].equals(primaryColumn)){
                primaryColumnIndex = i;
                break;
            }
        }
        system.debug('File Columns Size'+filecolumns.size());
        system.debug('File Lines Size'+filelines.size());
        for (Integer i=1;i<filelines.size();i++){
                String[] inputvalues = new String[]{};
                inputvalues = filelines[i].split(',');      
            system.debug('input values'+inputvalues);
            system.debug('input values'+inputvalues.size());
                lstString = new set<string>();
                innerMap = new Map<string,string>();
                for(Integer j=0;j<filecolumns.size();j++){
                	lstString.add(filecolumns[j].replaceAll( '\\s+', '')); 
                	innerMap.put(filecolumns[j].trim(),inputvalues[j]);
                }
                mapCSV.put(inputvalues[primaryColumnIndex],innerMap); // remove this harcoding [2] this will come from custom metadata indexed 
            }
            return  mapCSV; 
    }
    //Match CSV column with CMT 
    public Boolean matchedColumnsCSVandCMT(set<string> defineCSVColumnNames){
    	lstMatchedColumns = new List<string>();
        lstUnMatchedColumns = new List<string>();
        for (String columns : lstString) {
    		if (defineCSVColumnNames.contains(columns)) {
        		lstMatchedColumns.add(columns);
    		} else {
        			lstUnMatchedColumns.add(columns);
    			}
			}         
        if(lstUnMatchedColumns.size()>0){
            
            return false;
        }
        return true;
    }
    // Check that all mandatory column are exist for given data types or not ** WIP 
    public Boolean mandatoryColumnCheck(set<string> defineCSVColumnNames,map<string,map<string,string>> mapCSV,map<string,string> mapAPIName,map<string,string> mapMandatoryFields){
        ApexPages.Message errormsg ;
    	List<string> lstMandatoryColumnNotexist = new List<string>();
    	setFieldType = new Set<String>();
    	innerMap1 = new map<string,string>();
    	string mandFields='' ;
    	 for(String fieldApi : mapCSV.keySet()){   
        	  innerMap1 = mapCSV.get(fieldApi);
        	for(String innermapkey : mapCSV.get(fieldApi).keySet()){
        		if(innermapkey==mapAPIName.get('type_x')){
        			 setFieldType.add(mapCSV.get(fieldApi).get(innermapkey));
        		} 
        	}
    	 }
    	 for (string fype:setFieldType ){
    	 	lstMandatoryColumnNotexist = new List<string>();
    	 	mandFields = mapMandatoryFields.get(fype);
    	 		for(String mFiled :mandFields.split(',')){
    	 			if(lstString.contains(mapAPIName.get(mFiled))){
    	 				}
    	 			else{
    	 					lstMandatoryColumnNotexist.add(mapAPIName.get(mFiled));
    	 				}
    	 		}
    	 }
        if(lstMandatoryColumnNotexist.size()>0){
			errormsg = new ApexPages.Message(ApexPages.severity.ERROR,System.Label.MandatoryColumnNotExist+lstMandatoryColumnNotexist);
           	ApexPages.addMessage(errormsg);
			return false;            
        }
       	return true;    
    }
    //Data validation for CSV ** WIP 
    public Boolean dataValidation(map<string,string> mapFieldDataType,map<string,map<string,string>> mapCSV,map<string,string> mapAPIName,map<string,string> mapMandatoryFields){
    	 ApexPages.Message errormsg ;
    	List<string> lstMandatoryColumnNotexist = new List<string>();
    	string mandFields ;
    	 for (string fype:setFieldType ){
    	 	mandFields = mapMandatoryFields.get(fype);
    	 		for(String mFiled :mandFields.split(',')){
    	 			if(lstString.contains(mapAPIName.get(mFiled))){
    			    	String value = innerMap1.get(mapAPIName.get(mFiled));
    					if(mapFieldDataType.get(mapAPIName.get(mFiled))=='Number'){
    						try{
                    			value = value.trim();
                                if(string.isBlank(value))
                                {
                                    value='0';
                                }
    							Integer iValue = Integer.valueOf(value);
    						} catch(Exception e){
    							errormsg = new ApexPages.Message(ApexPages.severity.ERROR,System.Label.DataValidation+' '+mapAPIName.get(mFiled)+' Data '+value);
            					ApexPages.addMessage(errormsg);
            					return false;
    							}
    					}
    						if(mapFieldDataType.get(mapAPIName.get(mFiled))=='Boolean'){
    							if(value.equalsIgnoreCase('true')||value.equalsIgnoreCase('false')||value.equalsIgnoreCase(''))
    								Boolean bValue = Boolean.valueOf(value) ;
    							else{
    								errormsg = new ApexPages.Message(ApexPages.severity.ERROR,System.Label.DataValidation+' '+mFiled +'Data '+value );
            						ApexPages.addMessage(errormsg);
            						return false;
    							}
    						}	
    	 			}
    	 		}
    	 }
    	 return true;
    }
    public Pagereference readFile(Blob contentFile,string nameFile,String selectedObj)
    {
      	summaryPage=true; 
        String objName = selectedObj;
    	 ApexPages.Message errormsg ;
        /* check If CSV is Blank then no need go further return from here */ 
        	if(!checkBlankCSV(contentFile)){
        		errormsg = new ApexPages.Message(ApexPages.severity.ERROR,System.Label.Blank_CSV);
            	ApexPages.addMessage(errormsg);
        		return null;
        	}
 		/* SET contains all Predeifuned columns in metadata */ 
        	Set<string> defineCSVColumnNames = new set<string>();
        	set<FieldTypeDetails__mdt> lstAllCSVColumnNames=new set<FieldTypeDetails__mdt>();
        	lstAllCSVColumnNames=SelectorClass.selectAllCSVColumnNames();
        	for(FieldTypeDetails__mdt ft : lstAllCSVColumnNames){	
        		defineCSVColumnNames.add(String.valueOf(ft.CSVColumnName__c));
        	}
        /* Map for Mandatory fields for field type */
        	Map<string,string> mapMandatoryFields = new Map<string,string>();
        	mapMandatoryFields=SelectorClass.selectMandatoryFields();
        /* Map for column name and their data type */
 			Map<string,string> mapFieldDataType = new Map<string,string>();
 			mapFieldDataType=SelectorClass.selectColumnAndDataType();
       /* */
         	map<String,String> mapAPIName=new map<String,String>();
         	mapAPIName=SelectorClass.selectColumnAndAPIName();
        /* Get CSV data into map in map<FieldAPIName,map<columnName,rowValue>> format */ 
        	Map<string,map<string,string>> mapCSV = csvToMap(contentFile);
        /* Match CSV and custom metadata column names  */
        	if(matchedColumnsCSVandCMT(defineCSVColumnNames)==false){
        		errormsg = new ApexPages.Message(ApexPages.severity.ERROR,System.Label.ColumnNameNotValid+lstUnMatchedColumns);
            	ApexPages.addMessage(errormsg);
        		return null;
       		 }
        /* Check for mandatory Columns */
        if(mandatoryColumnCheck(defineCSVColumnNames,mapCSV,mapAPIName,mapMandatoryFields)==false)
        {
            return null;
        }
        //Data Validation
        if(!dataValidation(mapFieldDataType,mapCSV,mapAPIName,mapMandatoryFields))
        {
        	return null;
        }
  		CustomSchemaBuilder.CSVData(mapCSV,objName);
        return null;    
	}
}