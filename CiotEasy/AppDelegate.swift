//
//  AppDelegate.swift
//  WiotEasy
//
//  Created by Vincent on 2015/5/13.
//  Copyright (c) 2015年 Vincent. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    
    // rootViewController を PersonViewController にする
    var contViewController: ContViewController {
        return window?.rootViewController as! ContViewController
    }

    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


    func application(application: UIApplication, handleWatchKitExtensionRequest
        userInfo: [NSObject : AnyObject]?, reply: (([NSObject : AnyObject]!) -> Void)?) {
            
            // userInfo通知のデータを確認
            if let info = userInfo as? [String: String] {
                // personViewController メソッド：showPerson <- userInfo
                // ContViewController.showPerson(info["personName"]!)
                
                if info["Command"] == "Request Device"{
                    let batteryValue = getBatteryStatus()
                    
                    let deviceName = UIDevice.currentDevice().name
                    let systemName = UIDevice.currentDevice().systemName
                    let systemVersion = UIDevice.currentDevice().systemVersion
                    let internetStatus =  getInternetStatus()
                    // get wifi IP address
                    let myPhoneIP : String = getWiFiAddress()!
                    
                    
                    
                    // 応答 成功 "Command"== "Request Battery"
                    reply.map { $0(["response" : "success", "batteryValue": batteryValue, "deviceName": deviceName , "systemName" : systemName, "systemVersion": systemVersion, "internetStatus": internetStatus, "myPhoneIP": myPhoneIP, "deviceConnectStatus": connetButtonStaus , "mySensorID": sensorID0 ])
                    }
                    
                    
                }else{
                    
                    if info["Command"] == "Request Sensor"{
                       
                        // Get sansorID values
                        let sansorID = 170052

                        
                        if let rootViewController = self.window?.rootViewController as? UITabBarController{
                            
                            
                            if let viewControllers = rootViewController.viewControllers {
                                for navigationController in viewControllers {
                                    if let yourViewController = navigationController.topViewController as?       ContViewController {
                                        //if yourViewController.hasSomeFlag {
                                        yourViewController.readCommand(info["Command"]!)
                                        
                                        
                                        //}
                                        break
                                    }
                                }
                            }
                            
                        }
                        
                        
                        let delayInSeconds = 0.3
                        
                        let popTime = dispatch_time(DISPATCH_TIME_NOW,Int64(delayInSeconds * Double(NSEC_PER_SEC)))
                        dispatch_after(popTime, GlobalMainQueue){

                        
                        reply.map { $0(["response" : "success", "tempValue": temperatureValue0, "humiValue": humidityValue0  ] )
                            }
                            
                        }
                        
                        
                    }else{
                        
                        // userInfo, info["Command"] == "Command"
                        // let myViewController:ContViewController = window?.rootViewController as! ContViewController
                        if let rootViewController = self.window?.rootViewController as? UITabBarController{
                            
                            
                            if let viewControllers = rootViewController.viewControllers {
                                for navigationController in viewControllers {
                                    if let yourViewController = navigationController.topViewController as?       ContViewController {
                                        //if yourViewController.hasSomeFlag {
                                        yourViewController.showCommand(info["Command"]!)
                              

                                        //}
                                        break
                                    }
                                }
                            }
                            
                        }
                        
                        println(info["Command"]) //NO USE
                        // userInfo == "Status" write here
                        
                        
                        // 応答 成功 "Command"
                        reply.map { $0(["response" : "success"]) }
                    }
                }
                
            } else {
                // 応答 失敗
                reply.map { $0(["response" : "fail"]) }
            }
    }
    
    var GlobalMainQueue: dispatch_queue_t {
        return dispatch_get_main_queue()
    }
    
    
    func getInternetStatus() ->String {
        if Reachability.isConnectedToNetwork() == true {
            return("Internet OK")
            
        } else {
            return("No Internet Connection")
        }
    }
    
    
    func getBatteryStatus() ->String {
        
        //UIDevice.currentDevice().batteryLevel
        UIDevice.currentDevice().batteryMonitoringEnabled = true
        let batterymointor = UIDevice.currentDevice().batteryMonitoringEnabled
        let battery1 :String = NSString(format: "%3.0f%%",UIDevice.currentDevice().batteryLevel*100) as! String
        
        return battery1
        
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

    
     
    
}

