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
    @IBOutlet var lblSubject: UILabel!
    @IBOutlet var imgProfPic: UIImageView!
    @IBOutlet var bgView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        let lightestGrayColor: UIColor = UIColor( red: 224.0/255.0, green: 224.0/255.0, blue:224.0/255.0, alpha: 1.0 )
        self.imgProfPic.layer.borderColor = lightestGrayColor.CGColor
        self.imgProfPic.layer.borderWidth = 0.6
        self.imgProfPic.layer.cornerRadius = self.imgProfPic.frame.size.width / 2
        self.imgProfPic.clipsToBounds = true
        self.imgProfPic.layer.masksToBounds = true
        
        self.bgView.layer.cornerRadius = self.bgView.frame.size.width / 2
        self.bgView.clipsToBounds = true
        self.bgView.layer.masksToBounds = true
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}
