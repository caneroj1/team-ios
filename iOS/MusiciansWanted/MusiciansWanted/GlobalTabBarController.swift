//
//  GlobalTabBarController.swift
//  MusiciansWanted
//
//  Created by Nick on 3/12/15.
//  Copyright (c) 2015 iOS Team. All rights reserved.
//

import UIKit

extension UIImage {
    func imageWithColor(tintColor: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        
        let context = UIGraphicsGetCurrentContext() as CGContextRef
        CGContextTranslateCTM(context, 0, self.size.height)
        CGContextScaleCTM(context, 1.0, -1.0);
        CGContextSetBlendMode(context, kCGBlendModeNormal)
        
        let rect = CGRectMake(0, 0, self.size.width, self.size.height) as CGRect
        CGContextClipToMask(context, rect, self.CGImage)
        tintColor.setFill()
        CGContextFillRect(context, rect)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext() as UIImage
        UIGraphicsEndImageContext()
        
        return newImage
    }
}

class GlobalTabBarController: UITabBarController {
    var refreshToken:String = ""
    var userID:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // you can add this code to you AppDelegate application:didFinishLaunchingWithOptions:
        // or add it to viewDidLoad method of your TabBarController class
        //let tabcolor1 = UIColor(red: 240.0/255.0, green: 240.0/255.0, blue: 239.0/255.0, alpha: 1.0)
        let tabcolor1 = UIColor(red: 110.0/255.0, green: 110.0/255.0, blue: 110.0/255.0, alpha: 1.0)
        let tabcolor2 = UIColor(red: 255.0/255.0, green: 90.0/255.0, blue: 0.0/255.0, alpha: 1.0)
        let tabbarcolor = UIColor(red: 15.0/255.0, green: 15.0/255.0, blue: 15.0/255.0, alpha: 0.5)

        UITabBar.appearance().barTintColor = tabbarcolor
        UINavigationBar.appearance().barTintColor = tabbarcolor
        
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: tabcolor1], forState:.Normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: tabcolor2], forState:.Selected)
        
        self.tabBar.tintColor = tabcolor2
        
        for item in self.tabBar.items as [UITabBarItem] {
            if let image = item.image {
                item.image = image.imageWithColor(tabcolor1).imageWithRenderingMode(.AlwaysOriginal)
            }
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
