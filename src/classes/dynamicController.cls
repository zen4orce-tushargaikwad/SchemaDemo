public with sharing class dynamicController {

public List<List<String>> lstlstAllProfiles {get;set;}
public list<MyWrapper> lstWrapper {get;set;}
public string profiles {get;set;}
public List<string> lstProfiles {get;set;}
SchemaCreatorServiceHandler scsh=new SchemaCreatorServiceHandler(); 
      
     public dynamicController(){
     	lstProfiles = new List<String>();
        lstlstAllProfiles = new List<List<string>>();
		lstlstAllProfiles=scsh.getAllProfilesdata();
        this.lstWrapper = new list<MyWrapper>();
        MyWrapper oWrapp = new MyWrapper();
        oWrapp.FName=''; 
        oWrapp.FType=''; 
        oWrapp.FLabel= ''; 
        oWrapp.index=1;
        lstWrapper.add(oWrapp);
     }
     
    public PageReference AddRecord() {
       //Assign your own data to do this. for testing I just placed the dummy data.
        MyWrapper oWrapp = new MyWrapper();
        oWrapp.FName=''; 
        oWrapp.FType=''; 
        oWrapp.FLabel= ''; 
        oWrapp.index=lstWrapper.size()+1;
        lstWrapper.add(oWrapp);
        return null;
    }
    
    public PageReference cSchema()
	    {
	    	//String profilevalues='';
	    	//Map<string,string> mapparam = new map<String,string>();
	    	//List<string> lst = new List<string>();
	    	//lst.add(Apexpages.currentPage().getParameters().get('firstParam'));
	    	
	    	
	       lstProfiles.add(profiles);
	       system.debug('Selected profile Values '+profiles);
	       system.debug('Selected profile Values '+lstProfiles);
	       return  null;
	       
	    }
    
    public PageReference SaveData() {
    	Map<string,map<string,string>> uiMap = new Map<string,map<string,string>>();
    	map<string,string> innerMap ;  
     List<MyWrapper> lstBuiderData = new List<MyWrapper>();
     system.debug('lstWrapper'+lstWrapper.size());
    
     for(MyWrapper sdata : lstWrapper)   
     {
     innerMap = new map<string,string>(); 
     innermap.put('FieldApiName',sdata.FName);
     innermap.put('FieldType',sdata.FType);
     innermap.put('FieldName',sdata.FLabel);
     uiMap.put(sdata.FName,innermap);
     }
     
     system.debug('inner map'+innermap);
     system.debug('ui map'+uiMap);
    return null;
    }
     
      public class MyWrapper{
          public string FName{ get;set;}
          public string FType{get;set;}
          public string FLabel{get;set;}
          public Integer index{get;set;}
          
      }
      
}