//
//  PeopleCell.swift
//  MusiciansWanted
//
//  Created by Nick on 3/27/15.
//  Copyright (c) 2015 iOS Team. All rights reserved.
//

import UIKit

class PeopleCell: UITableViewCell {

    @IBOutlet var imgProfilePic: UIImageView!
    @IBOutlet var lblProfileName: UILabel!
    @IBOutlet var lblLocation: UILabel!
    @IBOutlet var lblAge: UILabel!
    @IBOutlet var lblInstrument: UILabel!
    @IBOutlet var lblGenre: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
