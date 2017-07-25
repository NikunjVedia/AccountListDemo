/*****************************************************************
@Name: AccountListController
@Author: Nikunj Vedia
@CreateDate: 25th July 2017
@Description: Controller class for AccountList VF Page [Class created for Practical Test at Incapsulate]
******************************************************************/
Public class AccountListController{

    // Global Variable Declaration
    Public list<Account> accountList{get;set;}
    Public Map<ID,List<Contact>> mapOfAccountToContacts{get;set;}
    Public Map<ID,Boolean> contactDisplayMap{get;set;}
    Public id contactId{get;set;}
    Public String SearchString{get;set;}
    
    // Constructor to prepare data on initial page load
    Public AccountListController(){
        
        SearchString = '';
        prepareData();
        
    }
    
    // Method which will prepare data for Account and related contacts
    public void prepareData(){
        
        // Preparing Search String for Like Query
        String mySearchString = '%' + SearchString + '%';
        
        // Quering all accounts and contacts
        accountList = [Select id,Name,Type,AccountNumber,Rating,Website,AnnualRevenue from Account where name like :mySearchString];
        list<Contact> allContactList = [Select id,AccountID,Name,title,email from Contact];
        
        // Preparing map for Account to its related contacts
        mapOfAccountToContacts = new Map<ID,List<Contact>>();
        
        for(Account accountSO : accountList){
            mapOfAccountToContacts.put(accountSO.id,New List<Contact>{});
        }
        
        for(Contact contactSO : allContactList){
            if(mapOfAccountToContacts.containsKey(contactSO.AccountID)){
                 mapOfAccountToContacts.get(contactSO.AccountID).add(contactSO); 
            }else{
                 mapOfAccountToContacts.put(contactSO.AccountID,New List<Contact>{ContactSO});    
            } 
        }
        
        // Preparing map to display Contact table or not
        contactDisplayMap = New Map<id,Boolean>();
        for(Account accountSO : accountList){
            boolean displayTable = mapOfAccountToContacts.get(accountSO.id).Size() > 0 ? TRUE : FALSE;
            contactDisplayMap.put(accountSO.id,displayTable);
        }
    }
    
    // Method to delete contact
    public pagereference deleteContact(){
        try{
        
        // Quering and Deleting contact which user wants to delete
        Contact contactSO = [Select id from Contact where id=:contactId];
        delete contactSO;
        
        // calling prepareData to refresh data on page 
        prepareData();
        
        }catch(Exception e){
            // In case Contact delete failure, System should display proper message
            ApexPages.addMessage(New ApexPages.message(ApexPages.severity.ERROR,e.getMessage()));
        }
        return null;
    }
    
}