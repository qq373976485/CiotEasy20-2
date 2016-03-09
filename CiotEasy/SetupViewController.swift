//
//  SetupViewController.swift
//  WiotEasy
//
//  Created by Vincent on 2015/5/15.
//  Copyright (c) 2015年 Vincent. All rights reserved.
//

import UIKit

class SetupViewController: UIViewController, UITextFieldDelegate {
    
    @IBAction func pressSave(sender: AnyObject) {
        
          serverip0 = keyinServerIp.text!
        
          serverport0 = keyinServerPort.text.toInt()!
        
          sendTimeStamp0 = switchTimeStamp.on
  
          println("server ip: \(serverip0)")
          println("server port: \(serverport0)")
       
        if sendTimeStamp0{
            println("send time stamp is:ture")
        }else
        {
            println("send time stamp is:false")
        }
        
        var thisdate：NSDate = NSDate()
        var thisdate = NSCalendar.currentCalendar()
        var formatter:NSDateFormatter = NSDateFormatter()
        //formatter.dateFormat = "[yyyy/MM/dd HH:mm:ss.SSS]"
        formatter.dateFormat = "[HH:mm:ss.SSS]"
        var dateString1 = formatter.stringFromDate(thisdate：NSDate)
        logtext0 = logtext0 + dateString1 + "Command:SAVE\n"
        
        
         SaveUserSetup()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        keyinServerIp.text = serverip0
        keyinServerPort.text = toString( serverport0)
        switchTimeStamp.on = sendTimeStamp0
        

        
        // Do any additional setup after loading the view.

        [self .addUITextField()];
        
        startObservingKeyboardEvents()
        
    }

    override func viewWillAppear(animated: Bool) {
        // get last IP address for wifi
        deviceIP.text = getWiFiAddress()
    
        myip0 = deviceIP.text!
        
        
    }
   
    
 
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(animated: Bool) {
        if serverip0 != keyinServerIp.text || serverport0 != keyinServerPort.text.toInt() {
            showAlart()
        }
    }
    
    
 
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
/*
    @IBAction func keyinServerIp(sender: AnyObject) {
        serverip0 = txServerIP.text
        // println("server ip \(serverip0)")
    }
    @IBOutlet weak var txServerIP: UITextField!
*/
 
    @IBOutlet weak var deviceIP: UILabel!

    @IBOutlet weak var keyinServerIp: UITextField!
    
    @IBOutlet weak var keyinServerPort: UITextField!
    
    @IBOutlet weak var switchTimeStamp: UISwitch!
    
    
    func showAlart(){
        let alertController = UIAlertController(title: "Alart Changed", message: "Server IP or Port was changed, but no Save! Change abord.", preferredStyle: UIAlertControllerStyle.Alert)
        
        
        //alertController.addAction(UIAlertAction(title: "Save Key1", style: UIAlertActionStyle.Default, handler: nil))
        let saveAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default){ (action) -> Void in
            //add some code...
            
            //println("pressed Save")
            //self.SaveUserSetup()
            println("press OK, Cancel Change")
            self.keyinServerIp.text = serverip0
            self.keyinServerPort.text = toString(serverport0)
            
            
        }
        alertController.addAction(saveAction)
        /*
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default) { (action) -> Void in
            //add some code...
            println("pressed Cancel")
            self.keyinServerIp.text = serverip0
            self.keyinServerPort.text = toString(serverport0)
        }
        alertController.addAction(cancelAction)
        */
        
