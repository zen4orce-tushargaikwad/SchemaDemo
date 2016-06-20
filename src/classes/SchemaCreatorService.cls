public with sharing class SchemaCreatorService{
	public string selectedObj{get;set;}
	public String csvData{get;set;}
	public String helpData{get;set;}
	public Blob contentFile{get;set;}
	public string nameFile{get;set;}
	public List<FieldTypeDetails__mdt> lstFieldDetails{get;set;}
	public List<SelectOption> objList{get;set;}
	public List<List<String>> lstlstCMTFields {get;set;}
	SchemaCreatorServiceHandler scsh=new SchemaCreatorServiceHandler();
	public SchemaCreatorService(){
		initialData();
	}
	public void initialData()
	{
		objList=scsh.getAllObjects();
		//csvData=scsh.generateSampleTemplate();
		csvData=scsh.parseJSONString();
		helpData=scsh.generateHelp();
		lstFieldDetails=SelectorClass.selectCMTFields();
		lstlstCMTFields = new List<List<string>>();
		lstlstCMTFields=scsh.cont();
		System.debug(lstlstCMTFields);	
	}
	public Pagereference readFile()
	{
		System.debug('Contentfile Data:'+contentFile);
		System.debug('NameFile Data:'+nameFile);
		scsh.readFile(contentFile,nameFile,selectedObj);
		return null;
	}			
}