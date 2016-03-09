//
//  GuideViewController.swift
//  WiotEasy
//
//  Created by Vincent on 2015/5/13.
//  Copyright (c) 2015年 Vincent. All rights reserved.
//

import UIKit

class GuideViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        
        // load webvew http address set here
        // var url = NSURL( string:"http://www.cuhere.com.cn")
        

        
        var res = NSBundle.mainBundle().pathForResource("CiotEasy",ofType:"html")
        var url = NSURL(fileURLWithPath: res!)
        var request = NSURLRequest(URL:url!)
        
        //var url = url0
        //var request = NSURLRequest(URL: url!)
        
        webview.loadRequest(request)
        
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
    @IBOutlet weak var webview: UIWebView!
    
    

}
