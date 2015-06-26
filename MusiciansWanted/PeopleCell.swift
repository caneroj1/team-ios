//
//  PeopleCell.swift
//  MusiciansWanted
//
//  Created by Nick on 3/27/15.
//  Copyright (c) 2015 iOS Team. All rights reserved.
//

import UIKit

class PeopleCell: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet var imgProfilePic: UIImageView!
    @IBOutlet var lblProfileName: UILabel!
    @IBOutlet var lblLocation: UILabel!
    @IBOutlet var lblAge: UILabel!
    @IBOutlet var genreCollection: UICollectionView!
    @IBOutlet var instruCollection: UICollectionView!
    @IBOutlet var bgView: UIView!
    
    var genres = [String]()
    var instru = [String]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        let lightShadow: UIColor = UIColor( red: 132/255.0, green: 132/255.0, blue:149/255.0, alpha: 0.4 )
        //let lightShadow: UIColor = UIColor( red: 100/255.0, green: 100/255.0, blue: 124/255.0, alpha: 0.4 )
        self.bgView.layer.borderColor = lightShadow.CGColor
        self.bgView.layer.borderWidth = 2.0
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == genreCollection {
            return genres.count - 1
        }
        else {
            return instru.count - 1
        }
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        if collectionView == genreCollection {

            let cell: GenreCell = collectionView.dequeueReusableCellWithReuseIdentifier("genreCell", forIndexPath: indexPath) as! GenreCell
        
            var imageName: String = "btn" + genres[indexPath.row]
            cell.imgEditGenre.image = UIImage(named: imageName)!
        
            return cell
        }
        else {
            
            let cell: InstruCell = collectionView.dequeueReusableCellWithReuseIdentifier("instruCell", forIndexPath: indexPath) as! InstruCell
            
            var imageName: String = "guitar" //"btn" + instru[indexPath.row]

            cell.imgInstru.image = UIImage(named: imageName)
            
            return cell
        }
    }

}
