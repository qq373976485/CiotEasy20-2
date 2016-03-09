//
//  DeviceViewController.swift
//  WiotEasy
//
//  Created by Vincent on 2015/5/16.
//  Copyright (c) 2015年 Vincent. All rights reserved.
//

import UIKit

class DeviceViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // UIDevice.currentDevice().batteryMonitoringEnabled = true
        
        let name = UIDevice.currentDevice().name
        let systemName = UIDevice.currentDevice().systemName
        let systemVersion = UIDevice.currentDevice().systemVersion
        let model = UIDevice.currentDevice().model
        let userIId = UIDevice.currentDevice().userInterfaceIdiom.hashValue
        
        let uuid = UIDevice.currentDevice().identifierForVendor.UUIDString
        let orientation = UIDevice.currentDevice().orientation
        let screenhight = UIScreen.mainScreen().bounds.height
        let screenwidth = UIScreen.mainScreen().bounds.width
        // let date =
        
        
        
        let time1970 = NSString(format: "%f", NSTimeIntervalSince1970)
        
        //UIDevice.currentDevice().batteryLevel
        UIDevice.currentDevice().batteryMonitoringEnabled = true
        let batterymointor = UIDevice.currentDevice().batteryMonitoringEnabled
        let battery1 :String = NSString(format: "%3.0f%%",UIDevice.currentDevice().batteryLevel*100) as! String
        var battery2 = ""
        if batterymointor {
            battery2 = "batteryMonitoringEnabled"
        }else
        {
            battery2 = "batteryMonitoring NOT Enabled"
        }
        
        let batterycharger = UIDevice.currentDevice().batteryState
        
        //       let networkstatus = SCNetworkReachability
        
        let infoDict = NSBundle.mainBundle().infoDictionary
        
        if let info = infoDict {
            // app名称
            let appName = info["CFBundleName"] as! String
            // app版本
            let appVersion = info["CFBundleShortVersionString"] as! String
            // app build版本
            let appBuild = info["CFBundleVersion"]as! String
            
            myname.text = name
            mydevice.text = systemName
            myversion.text = systemVersion
            mymodel.text = model
            mybattery.text = battery1 as String
            myuuid.text = uuid
            myscreenhight.text = NSString(format: "%.2f",screenhight) as String
            
            
            myscreenwide.text = NSString(format: "%.2f",screenwidth) as String
            
            
            
            
            
            println(appName)
            println(appVersion)
            println(appBuild)
            println(battery2)
            println(orientation)
            println(screenhight)
            println(screenwidth)
            println(time1970)
            println(userIId)
            
            
            
        }
        
        if Reachability.isConnectedToNetwork() == true {
            netstatus.text = "Internet OK"
            println("Internet connection OK")
        } else {
            println("Internet connection FAILED")
            netstatus.text = "No Internet Connection"
            var alert = UIAlertView(title: "No Internet Connection", message: "Make sure your device is connected to the internet.", delegate: nil, cancelButtonTitle: "OK")
            alert.show()
        }
        
        // myiplist.text = getIFAddresses()
        let ipcount = getIFAddresses().count
        println("ipcount = \(ipcount)")
        println("getIFAddresses = \(getIFAddresses())")
        // get last IP address for wifi
        //myip.text = getIFAddresses()[0]
        myip.text = getWiFiAddress()
        myip0 = myip.text!
        
        
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var myip: UILabel!
    
    @IBOutlet weak var myname: UILabel!
    @IBOutlet weak var mydevice: UILabel!
    @IBOutlet weak var myversion: UILabel!
    @IBOutlet weak var mymodel: UILabel!
    
    @IBOutlet weak var myscreenhight: UILabel!

    @IBOutlet weak var myscreenwide: UILabel!
    
    
    @IBOutlet weak var mybattery: UILabel!
    
    @IBOutlet weak var myuuid: UILabel!
    @IBAction func printsystem(sender: AnyObject) {
        
        println("appName")
        
        println("appVersion:")
        
        
        var now = NSDate()
        var formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T' HH:mm:ss.SSS 'Z'"
        // formatter.timeZone = NSTimeZone(forSecondsFromGMT: 0)
        //   formatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        //  println(formatter.stringFromDate(now))
        var dateString = formatter.stringFromDate(now)
        println(dateString)
        println("myip:\(getIFAddresses())")
        
        
    }
    
    @IBOutlet weak var netstatus: UILabel!
    
    
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
    
}
