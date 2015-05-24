//
//  ToContactCell.swift
//  MW
//
//  Created by Nick on 5/21/15.
//  Copyright (c) 2015 iOS Team. All rights reserved.
//

import UIKit

class ToContactCell: UICollectionViewCell {
    
    @IBOutlet var contactName: UILabel!
    //@IBOutlet var bgView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        let lightestGrayColor: UIColor = UIColor( red: 224.0/255.0, green: 224.0/255.0, blue:224.0/255.0, alpha: 1.0 )
        self.layer.borderColor = lightestGrayColor.CGColor
        self.layer.borderWidth = 0.6
        self.layer.cornerRadius = 5.0
        self.clipsToBounds = true
        self.layer.masksToBounds = true
        
    }
}