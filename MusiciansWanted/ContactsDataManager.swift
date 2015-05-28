//
//  ContactsDataManager.swift
//  MW
//
//  Created by Joseph Canero on 4/21/15.
//  Copyright (c) 2015 iOS Team. All rights reserved.
//

import Foundation

class ContactsDataManager {
    var contacts: [Contact] = []
    var contactDelegate: ContactTableDelegate?
    
    init() {
    }
    
    func populateContacts() {
        contacts = []
        let url = "/api/contactships/contacts/\(MusiciansWanted.userId)"
        DataManager.makeGetRequest(url, completion: { (data, error) -> Void in
            let json = JSON(data: data!)
            let errorString = DataManager.checkForErrors(json)
            if errorString == "" {
                for contact in json {
                    var contactData = contact.1
                    var id = contactData["id"].stringValue.toInt()!
                    self.addContactToList(id)
                    self.contacts.append(Contact(id: id, name: contactData["name"].stringValue))
                    self.contactDelegate?.contactSaved()
                }
            }
            else {
                dispatch_async(dispatch_get_main_queue()) {
                    SweetAlert().showAlert("Uh oh", subTitle: errorString, style: AlertStyle.Error)
                }
            }
        })
    }
    
    func addContactToList(id: Int) {
        if MusiciansWanted.contacts?.findKey(id) == nil {
            MusiciansWanted.contacts?.insertKey(id, data: true)
        }
    }
}