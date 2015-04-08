//
//  EventsCell.swift
//  MW
//
//  Created by hankharvey on 4/7/15.
//  Copyright (c) 2015 iOS Team. All rights reserved.
//

import UIKit

class EventsCell: UITableViewCell {
    
    @IBOutlet weak var EventTitle: UILabel!
    @IBOutlet weak var EventDescription: UILabel!
    @IBOutlet weak var EventImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
