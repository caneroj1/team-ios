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
    var timer = NSTimer()
    
    var inboxMgr = InboxManager()
    var msgManager = MessageManager()
    var messageId = -1
    var subject = ""
    
    @IBAction func sendMessage(sender: UIButton) {
        self.view.endEditing(true);
        
        var url: String = "/api/messages/\(messageId)/replies"
        
        var replyParams: Dictionary<String, AnyObject> = ["id": messageId, "body": textView.text, "user_id": MusiciansWanted.userId]
        
        /*
        {
        "body" : "New Message",
        "id" : 121,
        "message_id" : 51,
        "updated_at" : "2015-05-22T19:32:12.669Z",
        "user_id" : null,
        "created_at" : "2015-05-22T19:32:12.669Z"
        }
        */
        
        var params = ["reply": replyParams]
        
        DataManager.makePostRequest(url, params: params, completion: { (data, error) -> Void in
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
                    self.textView.textColor = UIColor.lightGrayColor()
                    self.textView.text = self.placeholder
                    let textViewFixedWidth: CGFloat = self.textView.frame.size.width
                    let newSize: CGSize = self.textView.sizeThatFits(CGSizeMake(textViewFixedWidth, CGFloat(MAXFLOAT)))
                    
                    if newSize.height > 100 {
                        self.textViewHeight.constant = 100
                    }
                    else {
                        self.textViewHeight.constant = newSize.height
                    }
                    
                    var ttlReplies = self.msgManager.replies.count < 1 ? 1 : self.msgManager.replies.count
                    
                    self.msgManager.loadMessages(self.messageId, lower: ttlReplies - 1, upper: ttlReplies)
                                        
                    return
                }
            }
        })

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
        let lightestGrayColor: UIColor = UIColor( red: 200.0/255.0, green: 200.0/255.0, blue:200.0/255.0, alpha: 1.0 )
        self.textView.layer.borderColor = lightestGrayColor.CGColor
        self.textView.layer.borderWidth = 0.6
        self.textView.layer.cornerRadius = 6.0
        self.textView.clipsToBounds = true
        self.textView.layer.masksToBounds = true
        
        msgManager.messageDelegate = self
    }
    
    func update() {
        self.msgManager.loadMessages(self.messageId, lower: 0, upper: 20)
        
        let numberOfSections = MsgTableView.numberOfSections()
        let numberOfRows = MsgTableView.numberOfRowsInSection(numberOfSections-1)
        
        if numberOfRows < msgManager.replyIndex.count {
            
            MsgTableView.reloadData()

            var scrolltimer = NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: Selector("scrollDown"), userInfo: nil, repeats: false)
        }

    }
    
    func scrollDown() {
        let numberOfSections = MsgTableView.numberOfSections()
        let numberOfRows = MsgTableView.numberOfRowsInSection(numberOfSections-1)
        let indexPath = NSIndexPath(forRow: numberOfRows-1, inSection: (numberOfSections-1))
        
        MsgTableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: UITableViewScrollPosition.Bottom, animated: false)
    }
    
    override func viewWillAppear(animated: Bool) {
        if textView.text == "" {
            textView.textColor = UIColor.lightGrayColor()
            textView.text = placeholder
        }
        
        self.title = subject
            
        msgManager.loadMessages(messageId, lower: 0, upper: 20)
        
        timer = NSTimer.scheduledTimerWithTimeInterval(10.0, target: self, selector: Selector("update"), userInfo: nil, repeats: true)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self)
        timer.invalidate()
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
        return msgManager.replyIndex.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let reply = msgManager.replies[msgManager.replyIndex[indexPath.row]]
        
        let cell: MessageBubbleCell = reply!.userId == MusiciansWanted.userId ? tableView.dequeueReusableCellWithIdentifier("senderCell", forIndexPath: indexPath) as! MessageBubbleCell : tableView.dequeueReusableCellWithIdentifier("receiverCell", forIndexPath: indexPath) as! MessageBubbleCell
                
        cell.msgHeader.text = reply!.userId == MusiciansWanted.userId ? "Sent " : reply!.name + " - "
        cell.msgHeader.text = cell.msgHeader.text! + inboxMgr.formatDate(reply!.date)
        
        cell.msgText.text = reply?.body
        
        let textViewFixedWidth = self.view.frame.size.width - 106
        let newSize = cell.msgText.sizeThatFits(CGSizeMake(textViewFixedWidth, CGFloat(MAXFLOAT)))
                
        msgManager.changeHeight(indexPath.row, height: newSize.height)
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let message = msgManager.replies[msgManager.replyIndex[indexPath.row]]
                
        return message!.messageHeight + 30
    }
    
    func addedNewMessage() {
        var addNewtimer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: Selector("update"), userInfo: nil, repeats: false)
    }
}
