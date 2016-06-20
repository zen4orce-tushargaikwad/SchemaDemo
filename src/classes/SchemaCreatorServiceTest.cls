@isTest
private class SchemaCreatorServiceTest {

    static testMethod void testinitialData() {
    	SchemaCreatorService scs=new SchemaCreatorService();
		scs.initialData();
    }
    static testMethod void testReadFile(){
    	SchemaCreatorService scs=new SchemaCreatorService();
    	String dataCSV='Decimal,DefaultValue,Description,DisplayFormat,ExternalId,FieldApiName,FieldName,FieldType,InlineHelpText,Length,PickListValues,ReferenceTo,RelationshipName,Required,Sorted,SummarizedField,SummaryForeignKey,SummaryOperation,Unique,VisibleLines';
		scs.contentFile = Blob.valueOf(dataCSV);//NEED TO CONVERT STRING TO BLOB
		scs.nameFile = 'testdata';
		scs.selectedObj='test__c';
    	scs.readFile(); 
    }
}