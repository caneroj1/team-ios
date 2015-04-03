//
//  InboxCell.swift
//  MW
//
//  Created by Nick on 4/3/15.
//  Copyright (c) 2015 iOS Team. All rights reserved.
//

import UIKit

class InboxCell: UITableViewCell {

    @IBOutlet var lblProfName: UILabel!
    @IBOutlet var lblBody: UILabel!
    @IBOutlet var lblDate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}
