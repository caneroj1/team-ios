//
//  FirstViewController.swift
//  MusiciansWanted
//
//  Created by Nick on 3/7/15.
//  Copyright (c) 2015 iOS Team. All rights reserved.
//

import UIKit

class PeopleSettingViewController: UITableViewController, UITextFieldDelegate, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet var contactsOnly: UISwitch!
    @IBOutlet var jamOption: UISwitch!
    @IBOutlet var bandOption: UISwitch!
    
    @IBOutlet var lowerAgeTxt: UITextField!
    @IBOutlet var upperAgeTxt: UITextField!
    
    @IBOutlet var genreCollection: UICollectionView!
    @IBOutlet var instruCollection: UICollectionView!
    
    var lowerAge:Int = 13;
    var upperAge:Int = 75;
    
    var genreDict:[String:Bool] = ["African":false, "Asian":false, "Blues":false, "Caribbean": false, "Classical":false, "Country":false, "Electronic":false, "Folk":false, "Hip-Hop":false, "Jazz":false, "Latin":false, "Pop":false, "Polka":false, "R&B":false, "Rock":false, "Metal":false]
    var genreIndex = [String]()
    
    //var instru: String = ""
    var instruDict:[String:Bool] = ["Brass":false, "Electronics":false, "Keys":false, "Percussion": false, "Strings(Bowed)":false, "Strings(Plucked)":false, "Vocals":false, "Woodwinds":false]
    var instruIndex = [String]()
    
    //Check Filters
    override func viewWillAppear(animated: Bool) {
        contactsOnly.on = Filters.contactsOnly
        jamOption.on = Filters.looking_to_jam
        bandOption.on = Filters.looking_for_band
        upperAge = Filters.upperAge
        lowerAge = Filters.lowerAge
        lowerAgeTxt.text = "\(Filters.lowerAge)"
        upperAgeTxt.text = "\(Filters.upperAge)"
        
        if Filters.genre != "" {
            var arrGenres : [String] = (Filters.genre).componentsSeparatedByCharactersInSet(NSCharacterSet (charactersInString: ":"))
            
            for genre in arrGenres {
                genreDict[genre] = true
            }
        }
        
        if Filters.instrument != "" {
            var arrInstru : [String] = (Filters.instrument).componentsSeparatedByCharactersInSet(NSCharacterSet (charactersInString: ":"))
            
            for instru in arrInstru {
                instruDict[instru] = true
            }
        }
                
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        genreIndex = Array(genreDict.keys).sorted(<)
        instruIndex = Array(instruDict.keys).sorted(<)

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        self.view.endEditing(true);
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder();
        return true;
    }
    
    @IBAction func contactsOnlyStateChanged(sender: UISwitch) {
        //Contacts Only Switch
        if contactsOnly.on {
            Filters.contactsOnly = true
        }
        else {
            Filters.contactsOnly = false
        }
    }
    
    @IBAction func jamStateChanged(sender: UISwitch) {
        //Look to Jam Switch
        if jamOption.on {
            Filters.looking_to_jam = true
        }
        else {
            Filters.looking_to_jam = false
        }
    }
    
    @IBAction func bandStateChanged(sender: UISwitch) {
        //Looking for Band Switch
        if bandOption.on {
            Filters.looking_for_band = true
        }
        else {
            Filters.looking_for_band = false
        }
    }
    
    @IBAction func lowerAgeChanged(sender: UITextField) {
        
        if let lowerNumber = NSNumberFormatter().numberFromString(lowerAgeTxt.text) {
            lowerAge = lowerNumber.integerValue
        } else {
            lowerAge = 13
        }
        
        if lowerAge < 13 {
            lowerAge = 13
        } else if lowerAge >= upperAge {
            lowerAge = upperAge - 1
        } else if lowerAge > 74 {
            lowerAge = 74
        }
        
        lowerAgeTxt.text = "\(lowerAge)"
        Filters.lowerAge = lowerAge
        Filters.upperAge = upperAge
    }
    
    
    @IBAction func upperAgeChanged(sender: UITextField) {
        
        if let upperNumber = NSNumberFormatter().numberFromString(upperAgeTxt.text) {
            upperAge = upperNumber.integerValue
        } else {
            upperAge = 75
        }
        
        if upperAge > 75 {
            upperAge = 75
        } else if upperAge <= lowerAge {
            upperAge = lowerAge + 1
        } else if upperAge < 14 {
            upperAge = 14
        }
        
        upperAgeTxt.text = "\(upperAge)"
        Filters.lowerAge = lowerAge
        Filters.upperAge = upperAge
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        if genreCollection == collectionView {
            return genreIndex.count
        }
        else
        {
            return instruIndex.count
        }
    }
    
    // The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        if genreCollection == collectionView {
            
            let cell: GenreCell = collectionView.dequeueReusableCellWithReuseIdentifier("genreCell", forIndexPath: indexPath) as! GenreCell
            
            var imageName: String = "btn" + genreIndex[indexPath.row]
            
            cell.imgGenre.image = UIImage(named: imageName)
            
            var genre = genreDict[genreIndex[indexPath.row]]
            
            if genre == true {
                //cell.backgroundColor = UIColor(red: 5.0/255.0, green: 5.0/255.0, blue: 10.0/255.0, alpha: 0.2)
                cell.backgroundView = UIImageView(image: UIImage(named: "btnSelection"))
            }
            else{
                //cell.backgroundColor = UIColor.clearColor()
                cell.backgroundView = UIView()
            }
            
            return cell
            
        } else {
            
            let cell: InstruCell = collectionView.dequeueReusableCellWithReuseIdentifier("instruCell", forIndexPath: indexPath) as! InstruCell
            
            var imageName: String = "guitar" //"btn" + instruIndex[indexPath.row]
            
            cell.imgInstru.image = UIImage(named: imageName)
            
            var instru = instruDict[instruIndex[indexPath.row]]
            
            if instru == true {
                //cell.backgroundColor = UIColor(red: 5.0/255.0, green: 5.0/255.0, blue: 10.0/255.0, alpha: 0.2)
                cell.backgroundView = UIImageView(image: UIImage(named: "btnSelection"))
            }
            else{
                //cell.backgroundColor = UIColor.clearColor()
                cell.backgroundView = UIView()
            }
            
            return cell
            
        }
        
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        if collectionView == genreCollection {
            if (genreDict[genreIndex[indexPath.row]] == true) {
                genreDict[genreIndex[indexPath.row]] = false
                
                if ((Filters.genre).rangeOfString(genreIndex[indexPath.row]) != nil) {
                    var str = genreIndex[indexPath.row] + ":"
                    
                    let aString: String = Filters.genre
                    let newString = aString.stringByReplacingOccurrencesOfString(str, withString: "")
                    
                    Filters.genre = newString
                }
            }
            else {
                genreDict[genreIndex[indexPath.row]] = true
                
                if ((Filters.genre).rangeOfString(genreIndex[indexPath.row]) == nil) {
                    Filters.genre = Filters.genre + genreIndex[indexPath.row] + ":"
                }
            }
            
        }
        else {
            if (instruDict[instruIndex[indexPath.row]] == true) {
                instruDict[instruIndex[indexPath.row]] = false
                
                if ((Filters.instrument).rangeOfString(instruIndex[indexPath.row]) != nil) {
                var str = instruIndex[indexPath.row] + ":"
                
                let aString: String = Filters.instrument
                let newString = aString.stringByReplacingOccurrencesOfString(str, withString: "")
                
                Filters.instrument = newString
                }
            }
            else {
                instruDict[instruIndex[indexPath.row]] = true
                
                if ((Filters.instrument).rangeOfString(instruIndex[indexPath.row]) == nil) {
                    Filters.instrument = Filters.instrument + instruIndex[indexPath.row] + ":"
                }
            }
        }
        
        genreCollection.reloadData()
        instruCollection.reloadData()
    }

}