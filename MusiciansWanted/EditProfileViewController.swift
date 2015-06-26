//
//  EditProfileViewController.swift
//  MusiciansWanted
//
//  Created by Joseph Canero on 3/29/15.
//  Copyright (c) 2015 iOS Team. All rights reserved.
//

import UIKit

class EditProfileViewController: UITableViewController, UITextFieldDelegate, UICollectionViewDataSource, UICollectionViewDelegate {
    var ageText: String = ""
    var emailText: String = ""
    var nameText: String = ""
    var ageValue: Float = 0
    var bandBool: Bool = true
    var jamBool: Bool = true
    var radiusValue: Float = 0
    var radiusLabel: String = ""
    var gender: String = ""
    var cellSent: Bool = false
    var cellPhone: String?
    
    var genre: String = ""
    var genreDict:[String:Bool] = ["African":false, "Asian":false, "Blues":false, "Caribbean": false, "Classical":false, "Country":false, "Electronic":false, "Folk":false, "Hip-Hop":false, "Jazz":false, "Latin":false, "Pop":false, "Polka":false, "R&B":false, "Rock":false, "Metal":false]
    var genreIndex = [String]()
    
    var instru: String = ""
    var instruDict:[String:Bool] = ["Brass":false, "Electronics":false, "Keys":false, "Percussion": false, "Strings(Bowed)":false, "Strings(Plucked)":false, "Vocals":false, "Woodwinds":false]
    var instruIndex = [String]()
    
    @IBOutlet weak var ageSlider: UISlider!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var jamSwitch: UISwitch!
    @IBOutlet weak var bandSwitch: UISwitch!
    @IBOutlet weak var locationRadiusSlider: UISlider!
    @IBOutlet weak var locationRadiusLabel: UILabel!
    @IBOutlet weak var genderControl: UISegmentedControl!
   // @IBOutlet var scrollView: UIScrollView!
    @IBOutlet weak var subscribeButton: UIButton!
    @IBOutlet weak var phoneNumberField: UITextField!
    @IBOutlet var genreCollection: UICollectionView!
    @IBOutlet var instruCollection: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
//        scrollView.contentSize.height = 800
//        scrollView.contentSize.width = self.view.frame.width
        
