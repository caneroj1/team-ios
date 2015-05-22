//
//  NewMessageViewController.swift
//  MW
//
//  Created by Nick on 5/21/15.
//  Copyright (c) 2015 iOS Team. All rights reserved.
//

import UIKit

struct toContact {
    var name = ""
    var id = -1
    var cellSize = CGSize(width: 100, height: 20)
}

class NewMessageViewController: UITableViewController, UICollectionViewDataSource, UICollectionViewDelegate, UITextFieldDelegate, UITextViewDelegate {
    
    @IBOutlet var contactCollection: UICollectionView!
    @IBOutlet var subjectText: UITextField!
    @IBOutlet var bodyText: UITextView!
    @IBOutlet var sendButton: UIButton!
    
    var toContacts = [toContact]()
    
    @IBAction func sendMessage(sender: UIButton) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        let lightestGrayColor: UIColor = UIColor( red: 200.0/255.0, green: 200.0/255.0, blue:200.0/255.0, alpha: 1.0 )
        /*self.contactCollection.layer.borderColor = lightestGrayColor.CGColor
        self.contactCollection.layer.borderWidth = 0.6
        self.contactCollection.layer.cornerRadius = 5.0
        self.contactCollection.clipsToBounds = true
        self.contactCollection.layer.masksToBounds = true*/
        
        self.bodyText.layer.borderColor = lightestGrayColor.CGColor
        self.bodyText.layer.borderWidth = 0.6
        self.bodyText.layer.cornerRadius = 5.0
        self.bodyText.clipsToBounds = true
        self.bodyText.layer.masksToBounds = true
        
        //Sample Data
        toContacts.append(toContact(name: "Joe Canero", id: 116, cellSize: CGSize(width: 72.5, height: 22)))
        toContacts.append(toContact(name: "Nicholas Amuso", id: 116, cellSize: CGSize(width: 102.0, height: 22)))
        toContacts.append(toContact(name: "Hank Harvey", id: 116, cellSize: CGSize(width: 80.5, height: 22)))
        toContacts.append(toContact(name: "Marco Polo", id: 116, cellSize: CGSize(width: 72, height: 22)))
        toContacts.append(toContact(name: "Alex M", id: 116, cellSize: CGSize(width: 43.5, height: 22)))
        toContacts.append(toContact(name: "Dude with really long name", id: 115, cellSize: CGSize(width: 169.5, height: 22)))
        
        contactCollection.reloadData()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        contactCollection.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{

        return toContacts.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        
        let cell: ToContactCell = collectionView.dequeueReusableCellWithReuseIdentifier("toContactCell", forIndexPath: indexPath) as! ToContactCell
        
        cell.contactName.text = toContacts[indexPath.row].name
        
        let textViewFixedHeight = cell.contactName.frame.size.height
        toContacts[indexPath.row].cellSize = cell.contactName.sizeThatFits(CGSizeMake(CGFloat(MAXFLOAT), textViewFixedHeight))
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        return CGSize(width: toContacts[indexPath.row].cellSize.width + 20, height: 22)
        
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        toContacts.removeAtIndex(indexPath.row)
        contactCollection.reloadData()
    }
}
