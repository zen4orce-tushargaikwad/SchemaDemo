@isTest
public with sharing class SchemaCreatorServiceHandlerTest {

	public static testMethod void getAllObjects()
		{
			SchemaCreatorServiceHandler scHandler = new SchemaCreatorServiceHandler();
		//String dataCSV = 'FieldType,FieldName,FieldApiName,Required,Percision,Scale,DefaultValue,Description,InlineHelpText,PickListValues,VisibleLines,ExternalId,Unique,Sorted,RelationShipName,ReferenceTo\n';
		//String dataCSV='Decimal,DefaultValue,Description,DisplayFormat,ExternalId,FieldApiName,FieldName,FieldType,InlineHelpText,Length,PickListValues,ReferenceTo,RelationshipName,Required,Sorted,SummarizedField,SummaryForeignKey,SummaryOperation,Unique,VisibleLines';
		//fileuploaderobj.contentFile = Blob.valueOf(dataCSV);//NEED TO CONVERT STRING TO BLOB
			scHandler.getAllObjects();
		}
	public static testMethod void generateSampleTemplate()
		{
			SchemaCreatorServiceHandler scHandler = new SchemaCreatorServiceHandler();
			scHandler.generateSampleTemplate();
		}
		
	public static testMethod void readFileBlankCSV()
		{
			SchemaCreatorServiceHandler scHandler = new SchemaCreatorServiceHandler();
			String dataCSV='Decimal,DefaultValue,Description,DisplayFormat,ExternalId,FieldApiName,FieldName,FieldType,InlineHelpText,Length,PickListValues,ReferenceTo,RelationshipName,Required,Sorted,SummarizedField,SummaryForeignKey,SummaryOperation,Unique,VisibleLines';
			blob contentFile = Blob.valueOf(dataCSV);//NEED TO CONVERT STRING TO BLOB
			String nameFile = 'TestSchema';
			string selectedObj='Account';
			scHandler.readFile(contentFile,nameFile,selectedObj);
		}
	public static testMethod void readFile()
		{
			SchemaCreatorServiceHandler scHandler = new SchemaCreatorServiceHandler();	
		String dataCSV = 'FieldType,FieldName,FieldApiName,Required,Length,Decimal,DefaultValue,Description,InlineHelpText,PickListValues,VisibleLines,ExternalId,Unique,Sorted,RelationshipName,ReferenceTo,DisplayFormat,SummarizedField,SummaryForeignKey,SummaryOperation\n'+
'Text,EmpName,EmpName__c,TRUE,20,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null\n'+
'Number,EmpSalary,EmpSalary__c,TRUE,10,2,null,null,null,null,null,null,null,null,null,null,null,null,null,null\n';
        blob contentFile = Blob.valueOf(dataCSV);//NEED TO CONVERT STRING TO BLOB
        String nameFile = 'TestSchema';
		string selectedObj='Account';
		scHandler.readFile(contentFile,nameFile,selectedObj);  
		}
    
    public static testMethod void readFiledataValid()
		{
			SchemaCreatorServiceHandler scHandler = new SchemaCreatorServiceHandler();	
		String dataCSV = 'FieldType,FieldName,FieldApiName,Required,Length,Decimal,DefaultValue,Description,InlineHelpText,PickListValues,VisibleLines,ExternalId,Unique,Sorted,RelationshipName,ReferenceTo,DisplayFormat,SummarizedField,SummaryForeignKey,SummaryOperation\n'+
		'Text,EmpName,EmpName__c,test,20,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null\n'+
		'Number,EmpSalary,EmpSalary__c,TRUE,test,2,null,null,null,null,null,null,null,null,null,null,null,null,null,null\n';
        blob contentFile = Blob.valueOf(dataCSV);//NEED TO CONVERT STRING TO BLOB
        String nameFile = 'TestSchema';
		string selectedObj='Account';
		scHandler.readFile(contentFile,nameFile,selectedObj);  
		}
	public static testMethod void readFileMAndColumn()
		{
			SchemaCreatorServiceHandler scHandler = new SchemaCreatorServiceHandler();	
		String dataCSV = 'FieldType,FieldName,FieldApiName,Required,Decimal,DefaultValue,Description,InlineHelpText,PickListValues,VisibleLines,ExternalId,Unique,Sorted,RelationshipName,ReferenceTo,DisplayFormat,SummarizedField,SummaryForeignKey,SummaryOperation\n'+
		'Text,EmpName,EmpName__c,TRUE,20,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null\n'+
		'Number,EmpSalary,EmpSalary__c,TRUE,10,2,null,null,null,null,null,null,null,null,null,null,null,null,null,null\n';
        blob contentFile = Blob.valueOf(dataCSV);//NEED TO CONVERT STRING TO BLOB
        String nameFile = 'TestSchema';
		string selectedObj='Account';
		scHandler.readFile(contentFile,nameFile,selectedObj);  
		}	
    
    public static testMethod void generateHelp()
		{	
			SchemaCreatorServiceHandler scHandler = new SchemaCreatorServiceHandler();	
			scHandler.generateHelp();       
        }

}