//
//  ContViewController.swift
//  WiotEasy
//
//  Created by Vincent on 2015/5/15.
//  Copyright (c) 2015年 Vincent. All rights reserved.
//

import UIKit

class ContViewController: UIViewController, UITextFieldDelegate, GCDAsyncSocketDelegate {
    
    
    
    var tcpSocket : GCDAsyncSocket?

    var rxdata : String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        // logtext0 = logtext0 + "start APP\n"

        self.tcpSocket = GCDAsyncSocket(delegate: self, delegateQueue: dispatch_get_main_queue())
        
        
        
        var thisdate：NSDate = NSDate()
        var thisdate = NSCalendar.currentCalendar()
        var formatter:NSDateFormatter = NSDateFormatter()
        //formatter.dateFormat = "[yyyy/MM/dd HH:mm:ss.SSS]"
        formatter.dateFormat = "[HH:mm:ss.SSS]"
        
        var dateString1 = formatter.stringFromDate(thisdate：NSDate)
        
        logtext0 = logtext0 + dateString1 + "Command:APP Start\n"

        // setting for keyboard step:1/4
        [self .addUITextField()];
        
        startObservingKeyboardEvents()
        
        //啟動時 自動创建socket
        // 設備未連線時, 彈出訊息 建立連線, 第一次建立連線時, 指令傳送會丟失
        
