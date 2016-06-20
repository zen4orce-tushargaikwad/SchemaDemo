/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class CustomSchemaBuilderTest {

    static testMethod void myUnitTest() {
        // TO DO: implement unit test
    }
    public static testMethod void readFileMAndColumn()
		{
			map<string,map<string,string>> mapCSV = new map<string,map<string,string>>();
			SchemaCreatorServiceHandler scHandler = new SchemaCreatorServiceHandler();	
		String dataCSV = 'FieldType,FieldName,FieldApiName,Required,Length,Decimal,DefaultValue,Description,InlineHelpText,PickListValues,VisibleLines,ExternalId,Unique,Sorted,RelationshipName,ReferenceTo,DisplayFormat,SummarizedField,SummaryForeignKey,SummaryOperation\n'+
		'Text,EmpName,EmpName__c,TRUE,20,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null\n'+
		'Number,EmpSalary,EmpSalary__c,TRUE,10,2,null,null,null,null,null,null,null,null,null,null,null,null,null,null\n';
		string dataCSV1 = 'FieldType,FieldName,FieldApiName,Required,Length,Decimal,DefaultValue,Description,InlineHelpText,PickListValues,VisibleLines,ExternalId,Unique,Sorted,RelationshipName,ReferenceTo,DisplayFormat,SummarizedField,SummaryForeignKey,SummaryOperation\n'+
		'Text,EmpName,EmpName__c,TRUE,20,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null\n'+
		'Number,EmpSalary,EmpSalary__c,TRUE,10,2,null,null,null,null,null,null,null,null,null,null,null,null,null,null\n'+
		'Date,JoiningDate,JoiningDate__c,TRUE,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null\n'+
		'Email,EmailId,EmailId__c,TRUE,null,null,null,null,null,null,null,TRUE,TRUE,null,null,null,null,null,null,null\n'+
		'Phone,Contact_No,Contact_No__c,TRUE,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null\n'+
		'Currency,CTC,CTC__c,FALSE,10,2,null,null,null,null,null,null,null,null,null,null,null,null,null,null\n'+
		'Picklist,Education,Education__c,FALSE,null,null,null,null,null,BE|BCA|MCA,3,null,null,Yes,null,null,null,null,null,null\n'+
		'Date,DOB,DOB__c,FALSE,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null\n'+
		'Checkbox,Male,Male__c,FALSE,,,TRUE,null,null,null,null,null,null,null,null,null,null,null,null,null\n'+
		'Checkbox,Female,Female__c,FALSE,,,FALSE,null,null,null,null,null,null,null,null,null,null,null,null,null\n'+
		'TextArea,About_Emp,About_Emp__c,FALSE,255,null,null,null,null,null,3,null,null,null,null,null,null,null,null,null\n'+
		'LongTextArea,LastEmploymentDetails,LastEmploymentDetails__c,FALSE,3200,null,null,null,null,null,5,null,null,null,null,null,null,null,null,null\n'+
		'MasterDetail,ManagerName,ManagerName__c,FALSE,null,null,null,null,null,null,null,null,null,null,EmpTOManager858,Contact,null,null,null,null\n'+
		'Lookup,ProjectName,ProjectName__c,FALSE,null,null,null,null,null,null,null,null,null,null,EmpToProject695,Account,null,null,null,null\n'+
		'AutoNumber,EmpId,EmpId__c,FALSE,null,null,null,null,null,null,null,null,null,null,null,null,E-{0000},null,null,null\n'+
		'MultiselectPicklist,Skills,skills__c,null,null,null,null,null,null,Apex|VF,3,null,null,null,null,null,null,null,null,null\n'+
		'DateTime,InTime,InTime__c,TRUE,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null\n';
		
        blob contentFile = Blob.valueOf(dataCSV1);//NEED TO CONVERT STRING TO BLOB
        String nameFile = 'TestSchema';
		string selectedObj='Account';
		scHandler.readFile(contentFile,nameFile,selectedObj);  
		 mapCSV= scHandler.csvToMap(contentFile);
		 System.debug(mapCSV);
		 CustomSchemaBuilder.CSVData(mapCSV, 'Test__c'); 
		}
}