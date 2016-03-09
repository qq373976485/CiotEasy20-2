//
//  SensorController.swift
//  WiotEasy
//
//  Created by Vincent on 2015/7/30.
//  Copyright (c) 2015年 Vincent. All rights reserved.
//

import WatchKit
import Foundation


class SensorController: WKInterfaceController {
    
    var sensorTemp0 = 0.0
    var sensorHumi0 = 0.0
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        // Configure interface objects here.
        openParent("Request Sensor")
        
        self.sensor1temp.setText( toString(sensorTemp0) )
        self.sensor1humi.setText( toString(sensorHumi0) )
        
        
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
        
        
        
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    // カウントラベル
    func openParent(statusCode: String) {
        var userInfo = ["Command" : statusCode]
        // openParentApplication:reply:メソッド iPhone側の親アプリを起動
        WKInterfaceController.openParentApplication(userInfo, reply: { (data, error) in
            if let error = error {
                
                // 応答 失敗 ["response" : "fail"]
                println(error)
            }
            if let data = data {
                
                // 応答 成功 [response: success]
                println(data)
                
                let delayInSeconds = 0.8
                
                let popTime = dispatch_time(DISPATCH_TIME_NOW,Int64(delayInSeconds * Double(NSEC_PER_SEC)))
                dispatch_after(popTime, self.GlobalMainQueue){
                    
                    // do stuff here
                    
                    self.sensorTemp0 = (data["tempValue"] as? Double)!
                    self.sensorHumi0 = (data["humiValue"] as? Double)!
                    
                    self.sensor1temp.setText( toString(self.sensorTemp0) + " ˚C" )
                    self.sensor1humi.setText( toString(self.sensorHumi0) + " %RH" )
                    
                    wdaTempval0 = self.sensorTemp0
                    wdaHumival0 = self.sensorHumi0
                    
                }
            }
        })
    }
    
    var GlobalMainQueue: dispatch_queue_t {
        return dispatch_get_main_queue()
    }
    

    @IBOutlet weak var sensor1temp: WKInterfaceLabel!
    
    @IBOutlet weak var sensor1humi: WKInterfaceLabel!
    
}