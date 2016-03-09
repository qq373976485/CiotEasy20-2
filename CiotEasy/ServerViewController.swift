//
//  ServerViewController.swift
//  WiotEasy
//
//  Created by Vincent on 2015/5/15.
//  Copyright (c) 2015年 Vincent. All rights reserved.
//

import UIKit


class ServerViewController: UIViewController ,UITextFieldDelegate{
    
    var tcpSocket : GCDAsyncSocket?
    var serverSocket : GCDAsyncSocket?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        sensorID0 = (UIDevice.currentDevice().identifierForVendor.UUIDString)
        sensorID0 = (sensorID0 as NSString).substringFromIndex(24)
        
        // setting for keyboard step:1/4
        [self .addUITextField()];

        
        
    }
    
    // setting for keyboard step:2/4
    func addUITextField(){
        
        keyinServerTx.delegate = self
        sensor1temp.delegate = self
        sensor1humi.delegate = self

        
    }
    
    // setting for keyboard step:3/4
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        //  if(self.textF==textField || self.text2==textField ){
        
        textField.resignFirstResponder()
        //  }
        
        return true
        
    }
    

    override func viewWillAppear(animated: Bool) {
      
        // get wifi IP address
        serverIP.text = getWiFiAddress()
        
        
        serverPort.text = toString(serverport0)
        switchAutoReply.on = serverAutoReply0
        // switchRGB.on  = serverBackground0
        keyinServerTx.text = serverTx0
        

        startObservingKeyboardEvents()
        
        
    }
    
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(true)
        
        stopObservingKeyboardEvents()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
  
    @IBAction func pressAutoReply(sender: AnyObject) {
        serverAutoReply0=switchAutoReply.on
        if serverAutoReply0{
           println("press Server AutoReply ON");
            
        }else{
           println("press Server AutoReply OFF");
            
        }
        
    }
    

    @IBOutlet weak var serverButton: UIButton!
    
    @IBAction func pressStart(sender: AnyObject) {
        
        println("press Server Connect");
        
        if !serverButtonStaus {
            // start Server here
            //var server:TCPServer = TCPServer(addr: "127.0.0.1", port: 6000)
            // server = TCPServer(addr: "127.0.0.1", port: serverport0)
            
            self.tcpSocket = GCDAsyncSocket(delegate: self, delegateQueue: dispatch_get_main_queue())
            tcpSocket?.acceptOnPort( 6000, error: &connectionError)
            
            if connectionError != nil {
                println("server 網路錯誤")
                println(connectionError)
            }
            else{
                println("server port成功")
                serverButtonStaus = true
                serverButton.backgroundColor=UIColor.greenColor()
            }
            
            
        }else{
            // disconnect TCPIP server
            serverButtonStaus = false
            serverButton.backgroundColor=UIColor.yellowColor()
            tcpSocket?.disconnect()
            
            
            
            
        }
        
        
    }
 
    @IBOutlet weak var serverIP: UILabel!
    @IBOutlet weak var serverPort: UITextField!

    @IBOutlet weak var clientIP: UILabel!
    
    @IBOutlet weak var serverRx: UILabel!
    
    @IBOutlet weak var switchAutoReply: UISwitch!
    

    @IBOutlet weak var keyinServerTx: UITextField!
 
    
    @IBAction func pressSend(sender: AnyObject) {
        // add here
        logtext0 = logtext0 + "Tx:"
        if sendTimeStamp0 {
            
            var thisdate：NSDate = NSDate()
            var thisdate = NSCalendar.currentCalendar()
            var formatter:NSDateFormatter = NSDateFormatter()
            //formatter.dateFormat = "[yyyy/MM/dd HH:mm:ss.SSS]"
            formatter.dateFormat = "[HH:mm:ss.SSS]"
            var dateString1 = formatter.stringFromDate(thisdate：NSDate)
            
            let txdata1:NSData! = (dateString1 as NSString).dataUsingEncoding(NSUTF8StringEncoding)
            tcpSocket?.writeData(txdata1, withTimeout:-1, tag: 0)
            
            
            logtext0 = logtext0 + dateString1
        }
        
        //f.writeData((message as NSString).dataUsingEncoding(NSUTF8StringEncoding)!)
        let txdata2:NSData! = (keyinServerTx.text as NSString).dataUsingEncoding(NSUTF8StringEncoding)
        tcpArrays[0].writeData(txdata2, withTimeout:-1, tag: 0)
   
        logtext0 = logtext0 + keyinServerTx.text + "\n"
        
        
        
    }
    
    
    @IBOutlet weak var statusLED1: UILabel!
    
    @IBOutlet weak var statusLED2: UILabel!
    
    @IBOutlet weak var statusFAN1: UILabel!
    
    @IBOutlet weak var statusPlug1: UILabel!
    
    @IBOutlet weak var sensor1temp: UITextField!
    
    
    @IBOutlet weak var sensor1humi: UITextField!
    

    // GCDsocket funtions
    func socket(sock: GCDAsyncSocket!, didConnectToHost host: String!, port: UInt16) {
        println("Info___didConnectToHost: \(host) port \(port)")
        self.tcpSocket?.readDataWithTimeout(-1, tag: 0)
        println("index of Array: \( String( tcpArrays.indexOfObject(sock)))")

        
        
    }
    
    func socket(sock: GCDAsyncSocket, didAcceptNewSocket newSocket: GCDAsyncSocket!)
    {
        
        println("New socket received: \(newSocket.connectedHost)")
        // self.tcpSocket?.readDataWithTimeout(10000, tag: 0)
        
        println("Local socket with host:\(sock.connectedHost) and port:\(sock.connectedPort) accepts new socket with host:\(newSocket.connectedHost) and port:\(newSocket.connectedPort))");
        
        
        newSocket.readDataWithTimeout(-1, tag: 0)
        
        tcpArrays.addObject(newSocket)

        
        //
        clientIP.text = newSocket.connectedHost
        
        
    }
    
    
    
    
    
    // self.tcpSocket?.readDataWithTimeout(-1, tag: 0)
    
    
    
    // Updating socket
    //self.tcpSocket = newSocket;.retain
    
    //self.socketNew = newSocket
    
    //Read data from socket
    //let size = sizeof(UInt64);
    //let size = sizeof(UInt64);
    //newSocket.readDataToLength(UInt(size), withTimeout: -1.0, tag: 0);
    // NSRunLoop.currentRunLoop().addTimer(<#timer: NSTimer#>, forMode: <#String#>)
    //arrays.addObject(newSocket)
    
    
    
    // self.tcpSocket? = newSocket
    //
    // let dataTx:NSData! = ("Hello" as NSString).dataUsingEncoding(NSUTF8StringEncoding)
    // newSocket.writeData(dataTx, withTimeout: -1, tag: 0)
    
    // tcpSocket?.writeData(dataTx, withTimeout: -1, tag: 0)
    
    
    // let dataTx:NSData! = ("Hello" as NSString).dataUsingEncoding(NSUTF8StringEncoding)
    
    // tcpSocket?.writeData( dataTx , withTimeout:-1, tag: 0)
    
    
    func socket(sock: GCDAsyncSocket, wantsRunLoopForNewSocket newSocket:GCDAsyncSocket!)->NSRunLoop{
        
        println("New socket RunLoop: \(newSocket.connectedHost)")
        return NSRunLoop.currentRunLoop()
        
        
    }
    
    func onSocketWillConnec(sock: GCDAsyncSocket)-> Bool
        
    {
        println("onSocketWillConnec: YES")
        return true
        
    }
    
    
    func socketDidDisconnect(sock: GCDAsyncSocket!, withError err: NSError!) {
        println("Info___socketDidDisconnect: \(err)")
        println("Socket with host:(sock.connectedHost) and port:(sock.connectedPort) is disconnected")
        
        println("index of Array: \( String( tcpArrays.indexOfObject(sock)))")
        tcpArrays.removeObject(sock)
        
        /*
        if ( tcpSocket == sock ){
        self.tcpSocket?.delegate = nil
        self.tcpSocket = nil
        }*/
        
    }
    
    
    
    func socket(sock: GCDAsyncSocket!, didReadData data: NSData!, withTag tag: Int) {
        println("Info___didReadData: \(NSString(data: data, encoding: NSUTF8StringEncoding) as! String)")
        
        // self.tcpSocket?.readDataWithTimeout(-1, tag: 0)
        println("Local socket with host:\(sock.connectedHost) and port:\(sock.connectedPort)");
        println("index of Array: \( String( tcpArrays.indexOfObject(sock)))")
        
        tcpArrays[tcpArrays.indexOfObject(sock)].readDataWithTimeout(-1, tag: 0)
        
        
        parserCommand(NSString(data: data, encoding: NSUTF8StringEncoding) as! String)
        
        /*
        let data2:NSData! = ("123" as NSString).dataUsingEncoding(NSUTF8StringEncoding)
        
        tcpSocket?.readDataToData(data2, withTimeout: -1, tag: 0)
        println("readdata length:\(data2.length)")
        println("readdata length:\(data2)")
        */
        
         serverRx.text = NSString(data: data, encoding: NSUTF8StringEncoding) as? String
        
    }
    
    
    
    
    
    /*
    func newSocket(sock: GCDAsyncSocket!, didReadData data: NSData!, withTag tag: Int) {
    
    println("Info___Server didReadData: \(NSString(data: data, encoding: NSUTF8StringEncoding) as! String)")
    self.tcpSocket?.readDataWithTimeout(-1, tag: 0)
    }
    */
    
    
    
    func socket(sock: GCDAsyncSocket!, willDisconnectWithError err: NSError!) {
        println("Info___willDisconnectWithError")
        
        serverButton.backgroundColor=UIColor.redColor()
        serverButtonStaus = false
        
    }
    
    
    func parserCommand( datastr: String){
        
        if datastr == "CheckLive Device1"
        {
            //tx: {"Temp": "tempvaule" , "Humi" : "humivaule"}
            
            let txdata1 = ("OK Device1")
            println(txdata1)
            
            let txdata2:NSData! = ( txdata1 as NSString).dataUsingEncoding(NSUTF8StringEncoding)
            tcpArrays[0].writeData(txdata2, withTimeout:-1, tag: 0)
            
            logtext0 = logtext0 + keyinServerTx.text + "\n"
   
        }
        
        if datastr == "Read Sensor1"
        {
            //tx: {"Temp": "tempvaule" , "Humi" : "humivaule"}
            
            let txdata1 = ("{\"Temp\":\"" + sensor1temp.text + "\" , \"Humi\" : \"" + sensor1humi.text + "\"}")
            println(txdata1)
            
            let txdata2:NSData! = ( txdata1 as NSString).dataUsingEncoding(NSUTF8StringEncoding)
            tcpArrays[0].writeData(txdata2, withTimeout:-1, tag: 0)
            
            logtext0 = logtext0 + keyinServerTx.text + "\n"
            
        }
        

        if datastr == "Set Led1 ON"
        {
            statusLED1.text = "LED1 ON"
            
        }
        
        if datastr == "Set Led1 OFF"
        {
       
            statusLED1.text = "LED1 OFF"        }
        
        if datastr == "Set Led2 ON"
        {
            
            statusLED2.text = "LED2 ON"        }
        
        if datastr == "Set Led2 OFF"
        {
            
            statusLED2.text = "LED2 OFF"
        }
        
        if datastr == "Set Switch1 ON"
        {
            statusPlug1.text = "Plug1 ON"
        }
        
        if datastr == "Set Switch1 OFF"
        {
            statusPlug1.text = "Plug1 OFF"
            
        }
        
        if datastr.hasPrefix("Set FAN1")
        {
            // 提取參數 ％2/5 , 介於 ％ 之後字符串
            //sendTxMessage("Set FAN1 " + ns1 )
            
            var ns1=(datastr as NSString).substringFromIndex(9)
            
            
            statusFAN1.text = "FAN1 %" + ns1
            
            
            
        }
    }
    
    
    
    
    /*
    class Connection : NSObject {
    var connected: Bool
    var tcpSocket: GCDAsyncSocket?
    var myHost: String = "192.168.1.53"
    var myPort: UInt16 = 6000
    
    override init() {
    connected = false
    }
    func initialize(host: String, port: UInt16) {
    
    }
    func connect() {
    tcpSocket = GCDAsyncSocket(delegate: self, delegateQueue: dispatch_get_main_queue())
    var connectionError: NSError?
    tcpSocket!.connectToHost(myHost, onPort: myPort, withTimeout: -1.0, error: &connectionError)
    
    
    }
    }
    */
  
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
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
    
    // setting for keyboard step:4/4
    func textFieldDidBeginEditing(textField: UITextField) {
        if(self.sensor1temp==textField || self.sensor1humi==textField || self.keyinServerTx==textField ){
            
            animateViewMoving(true, moveValue: 200)
        }
      
        
        
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        if(self.sensor1temp==textField || self.sensor1humi==textField || self.keyinServerTx==textField ){
            
            animateViewMoving(false, moveValue: 200)
        }
    }
    
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
