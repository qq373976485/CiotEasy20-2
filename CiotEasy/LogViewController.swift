//
//  LogViewController.swift
//  WiotEasy
//
//  Created by Vincent on 2015/5/15.
//  Copyright (c) 2015年 Vincent. All rights reserved.
//

import UIKit

class LogViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //logView.scrollRangeToVisible(NSMakeRange(countElements(logView.text) characters"), 1)
        
      
        
    }
    
    override func viewWillAppear(animated: Bool) {
        
        logView.text = logtext0
        
        
        self.logView.scrollRangeToVisible(NSRange(location: count(logView.text!), length: 0))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var logView: UITextView!

    @IBAction func pressClear(sender: AnyObject) {
        
        logtext0 = ""
        var thisdate：NSDate = NSDate()
        var thisdate = NSCalendar.currentCalendar()
        var formatter:NSDateFormatter = NSDateFormatter()
        //formatter.dateFormat = "[yyyy/MM/dd HH:mm:ss.SSS]"
        formatter.dateFormat = "[HH:mm:ss.SSS]"
        var dateString1 = formatter.stringFromDate(thisdate：NSDate)
        
        logtext0 = logtext0 + dateString1 + "Command:CLEAR\n"
      
        logView.text = ""
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
