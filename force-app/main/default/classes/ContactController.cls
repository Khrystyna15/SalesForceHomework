public with sharing class ContactController {
    @AuraEnabled(cacheable=true)
    public static List<Contact> getContacts(){
        List<Contact> contacts =  [SELECT FirstName, LastName, Email, Title, Department 
                                    FROM Contact ORDER BY FirstName];
        return contacts;
    }
    @AuraEnabled
    public static void contactDelition(List<Id> ids) {
        delete [Select Id FROM Case WHERE ContactId in :ids];
        delete [Select Id FROM CONTACT WHERE Id in :ids];
    }
}