//
//  SelectContactsViewController.swift
//  MW
//
//  Created by Nick on 5/22/15.
//  Copyright (c) 2015 iOS Team. All rights reserved.
//

import UIKit

class SelectContactsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ContactTableDelegate {

    @IBOutlet var contactsTable: UITableView!
    @IBOutlet var contactCollection: UICollectionView!

    var contactsManager = ContactsDataManager()
    var toContacts = [Int: toContact]()
    var arrContactIds = [Int]()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        populateContacts()
    }
    
    // MARK: - ToContacts Collection View
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        
        return arrContactIds.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        
        let cell: ToContactCell = collectionView.dequeueReusableCellWithReuseIdentifier("toContactCell", forIndexPath: indexPath) as! ToContactCell
        
        cell.contactName.text = toContacts[arrContactIds[indexPath.row]]!.name
        
        let textViewFixedHeight = cell.contactName.frame.size.height
        
        toContacts[arrContactIds[indexPath.row]]!.cellSize = cell.contactName.sizeThatFits(CGSizeMake(CGFloat(MAXFLOAT), textViewFixedHeight))
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        return CGSize(width: toContacts[arrContactIds[indexPath.row]]!.cellSize.width + 20, height: 22)
        
    }
    
    func populateContacts() {
        contactsManager.contactDelegate = self
        contactsManager.populateContacts()
    }
    
    // MARK: - Contact Table Delegate
    func contactSaved() {
        dispatch_async(dispatch_get_main_queue()) {
            self.contactsTable.reloadData()
        }
    }
    
    // MARK: - Contacts Table View
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contactsManager.contacts.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("addContactsCell") as! UITableViewCell
        cell.textLabel?.text = contactsManager.contacts[indexPath.row].name
        
        var cellcolor = UIColor(red: 244.0/255.0, green: 245.0/255.0, blue: 255.0/255.0, alpha: 1.0)
        
        if toContacts[contactsManager.contacts[indexPath.row].id] != nil {
            cellcolor = UIColor(red: 255.0/255.0, green: 90.0/255.0, blue: 0.0/255.0, alpha: 0.2)
        }
        
        cell.backgroundColor = cellcolor

        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if toContacts[contactsManager.contacts[indexPath.row].id] != nil {
            
            toContacts.removeValueForKey(contactsManager.contacts[indexPath.row].id)
        }
        else {
            //------ Single Selection -----
            toContacts.removeAll(keepCapacity: false)
            //-----------------------------
            toContacts[contactsManager.contacts[indexPath.row].id] = toContact(name: contactsManager.contacts[indexPath.row].name,id: contactsManager.contacts[indexPath.row].id, cellSize: CGSize(width: 100, height: 20))
        }
        
        arrContactIds = Array(toContacts.keys)
        tableView.reloadData()
        contactCollection.reloadData()
    }
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "newMessageView") {
            var destination = segue.destinationViewController as! NewMessageViewController
            
            destination.toContacts = Array(toContacts.values)
        }
    }
}