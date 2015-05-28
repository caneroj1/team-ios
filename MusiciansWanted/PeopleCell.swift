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
    @IBOutlet var lblInstrument: UILabel!
    @IBOutlet weak var genreCollection: UICollectionView!
    
    var genres = [String]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return genres.count - 1
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell: GenreCell = collectionView.dequeueReusableCellWithReuseIdentifier("genreCell", forIndexPath: indexPath) as! GenreCell
        
        var imageName: String = "btn" + genres[indexPath.row]
        println("Name of image: \(imageName)")
        cell.imgEditGenre.image = UIImage(named: imageName)!
        
        return cell
    }

}
