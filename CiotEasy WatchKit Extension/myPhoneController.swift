//
//  myPhoneController.swift
//  WiotEasy
//
//  Created by Vincent on 2015/7/10.
//  Copyright (c) 2015年 Vincent. All rights reserved.
//


import WatchKit
import Foundation


class myPhoneController: WKInterfaceController {
    
    var led1status = false
    var led2status = false
    var plug1status = false
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        // Configure interface objects here.
        openParent("Request Device")
        
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        if wdaConnectStatus0{
            myDeviceStatus.setTitle("onLine")
        }else{
            myDeviceStatus.setTitle("unLink")
        
        }
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
                let abc = data["batteryValue"] as? String
                self.batteryLevel.setText(abc)
                
                self.phoneDeviceName.setText( (data["deviceName"] as? String) )
                self.phoneSystemVersion.setText( data["systemVersion"] as? String )
                self.phoneSystemName.setText( data["systemName"] as? String )
                self.internetStatus.setText( data["internetStatus"] as? String )
                self.myPhoneIP.setText( data["myPhoneIP"] as? String )
                wdaConnectStatus0 = (data["deviceConnectStatus"] as? Bool)!
                wdaSensorID0 = data["mySensorID"] as! String
                
                
                if wdaConnectStatus0{
                     self.myDeviceStatus.setBackgroundColor(UIColor.greenColor())
                }else{
                
                      self.myDeviceStatus.setBackgroundColor(UIColor.redColor())
                }
                self.mySensorID.setText(wdaSensorID0)
                
                
                
            }
        })
    }
    
    
    //(["response" : "success", "batteryValue": batteryValue, "deviceName":deviceName, "systemName" : systemName, "systemVersion": systemVersion ])
    
    @IBOutlet weak var batteryLevel: WKInterfaceLabel!
    
    @IBOutlet weak var phoneDeviceName: WKInterfaceLabel!

    @IBOutlet weak var phoneSystemVersion: WKInterfaceLabel!
    
    @IBOutlet weak var phoneSystemName: WKInterfaceLabel!
    
    @IBOutlet weak var internetStatus: WKInterfaceLabel!
    
    @IBOutlet weak var myPhoneIP: WKInterfaceLabel!
    
    @IBOutlet weak var myDeviceStatus: WKInterfaceButton!
    
    @IBOutlet weak var mySensorID: WKInterfaceLabel!
    
    @IBAction func pressStatusButton() {        
        openParent("Request Device")
    }
    
    
    
}
