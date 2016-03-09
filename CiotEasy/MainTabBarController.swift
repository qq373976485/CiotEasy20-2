//
//  MainTabBarController.swift
//  WiotEasy
//
//  Created by Vincent on 2015/5/13.
//  Copyright (c) 2015年 Vincent. All rights reserved.
//

import UIKit


// set Global var here
var appFirstTimeUse0 = true
var url0 = NSURL(string: "http://www.baidu.com")
var myip0 = "192.168.1.101"
var serverip0 = "192.168.1.100"
var serverport0 = 6000
var serverAutoReply0 = false
var serverBackground0 = false
var sendTimeStamp0 = false

var serverTx0 = "OK"
var clientTx0 = "Set FAN1 80/100"
var clientSlider10 = 0
var clientSwitch0 = false
var logtext0 = "Welcome to Use Ainjet's APP\n"
var connetButtonStaus = false
var serverButtonStaus = false

var sensorID0 = "0000-0000"
var temperatureValue0 = 32.25
var humidityValue0 = 78.50


// Net working config

var host = "192.168.1.53"
var port = 6000
var connectionError: NSError?
var tcpArrays:NSMutableArray = NSMutableArray()

class MainTabBarController: UITabBarController {
    
    

    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        loadSetup()
            
        println("server ip: \(serverip0)")
        
        
        // set default tab bar to Client
        self.selectedIndex = 2
        
        
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
    
    //read UserSetup file
    
    func loadSetup() {
        // getting path to GameData.plist
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true) as NSArray
        let documentsDirectory = paths[0] as! String
        
        let path = documentsDirectory.stringByAppendingPathComponent("UserSetup.plist")
        let fileManager = NSFileManager.defaultManager()
        //check if file exists
        if(!fileManager.fileExistsAtPath(path)) {
            // If it doesn't, copy it from the default file in the Bundle
            if let bundlePath = NSBundle.mainBundle().pathForResource("UserSetup", ofType: "plist") {
                let resultDictionary = NSMutableDictionary(contentsOfFile: bundlePath)
                println("Bundle UserSetup.plist file is --> \(resultDictionary?.description)")
                fileManager.copyItemAtPath(bundlePath, toPath: path, error: nil)
                println("copy")
            } else {
                println("UserSetup.plist not found. Please, make sure it is part of the bundle.")
            }
        } else {
            println("UserSetup.plist already exits at path.")
            // use this to delete file from documents directory
            //fileManager.removeItemAtPath(path, error: nil)
        }
        let resultDictionary = NSMutableDictionary(contentsOfFile: path)
        println("Loaded UserSetup.plist file is --> \(resultDictionary?.description)")
        var myDict = NSDictionary(contentsOfFile: path)
        if let dict = myDict {
            // loading values
            // bedroomFloorID = dict.objectForKey(BedroomFloorKey)!
            // bedroomWallID = dict.objectForKey(BedroomWallKey)!
           
           // appFirstUse0 = dict.objectForKey("DaFristTimeUse") as! Bool
           // url0 = dict.objectForKey("DaUrl") as? NSURL
           // myip0 = dict.objectForKey("DaDeviceIp") as! String
           serverip0 = dict.objectForKey("DaServerIp") as! String
           serverport0 = dict.objectForKey("DaPortNumber") as! Int
           sendTimeStamp0 = dict.objectForKey("DaSendWithTimeAuto") as! Bool
            
            
           serverAutoReply0 = dict.objectForKey("DaServerAutoReply") as! Bool
           serverBackground0 = dict.objectForKey("DaServerRGBbackground") as! Bool
           serverTx0 = dict.objectForKey("DaServerTx") as! String
           clientTx0 = dict.objectForKey("DaClientTx") as! String
           
            
            //...
        } else {
            println("WARNING: Couldn't create dictionary from UserSetup.plist! Default values will be used!")
        }
    }
    
    

}
