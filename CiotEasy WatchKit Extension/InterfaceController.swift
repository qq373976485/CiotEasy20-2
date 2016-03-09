//
//  InterfaceController.swift
//  WatchControlMe WatchKit Extension
//
//  Created by Vincent on 2015/4/23.
//  Copyright (c) 2015年 Vincent. All rights reserved.
//

import WatchKit
import Foundation

var wdaTempval0 = 0.0
var wdaHumival0 = 0.0
var wdaSlider0  = 0
var wdaConnectStatus0 = false
var wdaSensorID0 = "112233445566"


class InterfaceController: WKInterfaceController {
    
    var led1status = false
    var led2status = false
    var plug1status = false


    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        // Configure interface objects here.
        image1.setImageNamed("led1off")
        image1.setHeight(40)
        image1.setWidth(40)
        image2.setImageNamed("led2off")
        image2.setHeight(40)
        image2.setWidth(40)
        image3.setImageNamed("plug1off")
        image3.setHeight(40)
        image3.setWidth(40)
       // image4.setImageNamed("fan1.png")
        image4.setImageNamed("fan1")
        image4.setHeight(40)
        image4.setWidth(40)
        
        //image5.setImageNamed("tempture1.png")
        image5.setImageNamed("tempture1")
        image5.setHeight(40)
        image5.setWidth(40)
      
        led1status = false
        led2status = false
        

        
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
        
        showTempButton.setTitle(toString(wdaTempval0) + " ˚C")
        
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

 
    
    @IBOutlet weak var image1: WKInterfaceImage!
    @IBOutlet weak var image2: WKInterfaceImage!
    @IBOutlet weak var image3: WKInterfaceImage!
    
    @IBOutlet weak var image4: WKInterfaceImage!
    
    @IBOutlet weak var image5: WKInterfaceImage!
    
    @IBOutlet weak var led1button: WKInterfaceButton!
    @IBAction func led1button1() {
        if (led1status){
            led1status = false
            image1.setImageNamed("led1off")
            led1button.setTitle("客廳燈關的")
            openParent("客廳燈關的")
            
        }
        else{
            led1status = true
            image1.setImageNamed("led1on")
            
            led1button.setTitle("客廳燈開了")
/*
            let name_attrs: NSDictionary = [
                NSForegroundColorAttributeName: UIColor.yellowColor(),
            ]
            
            self.led1button.setAttributedTitle(NSAttributedString(string: "客廳燈開了", attributes: name_attrs as [NSObject : AnyObject]))
*/
            
                 
            self.led1button.setAttributedTitle(NSAttributedString(string: "客廳燈開了", attributes:[ NSForegroundColorAttributeName: UIColor.yellowColor() ] ))
            openParent("客廳燈開了")
            
            
        }
        
    }

    @IBAction func led2button1() {
        image2.setImageNamed("led2on")

      
            led2status = true
            openParent("led2on")
     
  
    }

    
    @IBAction func led2button2() {
          image2.setImageNamed("led2off")

            led2status = false
            openParent("led2off")
      
    }
    
    @IBAction func plug1switch(value: Bool) {
       
        if !plug1status{
            plug1status = true
            image3.setImageNamed("plug1on")
            openParent("插頭1-通電中")
        }
        else{
            plug1status = false
            image3.setImageNamed("plug1off")
            openParent("插頭1-斷電")
        }
      
        
    }

    @IBAction func pressFanSlider(value: Float) {
        
        // println(Slider1val.value)
        let intSliderval = Int(value + 0.5)
        if  wdaSlider0 != intSliderval {
            
            wdaSlider0 = intSliderval
            
            openParent("設置風量 \(wdaSlider0)")

            
            
        }
        
    }
    
    
    @IBOutlet weak var showTempButton: WKInterfaceButton!
    
    @IBAction func pressSensorButton() {
        


    }
    
    
    
    // カウントラベル
    func openParent(commandCode: String) {
        var userInfo = ["Command" : commandCode]
        // openParentApplication:reply:メソッド iPhone側の親アプリを起動
        WKInterfaceController.openParentApplication(userInfo, reply: { (data, error) in
            if let error = error {
                
                // 応答 失敗 ["response" : "fail"]
                println(error)
            }
            if let data = data {
                
                // 応答 成功 [response: success]
                println(data)
            }
        })
    }

    
    
}