        genreIndex = Array(genreDict.keys).sorted(<)
        instruIndex = Array(instruDict.keys).sorted(<)

    }
    
    override func viewWillAppear(animated: Bool) {
        ageSlider.value = ageValue
        ageLabel.text = ageText
        emailField.text = emailText
        nameField.text = nameText
        bandSwitch.setOn(bandBool, animated: false)
        jamSwitch.setOn(jamBool, animated: false)
        locationRadiusSlider.value = radiusValue
        locationRadiusLabel.text = radiusLabel
        phoneNumberField.text = cellPhone
        
        if gender != "none" {
            var genderIndex = (gender == "male") ? 0 : 1
            genderControl.selectedSegmentIndex = genderIndex

        }
        
        if genre != "" {
            var arrGenres : [String] = genre.componentsSeparatedByCharactersInSet(NSCharacterSet (charactersInString: ":"))
            
            for genre in arrGenres {
                genreDict[genre] = true
            }
        }
        
        if instru != "" {
            var arrInstru : [String] = instru.componentsSeparatedByCharactersInSet(NSCharacterSet (charactersInString: ":"))
            
            for tmpInstru in arrInstru {
                instruDict[tmpInstru] = true
            }
        }
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
    
    @IBAction func ageSliderChanged(sender: UISlider) {
        let sliderValue = Int(sender.value)
        ageLabel.text = "\(sliderValue)"
    }

    @IBAction func locationRadiusSliderChanged(sender: UISlider) {
        let sliderValue = Int(sender.value)
        locationRadiusLabel.text = "\(sliderValue) miles"
    }
    
    @IBAction func updateProfileButtonPress(sender: UIBarButtonItem) {
        if nameField.text == "" || emailField.text == "" {
            SweetAlert().showAlert("Uh oh!", subTitle: "Some required fields were left blank.", style: AlertStyle.Error)
            return
        }
        else {
            // submit the data to update the current user
            var gender: String?
            
            switch genderControl.selectedSegmentIndex {
                case 0:
                    gender = "male"
                    
                case 1:
                    gender = "female"
                    
                default:
                    gender = ""
            }
            
            var url = "/api/users/\(MusiciansWanted.userId)"
            var userParams: Dictionary<String, AnyObject> = ["name": nameField.text, "email": emailField.text, "age": Int(ageSlider.value), "looking_to_jam": jamSwitch.on, "looking_for_band": bandSwitch.on, "search_radius": Int(locationRadiusSlider.value), "gender": gender!, "genre":genre, "instrument":instru]
            
            var params = ["user": userParams]
            DataManager.makePatchRequest(url, params: params, completion: { (data, error) -> Void in
                var json = JSON(data: data!)
                var errorString = DataManager.checkForErrors(json)
                if errorString != "" {
                    dispatch_async(dispatch_get_main_queue()) {
                        SweetAlert().showAlert("Oops!", subTitle: errorString, style: AlertStyle.Error)
                        return
                    }
                }
                else {
                    dispatch_async(dispatch_get_main_queue()) {
                        SweetAlert().showAlert("Success!", subTitle: "Your profile has been updated.", style: AlertStyle.Success)
                        return
                    }
                }
            })
        }
    }
    
    @IBAction func subscribeToNotifications(sender: AnyObject) {
        if phoneNumberField.text != "" {
            let phoneNumber = phoneNumberField.text.stringByTrimmingCharactersInSet(NSCharacterSet(charactersInString: " "))
            let rgx = "^\\d\\d\\d-\\d\\d\\d-\\d\\d\\d\\d$"
            let phoneNumberRegex = NSRegularExpression(pattern: rgx, options: NSRegularExpressionOptions.CaseInsensitive, error: nil)
            if phoneNumberRegex?.matchesInString(phoneNumber, options: nil, range: NSMakeRange(0, count(phoneNumber))).count == 1 {
                let cell = "1-\(phoneNumber)"
                let url = (cellSent ? "/api/resubscribe" : "/api/subscribe")
                
                let params: Dictionary<String, AnyObject> = ["cell": cell, "id": MusiciansWanted.userId]
                DataManager.makePostRequest(url, params: params, completion: { (data, error) -> Void in
                    let json = JSON(data: data!)
                    let errorString = DataManager.checkForErrors(json)
                    if errorString != "" {
                        dispatch_async(dispatch_get_main_queue()) {
                            SweetAlert().showAlert("Oops!", subTitle: errorString, style: AlertStyle.Error)
                            return
                        }
                    }
                    else {
                        dispatch_async(dispatch_get_main_queue()) {
                            SweetAlert().showAlert("Sweet!", subTitle: json["subscription"].stringValue.capitalizedString, style: AlertStyle.Success)
                            return
                        }
                        self.cellSent = true
                    }
                })
            }
        }
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        if genreCollection == collectionView {
            return genreIndex.count
        }
        else {
            return instruIndex.count
        }
        
    }
    
    // The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        if genreCollection == collectionView {
            
            let cell: GenreCell = collectionView.dequeueReusableCellWithReuseIdentifier("genreCell", forIndexPath: indexPath) as! GenreCell
            
            var imageName: String = "btn" + genreIndex[indexPath.row]
            
            cell.imgEditGenre.image = UIImage(named: imageName)
            
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
        }
        else {
            
            let cell: InstruCell = collectionView.dequeueReusableCellWithReuseIdentifier("instruCell", forIndexPath: indexPath) as! InstruCell
            
            var imageName: String = "anonymous"//"btn" + genreIndex[indexPath.row]
            
            cell.imgInstru.image = UIImage(named: imageName)
            
            var tmpInstru = instruDict[instruIndex[indexPath.row]]
            
            if tmpInstru == true {
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
                
                if (genre.rangeOfString(genreIndex[indexPath.row]) != nil) {
                    var str = genreIndex[indexPath.row] + ":"
                    
                    let aString: String = genre
                    let newString = aString.stringByReplacingOccurrencesOfString(str, withString: "")
                    
                    genre = newString
                }
            }
            else {
                genreDict[genreIndex[indexPath.row]] = true
                
                if ((genre).rangeOfString(genreIndex[indexPath.row]) == nil) {
                    genre = genre + genreIndex[indexPath.row] + ":"
                }
            }
            
            //println(genre)
            genreCollection.reloadData()
        }
        else {
            if (instruDict[instruIndex[indexPath.row]] == true) {
                instruDict[instruIndex[indexPath.row]] = false
                
                if (instru.rangeOfString(instruIndex[indexPath.row]) != nil) {
                    var str = instruIndex[indexPath.row] + ":"
                    
                    let aString: String = instru
                    let newString = aString.stringByReplacingOccurrencesOfString(str, withString: "")
                    
                    instru = newString
                }
            }
            else {
                instruDict[instruIndex[indexPath.row]] = true
                
                if ((instru).rangeOfString(instruIndex[indexPath.row]) == nil) {
                    instru = instru + instruIndex[indexPath.row] + ":"
                }
            }
            
            println(instru)
            instruCollection.reloadData()
        }
        
    
}
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        
//    }
    

}
