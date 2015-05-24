//
//  PeopleInterfaceController.swift
//  MW
//
//  Created by Joseph Canero on 5/24/15.
//  Copyright (c) 2015 iOS Team. All rights reserved.
//

import WatchKit
import Foundation


class PeopleInterfaceController: WKInterfaceController {

    @IBOutlet weak var peopleTable: WKInterfaceTable!
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        // Configure interface objects here.
        let userDictionary: [String: String] = ["find": "people"]
        setLoadingStatus()
        getPeople(userDictionary)
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    func getPeople(userDictionary: [String: String]) {
        WKInterfaceController.openParentApplication(userDictionary, reply: { (reply, error) -> Void in
            if let message = error {
                println(message)
                return
            }
            
            if let people = reply["results"] as? [String] {
                self.peopleTable.setNumberOfRows(people.count, withRowType: "PersonRow")
                for (index, person) in enumerate(people) {
                    var personInfo = person.componentsSeparatedByString("|")
                    if let rowController = self.peopleTable.rowControllerAtIndex(index) as? PersonRow {
                        rowController.personName.setText(personInfo[0])
                        rowController.personName.setTextColor(UIColor(red: 255.0/255.0, green: 90.0/255.0, blue: 0.0/255.0, alpha: 1.0))
                        rowController.personLocation.setText(personInfo[1])
                    }
                }
            }
            else {
                let error = reply["error"] as? String
                self.peopleTable.setNumberOfRows(1, withRowType: "PersonRow")
                if let rowController = self.peopleTable.rowControllerAtIndex(0) as? PersonRow {
                    rowController.personName.setText(error)
                    rowController.personLocation.setText("")
                }
            }
        })
    }

    func setLoadingStatus() {
        peopleTable.setNumberOfRows(1, withRowType: "PersonRow")
        if let rowController = peopleTable.rowControllerAtIndex(0) as? PersonRow {
            rowController.personName.setText("Loading People")
            rowController.personLocation.setText("")
        }
    }
}
