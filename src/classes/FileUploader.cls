public class FileUploader 
{
    public static Boolean summaryPage{get;set;}
    public String base64Value{get;Set;}
    public String csvData{get;set;}
    public String helpData{get;set;}
    public List<FieldTypeDetails__mdt> lstFieldDetails{get;set;}
    public List<SelectOption> objList{get;set;}
    public String selectedObj{get;set;}
    public List<SObject> records{get;set;}
    Public List<String> fieldsCMT{get;set;}
    public string nameFile{get;set;}
    public Blob contentFile{get;set;}
    String[] filelines = new String[]{};
    String[] filecolumns = new String[]{};
    set<string> lstString ;
    List<string> lstMatchedColumns {get;set;}
    List<string> lstUnMatchedColumns {get;set;}
   	Map<string,Map<string,string>> mapCSV = new Map<string,Map<string,string>>();
   	set<String> setFieldType {get;set;}
   	Map<String, String> innerMap1 {get;set;}
   	
    public FileUploader(){
        getAllObjects();
        csvgen();
        fieldsTypeDetails();
    }
    public PageReference reDirect()
    {
        map<String,schema.SObjectType> globalDescribe=schema.getGlobalDescribe();
        Schema.SObjectType so=globalDescribe.get(selectedObj);
        Schema.DescribeSObjectResult objectDescribeResult = so.getDescribe();
        String objPrefix=objectDescribeResult.getKeyPrefix();
        PageReference pr=new PageReference('/'+objPrefix);
        pr.setRedirect(true);
        return pr;
    }
    public void fieldsTypeDetails(){    
        lstFieldDetails=new List<FieldTypeDetails__mdt>([select DeveloperName,ColumnAPIName__c,CSVColumnName__c,DataType__c,Description__c,Primary__c from FieldTypeDetails__mdt]);
    }
   	public void getAllObjects(){
        objList=new List<SelectOption>();
        mockUpHandler mh=new mockUpHandler();
        objList=mh.allObjects();
    }
    // For generateing sample template and help file
    public void csvgen(){
        mockUpHandler mh=new mockUpHandler();
        helpData=mh.generateHelp();
        csvData=templateData.parseJSONString();
    }
    // Function to check CSV is blank or not
    public Boolean checkBlankCSV(){
    	nameFile=contentFile.toString();
        filelines = nameFile.split('\n');
        if(filelines.size()<2){
            return false;
        }
      return true;  	     
    }
    //  CSV into MAP<FieldNameAPI,map<ColumnName,RowValue>> Format 
    public map<string,map<string,string>> csvToMap(){
        Map<string,string> innerMap ;
        Integer primaryColumnIndex;
        String primaryColumn;
        for(FieldTypeDetails__mdt ft : [select CSVColumnName__c from FieldTypeDetails__mdt where Primary__c='True']){	
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
        for (Integer i=1;i<filelines.size();i++){
                String[] inputvalues = new String[]{};
                inputvalues = filelines[i].split(',');            
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
        		system.debug('inner ' + innermapkey);
        		if(innermapkey.equalsIgnoreCase(mapAPIName.get('type_x'))){
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
     
    public Pagereference readFile()
    {
      	summaryPage=true; 
        String objName = selectedObj;
    	 ApexPages.Message errormsg ;
        /* check If CSV is Blank then no need go further return from here */ 
        	if(!checkBlankCSV()){
        		errormsg = new ApexPages.Message(ApexPages.severity.ERROR,System.Label.Blank_CSV);
            	ApexPages.addMessage(errormsg);
        		return null;
        	}
 		/* SET contains all Predeifuned columns in metadata */ 
        	Set<string> defineCSVColumnNames = new set<string>();
        	for(FieldTypeDetails__mdt ft : [select CSVColumnName__c from FieldTypeDetails__mdt]){	
        		defineCSVColumnNames.add(String.valueOf(ft.CSVColumnName__c));
        	}
        /* Map for Mandatory fields for field type */
        	Map<string,string> mapMandatoryFields = new Map<string,string>();
        	for(MandatoryColumns_FiledTypeWise__mdt mf : [select MasterLabel,MandatoryFields__c from MandatoryColumns_FiledTypeWise__mdt ]){
        		mapMandatoryFields.put(mf.MasterLabel,mf.MandatoryFields__c);
        	} 
        /* Map for column name and their data type */
 			Map<string,string> mapFieldDataType = new Map<string,string>();
        	for(FieldTypeDetails__mdt ftDetails : [select CSVColumnName__c,DataType__c from FieldTypeDetails__mdt ]){
        		mapFieldDataType.put(ftDetails.CSVColumnName__c,ftDetails.DataType__c);
        	}
       /* */
         	map<String,String> mapAPIName=new map<String,String>();
         	for(FieldTypeDetails__mdt mappedColumn1 : [select CSVColumnName__c,ColumnAPIName__c from FieldTypeDetails__mdt]){
                mapAPIName.put(mappedColumn1.ColumnAPIName__c.trim(), mappedColumn1.CSVColumnName__c.trim());
        	}
        /* Get CSV data into map in map<FieldAPIName,map<columnName,rowValue>> format */ 
        	Map<string,map<string,string>> mapCSV = csvToMap();
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