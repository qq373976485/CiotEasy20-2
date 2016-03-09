//
//  SensorViewController.swift
//  WiotEasy
//
//  Created by Vincent on 2015/7/27.
//  Copyright (c) 2015年 Vincent. All rights reserved.
//


import UIKit

class SensorViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        // load webvew http address set here
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        
        let delayInSeconds = 0.8
        
        let popTime = dispatch_time(DISPATCH_TIME_NOW,Int64(delayInSeconds * Double(NSEC_PER_SEC)))
        dispatch_after(popTime, GlobalMainQueue){
            
            // do stuff here
            self.tempval.text = toString(temperatureValue0)
            self.humival.text = toString(humidityValue0)
        
            self.sensorIDval.text = sensorID0
        }
        
    }

    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBOutlet weak var tempval: UILabel!
    
    @IBOutlet weak var humival: UILabel!
    

    @IBOutlet weak var sensorIDval: UILabel!

    var GlobalMainQueue: dispatch_queue_t {
        return dispatch_get_main_queue()
    }    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
    
}