        if !connetButtonStaus {
            tcpSocket?.connectToHost( serverip0, onPort: 6000,  withTimeout: 2, error: &connectionError)
            
            if connectionError != nil {
                println("網路錯誤")
                println(connectionError)
            }
            else{
                println("連線成功")
                ConnectButton.backgroundColor=UIColor.greenColor()
                connetButtonStaus = true
                
                let data1:NSData! = ("Ainjet autoconnecting 221456" as NSString).dataUsingEncoding(NSUTF8StringEncoding)
                tcpSocket?.writeData(data1, withTimeout:-1, tag: 0)
                
                
            }
            
            
        }
        
 
        
    }
    
    override func viewWillAppear(animated: Bool) {
        
        
        serverPort.text = toString(serverport0)
        serverIp.text = serverip0
        
        keyinClientTx.text = clientTx0
        Slider1val.value = Float(clientSlider10)
        displaySlider1val.text = toString(Int(clientSlider10))
        
        
    }
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func addUITextField(){
        
        keyinClientTx.delegate = self
        
    }
    
    
    
    @IBOutlet weak var ConnectButton: UIButton!
    
    @IBAction func pressConnet(sender: AnyObject) {
  
         connetDevice()
    }
    
    
    
    @IBOutlet weak var serverIp: UITextField!
    
    @IBOutlet weak var serverPort: UITextField!
    
    @IBOutlet weak var keyinClientTx: UITextField!
    
    @IBOutlet weak var controllerRx: UILabel!
    
    @IBAction func pressButton1(sender: AnyObject) {
        sendTxMessage("Set Led1 ON")
        
    }
    
    
    @IBAction func pressSend(sender: AnyObject) {
        clientTx0 = keyinClientTx.text
        sendTxMessage(keyinClientTx.text)
        
        
    }
    
    
    @IBOutlet weak var clientRx: UILabel!
    
    @IBAction func pressButton1OFF(sender: AnyObject) {
        sendTxMessage("Set Led1 OFF")
    }
    
    @IBAction func pressButton2(sender: AnyObject) {
        sendTxMessage("Set Led2 ON")
    }
    
    @IBAction func pressButton2OFF(sender: AnyObject) {
        sendTxMessage("Set Led2 OFF")
    }
    
    @IBOutlet weak var Slider1val: UISlider!
    
    @IBOutlet weak var displaySlider1val: UILabel!
    
    @IBAction func pressSlider1(sender: AnyObject) {
        
        // println(Slider1val.value)
        let intSliderval = Int(Slider1val.value + 0.5)
        if clientSlider10 != intSliderval {
            
            clientSlider10 = intSliderval
            
            displaySlider1val.text = toString(Int(clientSlider10))
            
            
            sendTxMessage("Set FAN1 \(clientSlider10)" )
            
            
        }
        
        
    }
    
    @IBOutlet weak var Switch1val: UISwitch!

    @IBAction func pressSwitch1(sender: AnyObject) {
        
        if Switch1val.on{
            
            println("Switch1 is on")
            Switch1val.setOn(true, animated:true)
            clientSwitch0 = true
            
            sendTxMessage("Set Switch1 ON" )
            
        }else{
            println("Switch is off")
            Switch1val.setOn(false, animated:true)
            clientSwitch0 = false
            
            sendTxMessage("Set Switch1 OFF" )
        }

        
    }
    
    
    @IBAction func pressSensor1(sender: AnyObject) {
        readSensorStatus()
    }
    
    @IBAction func PressLiveButton(sender: AnyObject) {
        checkDeviceLive()
        
    }
    
    
    var GlobalMainQueue: dispatch_queue_t {
        return dispatch_get_main_queue()
    }
    
    
    
    
    @IBOutlet weak var CommandName: UILabel!
    
    
    func connetDevice(){
        println("press Connect");
        
        if !connetButtonStaus {
            
            //创建socket
            
            tcpSocket?.connectToHost( serverip0, onPort: 6000,  withTimeout: 2, error: &connectionError)
            
            if connectionError != nil {
                println("網路錯誤")
                println(connectionError)
            }
            else{
                println("連線成功")
                ConnectButton.backgroundColor=UIColor.greenColor()
                connetButtonStaus = true
                
                let data1:NSData! = ("Ainjet IOT " + sensorID0 as NSString).dataUsingEncoding(NSUTF8StringEncoding)
                tcpSocket?.writeData(data1, withTimeout:-1, tag: 0)
                
                //  let data2:NSData! = ("123" as NSString).dataUsingEncoding(NSUTF8StringEncoding)
                
                //  tcpSocket?.readDataToData(data2, withTimeout: -1, tag: 0)
                //  println("readdata length:\(data2.length)")
                
            }
            
            
        } else {
            
            // disconnect TCPIP client
            connetButtonStaus = false
            ConnectButton.backgroundColor=UIColor.yellowColor()
            tcpSocket?.disconnect()
            
            // let data1:NSData! = ("disconnect" as NSString).dataUsingEncoding(NSUTF8StringEncoding)
            // tcpSocket?.writeData(data1, withTimeout:1, tag: 0)
            // tcpSocket?.disconnectAfterWriting()
            
        }
    }
    
    
    func readSensorStatus(){
        if connetButtonStaus{
            
            var data1:NSData! = ("Read Sensor1" as NSString).dataUsingEncoding(NSUTF8StringEncoding)
            tcpSocket?.writeData(data1, withTimeout:-1, tag: 0)
            
            let delayInSeconds = 0.2
            
            let popTime = dispatch_time(DISPATCH_TIME_NOW,Int64(delayInSeconds * Double(NSEC_PER_SEC)))
            dispatch_after(popTime, GlobalMainQueue){
                
                // do stuff here
                println("my ReadData: " + self.rxdata!)
                
                
                
                //var content :String = "{\"temp\":\"32.77\",\"humi\":\"77.88\",\"form\":\"blog\"}"
                var content :String = self.rxdata!
                var testdata:NSData = NSData(bytes: content, length: count(content))
                
                var result0=NSString(data: testdata , encoding: NSUTF8StringEncoding)
                
                var error:NSError?
                
                //解析简单JSON 1
                var jsonObj1:AnyObject?=NSJSONSerialization.JSONObjectWithData(testdata, options: NSJSONReadingOptions.allZeros, error: &error);
                /*
                var error:NSError?
                var jsonObj1:AnyObject?=NSJSONSerialization.JSONObjectWithData( NSData(contentsOfFile: self.rxdata!)!, options: NSJSONReadingOptions.allZeros, error: &error);
                
                //NSJSONReadingOptions.allZeros
                //没有查到文档，但是好像都可以使用
                
                
                //NSJSONReadingMutableContainers
                //创建可变的数组或字典
                //
                //NSJSONReadingMutableLeaves
                //指定在JSON对象可变字符串被创建为NSMutableString的实例
                
                //NSJSONReadingAllowFragments
                //指定解析器应该允许不属于的NSArray或NSDictionary中的实例顶层对象
                */
                let tempstr = jsonObj1?.objectForKey("Temp") as! String
                
                let humistr = jsonObj1?.objectForKey("Humi") as! String
                
                println("Tempstr = \(tempstr)")
                println("Humistr = \(humistr)")
                temperatureValue0 = (tempstr as NSString).doubleValue
                humidityValue0 = (humistr as NSString).doubleValue
                
                
                
            }
            
            
            
            
        }else{
            // alart no server connection
            
            
            
        }
        
        
    }
    
    // 顯示控制指令(描述)  call from Apple Watch
    func showCommand(commandName: String) {
        CommandName.text = commandName
        println("from Watch Call:"+commandName)
        
        
        // Watch sending IOT command here
        if connetButtonStaus{
            watchSendTxMessage(commandName)
            
        }
        
    }
    
    // read 控制指令(描述)  call from Apple Watch
    func readCommand(commandName: String) {
        CommandName.text = commandName
        println("from Watch Call:"+commandName)
        
        
        // Watch sending IOT command here
        readSensorStatus()
        
        
    }
    
 
    func watchSendTxMessage(name: String){
        if name == "客廳燈開了"
        {
            println("command code: \(name)")
            //f.writeData(("set pinA1 on" as NSString).dataUsingEncoding(NSUTF8StringEncoding)!)
            //let data1:NSData! = ("Set Led1 ON" as NSString).dataUsingEncoding(NSUTF8StringEncoding)
            //tcpSocket?.writeData(data1, withTimeout:-1, tag: 0)
            sendTxMessage("Set Led1 ON")
        };
        
        if( name == "客廳燈關的")
        {
            println("These two strings are considered equal")
            //f.writeData(("set pinA1 off" as NSString).dataUsingEncoding(NSUTF8StringEncoding)!)
            //let data1:NSData! = ("Set Led1 OFF" as NSString).dataUsingEncoding(NSUTF8StringEncoding)
            //tcpSocket?.writeData(data1, withTimeout:-1, tag: 0)
            sendTxMessage("Set Led1 OFF")
        };
        
        if name == "led2on"
        {
            println("command code: \(name)")
            //f.writeData(("set pinA2 on" as NSString).dataUsingEncoding(NSUTF8StringEncoding)!)
            //let data1:NSData! = ("Set Led2 ON" as NSString).dataUsingEncoding(NSUTF8StringEncoding)
            //tcpSocket?.writeData(data1, withTimeout:-1, tag: 0)
            sendTxMessage("Set Led2 ON")
        };
        
        if( name == "led2off")
        {
            println("These two strings are considered equal")
            //f.writeData(("set pinA2 off" as NSString).dataUsingEncoding(NSUTF8StringEncoding)!)
            //let data1:NSData! = ("Set Led2 OFF" as NSString).dataUsingEncoding(NSUTF8StringEncoding)
            //tcpSocket?.writeData(data1, withTimeout:-1, tag: 0)
            sendTxMessage("Set Led2 OFF")
            
        };
        if( name == "插頭1-通電中")   //644pa1 PINA4
        {
            println("These two strings are considered equal")
            //f.writeData(("set pinA4 on" as NSString).dataUsingEncoding(NSUTF8StringEncoding)!)
            //let data1:NSData! = ("Set Plug1 ON" as NSString).dataUsingEncoding(NSUTF8StringEncoding)
            //tcpSocket?.writeData(data1, withTimeout:-1, tag: 0)
            sendTxMessage("Set Switch1 ON" )
            
            
        };
        if( name == "插頭1-斷電")     //644pa1 PINA4
        {
            println("These two strings are considered equal")
            //f.writeData(("set pinA4 off" as NSString).dataUsingEncoding(NSUTF8StringEncoding)!)
            //let data1:NSData! = ("Set Plug1 OFF" as NSString).dataUsingEncoding(NSUTF8StringEncoding)
            //tcpSocket?.writeData(data1, withTimeout:-1, tag: 0)
             sendTxMessage("Set Switch1 OFF" )
        };
        if( name == "讀取傳感器1")
        {
            println("These two strings are considered equal")
            //let data1:NSData! = ("Read Sensor1" as NSString).dataUsingEncoding(NSUTF8StringEncoding)
            //tcpSocket?.writeData(data1, withTimeout:-1, tag: 0)
             sendTxMessage("Read Sensor1" )
        };
        if( name.hasPrefix("設置風量") )
        {
            println("設置風量值為: ")
            var ns1=(name as NSString).substringFromIndex(5)

            sendTxMessage("Set FAN1 " + ns1 )
        };
        
    }

    func checkDeviceLive()-> Bool
    {
        var deviceLiveStatus = false
        
        
        if connetButtonStaus{
            
            var data1:NSData! = ("CheckLive Device1" as NSString).dataUsingEncoding(NSUTF8StringEncoding)
            tcpSocket?.writeData(data1, withTimeout:-1, tag: 0)
            
            let delayInSeconds = 0.2
            
            let popTime = dispatch_time(DISPATCH_TIME_NOW,Int64(delayInSeconds * Double(NSEC_PER_SEC)))
            dispatch_after(popTime, GlobalMainQueue){
                
                // do stuff here
                println("CheckLive Device1: " + self.rxdata!)
                
                
                
                //var content :String = "OK Device1"
                var content :String = self.rxdata!
                if content == "OK Device1"{
                    
                     println("CheckLive Device1: \(content)")
                     deviceLiveStatus = true
                }
                
                
            }
            
            
            
            
        }else{
            // alart no server connection
            
            
            
        }
        
        
        return deviceLiveStatus
        
    }
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    func sendTxMessage( message: String)
    {
        println(message)
        
        if connetButtonStaus{
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
            let txdata2:NSData! = (message as NSString).dataUsingEncoding(NSUTF8StringEncoding)
            tcpSocket?.writeData(txdata2, withTimeout:-1, tag: 0)
            
            logtext0 = logtext0 + message + "\n"
            
            
        }else{
            logtext0 = logtext0 + "Error: No Server Connected\n"
            
        }
        
        
        
        
        /*
        * 注意：当获取文件长度时
        * 此方法已经把整个文件读取到内存中，因此就没必要在分段读取数据到内存。
        NSData *data = [inFileHandle availableData];
        NSInteger fileSize = data.length;
        
        println("L3 d:" );
        let	d	=	f.readDataOfLength(10)  //讀取Buffer 10byte 字組
        println(NSString(data: d, encoding: NSUTF8StringEncoding)!)
        */
        
        
        
        // recive server echo to RX:
        /*
        let readbuf = f.availableData  //讀取Buffer 全部byte 字組
        
        let readRx = NSString(data: readbuf, encoding: NSUTF8StringEncoding)! as String
        
        clientRx.text = readRx
        println("Rx:\(clientRx.text)")
        
        logtext0 = logtext0 + "Rx:\(readRx)\n"
        */
        
        
    }
    
    // GDCSocket funtions
    
    func socket(sock: GCDAsyncSocket!, didWriteDataWithTag tag: Int) {
        println("WriteData_Tag: \(tag)")
        
    }
    
    
    
    func socket(sock: GCDAsyncSocket!, didConnectToHost host: String!, port: UInt16) {
        println("Info___didConnectToHost: \(host) port \(port)")
        self.tcpSocket?.readDataWithTimeout(-1, tag: 0)
        
    }
    
    func socket(sock: GCDAsyncSocket, didAcceptNewSocket newSocket: GCDAsyncSocket!)
    {
        println("New socket received: \(newSocket)")
    }
    
    
    func socketDidDisconnect(sock: GCDAsyncSocket!, withError err: NSError!) {
        println("Info___socketDidDisconnect: \(err)")
        if err != nil {
            ConnectButton.backgroundColor=UIColor.redColor()
            connetButtonStaus = false
            logtext0 = logtext0 + "[Error] Connecting error " + serverip0
            logtext0 = logtext0 + "\n"

        }else
        {
            ConnectButton.backgroundColor=UIColor.yellowColor()
            connetButtonStaus = false
            logtext0 = logtext0 + "[Info] Connecting close " + serverip0
            logtext0 = logtext0 + "\n"
        }
        
        
    }
    
    
    func socket(sock: GCDAsyncSocket!, didReadData data: NSData!, withTag tag: Int) {
        
        rxdata = (NSString(data: data, encoding: NSUTF8StringEncoding) as! String)
        println("Info___Client didReadData: " + rxdata!)
        
        
        self.tcpSocket?.readDataWithTimeout(-1, tag: 0)
        controllerRx.text = rxdata
        
        
    }
        
    
    
    //func socket(sock: GCDAsyncSocket!, willDisconnectWithError err: NSError!) {
    //    println("Info___willDisconnectWithError")
    //}
    
    
    
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
    
    // keyboard Event
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        //  if(self.textF==textField || self.text2==textField ){
        
        textField.resignFirstResponder()
        //  }
        
        return true
        
    }

 
    func textFieldDidBeginEditing(textField: UITextField) {
        if(self.keyinClientTx==textField ){
            
            animateViewMoving(true, moveValue: 200)
        }
        
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        if(self.keyinClientTx==textField ){
            
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
