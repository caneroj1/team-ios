//
//  InboxCell.swift
//  MW
//
//  Created by Nick on 4/3/15.
//  Copyright (c) 2015 iOS Team. All rights reserved.
//

import UIKit

class MessageBubbleCell: UITableViewCell {
    @IBOutlet var msgText: UILabel!
    @IBOutlet var msgView: UIView!
    @IBOutlet var msgHeader: UILabel!
        
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        let lightestGrayColor: UIColor = UIColor( red: 224.0/255.0, green: 224.0/255.0, blue:224.0/255.0, alpha: 1.0 )
        //self.msgView.layer.borderColor = lightestGrayColor.CGColor
        //self.msgView.layer.borderWidth = 0.6
        self.msgView.layer.cornerRadius = 6.0
        self.msgView.clipsToBounds = true
        self.msgView.layer.masksToBounds = true

    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}