        self.presentViewController(alertController, animated: true, completion: nil)
        
    }


    //save UserSetup file
    func SaveUserSetup(){
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true) as NSArray
        let documentsDirectory = paths.objectAtIndex(0) as! NSString
        
        let path = documentsDirectory.stringByAppendingPathComponent("UserSetup.plist")
        var dict: NSMutableDictionary = ["DaSaveTime": NSDate()]
        //saving values
        // dict.setObject(bedroomFloorID, forKey: BedroomFloorKey)
        //dict.setObject(bedroomWallID, forKey: BedroomWallKey)
        //...
        dict.setObject(appFirstTimeUse0, forKey: "DaFristTimeUse")
        // dict.setObject( url0 as! String, forKey: "DaUrl")
        
        
        dict.setObject(myip0, forKey: "DaFristTimeUse")
        dict.setObject(serverip0, forKey: "DaServerIp")
        dict.setObject(serverport0, forKey: "DaPortNumber")
        
        dict.setObject(sendTimeStamp0, forKey: "DaSendWithTimeAuto")
        dict.setObject(serverAutoReply0, forKey: "DaServerAutoReply")
        dict.setObject(serverBackground0, forKey: "DaServerRGBbackground")
        dict.setObject(serverTx0, forKey: "DaServerTx")
        dict.setObject(clientTx0, forKey: "DaClientTx")
        
        // user define protocol write here
        
        
        
        //writing to GameData.plist
        dict.writeToFile(path, atomically: false)
        let resultDictionary = NSMutableDictionary(contentsOfFile: path)
        println("Saved UserSetup.plist file is --> \(resultDictionary?.description)")
        
        
    }
    
    func getIFAddresses() -> [String] {
        var addresses = [String]()
        
        // Get list of all interfaces on the local machine:
        var ifaddr : UnsafeMutablePointer<ifaddrs> = nil
        if getifaddrs(&ifaddr) == 0 {
            
            // For each interface ...
            for (var ptr = ifaddr; ptr != nil; ptr = ptr.memory.ifa_next) {
                let flags = Int32(ptr.memory.ifa_flags)
                var addr = ptr.memory.ifa_addr.memory
                
                // Check for running IPv4, IPv6 interfaces. Skip the loopback interface.
                if (flags & (IFF_UP|IFF_RUNNING|IFF_LOOPBACK)) == (IFF_UP|IFF_RUNNING) {
                    if addr.sa_family == UInt8(AF_INET) || addr.sa_family == UInt8(AF_INET6) {
                        
                        // Convert interface address to a human readable string:
                        var hostname = [CChar](count: Int(NI_MAXHOST), repeatedValue: 0)
                        if (getnameinfo(&addr, socklen_t(addr.sa_len), &hostname, socklen_t(hostname.count),
                            nil, socklen_t(0), NI_NUMERICHOST) == 0) {
                                if let address = String.fromCString(hostname) {
                                    addresses.append(address)
                                }
                        }
                    }
                }
            }
            freeifaddrs(ifaddr)
        }
        
        return addresses
    }
    
    // Return IP address of WiFi interface (en0) as a String, or `nil`
    func getWiFiAddress() -> String? {
        var address : String?
        
        // Get list of all interfaces on the local machine:
        var ifaddr : UnsafeMutablePointer<ifaddrs> = nil
        if getifaddrs(&ifaddr) == 0 {
            
            // For each interface ...
            for (var ptr = ifaddr; ptr != nil; ptr = ptr.memory.ifa_next) {
                let interface = ptr.memory
                
                // Check for IPv4 or IPv6 interface:
                let addrFamily = interface.ifa_addr.memory.sa_family
                if addrFamily == UInt8(AF_INET) || addrFamily == UInt8(AF_INET6) {
                    
                    // Check interface name:
                    if let name = String.fromCString(interface.ifa_name) where name == "en0" {
                        
                        // Convert interface address to a human readable string:
                        var addr = interface.ifa_addr.memory
                        var hostname = [CChar](count: Int(NI_MAXHOST), repeatedValue: 0)
                        getnameinfo(&addr, socklen_t(interface.ifa_addr.memory.sa_len),
                            &hostname, socklen_t(hostname.count),
                            nil, socklen_t(0), NI_NUMERICHOST)
                        address = String.fromCString(hostname)
                    }
                }
            }
            freeifaddrs(ifaddr)
        }
        
        return address
    }
    
    
    // keyboard Event
    
    func addUITextField(){
        
        keyinServerIp.delegate = self
        
    }
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        //  if(self.textF==textField || self.text2==textField ){
        
        textField.resignFirstResponder()
        //  }
        
        return true
        
    }
    
    /*
    func textFieldDidBeginEditing(textField: UITextField) {
    if(self.sensor1temp==textField || self.sensor1humi==textField ){
    
    animateViewMoving(true, moveValue: 200)
    }
    
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
    if(self.sensor1temp==textField || self.sensor1humi==textField ){
    
    animateViewMoving(false, moveValue: 200)
    }
    }
    */
    
    func animateViewMoving (up:Bool, moveValue :CGFloat){
        var movementDuration:NSTimeInterval = 0.3
        var movement:CGFloat = ( up ? -moveValue : moveValue)
        UIView.beginAnimations( "animateView", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(movementDuration )
        self.view.frame = CGRectOffset(self.view.frame, 0,  movement)
        UIView.commitAnimations()
    }
    
    
    /*
    // 鍵盤事件, 背景升高與降低
    func keyboardWillShow(sender: NSNotification) {
    self.view.frame.origin.y -= 160
    }
    func keyboardWillHide(sender: NSNotification) {
    self.view.frame.origin.y += 160
    }
    */
    
    // stock overflow
    private func startObservingKeyboardEvents() {
        NSNotificationCenter.defaultCenter().addObserver(self,
            selector:Selector("keyboardWillShow:"),
            name:UIKeyboardWillShowNotification,
            object:nil)
        NSNotificationCenter.defaultCenter().addObserver(self,
            selector:Selector("keyboardWillHide:"),
            name:UIKeyboardWillHideNotification,
            object:nil)
    }
    
    private func stopObservingKeyboardEvents() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            if let keyboardSize: CGSize = userInfo[UIKeyboardFrameEndUserInfoKey]?.CGRectValue().size {
                let contentInset = UIEdgeInsetsMake(0.0, 0.0, keyboardSize.height, 0.0);
            }
        }
        
    }
    
    func keyboardWillHide(notification: NSNotification) {
        let contentInset = UIEdgeInsetsZero;
        
    }
    
    
    
}
