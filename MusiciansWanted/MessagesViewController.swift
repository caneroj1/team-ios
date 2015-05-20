//
//  MessagesViewController.swift
//  MW
//
//  Created by Nick on 5/19/15.
//  Copyright (c) 2015 iOS Team. All rights reserved.
//

import UIKit

class MessagesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate, MessageDelegate {
    
    @IBOutlet var MsgTableView: UITableView!
    @IBOutlet var typeView: UIView!
    @IBOutlet var sendBtn: UIButton!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet var textViewHeight: NSLayoutConstraint!
    
    var kPreferredTextViewToKeyboardOffset: CGFloat = 0.0
    var keyboardFrame: CGRect = CGRect.nullRect
    var keyboardIsShowing: Bool = false
    let placeholder = "Send a message"
    
    var msgManager = MessageManager()
    
    @IBAction func sendMessage(sender: UIButton) {
        self.view.endEditing(true);
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        self.view.endEditing(true);
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
        
        // Make UITextView look like UITextField
        self.textView.contentInset = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0)
        self.textView.sizeToFit()
        let lightestGrayColor: UIColor = UIColor( red: 224.0/255.0, green: 224.0/255.0, blue:224.0/255.0, alpha: 1.0 )
        self.textView.layer.borderColor = lightestGrayColor.CGColor
        self.textView.layer.borderWidth = 0.6
        self.textView.layer.cornerRadius = 6.0
        self.textView.clipsToBounds = true
        self.textView.layer.masksToBounds = true
        
        msgManager.messageDelegate = self

    }
    
    override func viewWillAppear(animated: Bool) {
        if textView.text == "" {
            textView.textColor = UIColor.lightGrayColor()
            textView.text = placeholder
        }
        
        msgManager.loadMessages(msgManager.replies.count - 21, upper: msgManager.replies.count - 1)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func keyboardWillShow(notification: NSNotification)
    {
        self.keyboardIsShowing = true
        
        if let info = notification.userInfo {
            self.keyboardFrame = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
            self.arrangeViewOffsetFromKeyboard()
        }
        
    }
    
    func keyboardWillHide(notification: NSNotification)
    {
        self.keyboardIsShowing = false
        
        self.returnViewToInitialFrame()
    }
    
    func arrangeViewOffsetFromKeyboard()
    {
        var theApp: UIApplication = UIApplication.sharedApplication()
        var windowView: UIView? = theApp.delegate!.window!
        
        var textFieldLowerPoint: CGPoint = CGPointMake(self.typeView!.frame.origin.x, self.typeView!.frame.origin.y + self.typeView!.frame.size.height)
        
        var convertedTextViewLowerPoint: CGPoint = self.view.convertPoint(textFieldLowerPoint, toView: windowView)
        
        var targetTextViewLowerPoint: CGPoint = CGPointMake(self.typeView!.frame.origin.x, self.keyboardFrame.origin.y - kPreferredTextViewToKeyboardOffset)
        
        var targetPointOffset: CGFloat = targetTextViewLowerPoint.y - convertedTextViewLowerPoint.y
        var adjustedViewFrameCenter: CGPoint = CGPointMake(self.view.center.x, self.view.center.y + targetPointOffset)
        
        UIView.animateWithDuration(0.2, animations:  {
            self.view.center = adjustedViewFrameCenter
        })
    }
    
    func returnViewToInitialFrame()
    {
        var initialViewRect: CGRect = CGRectMake(0.0, 0.0, self.view.frame.size.width, self.view.frame.size.height)
        
        if (!CGRectEqualToRect(initialViewRect, self.view.frame))
        {
            UIView.animateWithDuration(0.2, animations: {
                self.view.frame = initialViewRect
            });
        }
    }
    
    func textViewDidBeginEditing(textView: UITextView) {
        if textView.text == placeholder {
            textView.textColor = UIColor.blackColor()
            textView.text = ""
        }
        
        if(self.keyboardIsShowing)
        {
            self.arrangeViewOffsetFromKeyboard()
        }
    }
    
    func textViewDidChange(textView: UITextView) {
        let textViewFixedWidth: CGFloat = self.textView.frame.size.width
        let newSize: CGSize = self.textView.sizeThatFits(CGSizeMake(textViewFixedWidth, CGFloat(MAXFLOAT)))
        
        if newSize.height > 100 {
            textViewHeight.constant = 100
        }
        else {
            textViewHeight.constant = newSize.height
        }
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        if textView.text == "" {
            textView.textColor = UIColor.lightGrayColor()
            textView.text = placeholder
        }
        
        textView.resignFirstResponder()
    }

    
    
    // MARK: - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        println("does this update automatically?")
        return msgManager.replies.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell: MessageBubbleCell = tableView.dequeueReusableCellWithIdentifier("senderCell", forIndexPath: indexPath) as! MessageBubbleCell
        
        let message = msgManager.replies[indexPath.row]
                
        cell.msgHeader.text = message.name
        cell.msgText.text = message.subject
        
        let textViewFixedWidth = self.view.frame.size.width - 106
        let newSize = cell.msgText.sizeThatFits(CGSizeMake(textViewFixedWidth, CGFloat(MAXFLOAT)))
        
        println(newSize.height)
        
        msgManager.changeHeight(indexPath.row, height: newSize.height)
        
        tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: .Bottom, animated: true)
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let message = msgManager.replies[indexPath.row]
                
        return message.messageHeight + 30
    }
    
    func addedNewMessage() {
        /*if self.refreshControl?.refreshing == true {
            self.refreshControl?.endRefreshing()
        }*/
        var indexP: NSIndexPath = NSIndexPath(forRow: msgManager.replies.count - 1, inSection: 0)
        
        self.MsgTableView.reloadRowsAtIndexPaths([indexP], withRowAnimation: UITableViewRowAnimation.None)
        
    }
}
