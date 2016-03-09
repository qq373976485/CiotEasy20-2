//
//  SyncRequest.swift
//  GDCNetwork1
//
//  Created by Vincent on 2015/5/18.
//  Copyright (c) 2015年 Vincent. All rights reserved.
//

import Foundation

class SyncRequest : NSOperation {
    
    var socket:GCDAsyncSocket! = nil
    var msgData:NSData! = nil
    
    override var concurrent: Bool {
        return false
    }
    
    override var asynchronous: Bool {
        return false
    }
    
    private var _executing: Bool = false
    override var executing: Bool {
        get {
            return _executing
        }
        set {
            if (_executing != newValue) {
                self.willChangeValueForKey("isExecuting")
                _executing = newValue
                self.didChangeValueForKey("isExecuting")
            }
        }
    }
    
    private var _finished: Bool = false;
    override var finished: Bool {
        get {
            return _finished
        }
        set {
            if (_finished != newValue) {
                self.willChangeValueForKey("isFinished")
                _finished = newValue
                self.didChangeValueForKey("isFinished")
            }
        }
    }
    
    /// Complete the operation
    func completeOperation() {
        executing = false
        finished  = true
    }
    
    override func start() {
        if (cancelled) {
            finished = true
            return
        }
        
        executing = true
        
        main()
    }
    
    
    override func main() -> (){
        println("starting...")
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "didReadData:", name: "DidReadData", object: nil)
        
        sendData()
    }
    
    
    func sendData() {
        socket.writeData(msgData, withTimeout: -1.0, tag: 0)
        println("Sending: \(msgData)")
        socket.readDataWithTimeout(-1.0, tag: 0)
    }
    
    
    func didReadData(notif: NSNotification) {
        println("Data Received!")
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "DidReadData", object: nil)
        
        completeOperation()
        
    }
    
}