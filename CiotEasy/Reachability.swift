//
//  Reachability.swift
//  myDeive1
//
//  Created by Vincent on 2015/5/7.
//  Copyright (c) 2015年 Vincent. All rights reserved.
//

import Foundation
public class Reachability {
    
    class func isConnectedToNetwork()->Bool{
        
        var Status:Bool = false
        let url = NSURL(string: "http://www.baidu.com/")
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "HEAD"
        request.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringLocalAndRemoteCacheData
        request.timeoutInterval = 10.0
        
        var response: NSURLResponse?
        
        var data = NSURLConnection.sendSynchronousRequest(request, returningResponse: &response, error: nil) as NSData?
        
        if let httpResponse = response as? NSHTTPURLResponse {
            if httpResponse.statusCode == 200 {
                Status = true
            }
        }
        
        return Status
    }
}
