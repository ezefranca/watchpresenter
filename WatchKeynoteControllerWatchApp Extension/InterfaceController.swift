//
//  InterfaceController.swift
//  WatchKeynoteControllerWatchApp Extension
//
//  Created by Ezequiel on 06/03/17.
//  Copyright © 2017 Ezequiel. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity
import CoreMotion

class InterfaceController: WKInterfaceController, WKCrownDelegate {
    
    @IBOutlet var previousButton: WKInterfaceButton!
    fileprivate var wcSession: WCSession!
    @IBOutlet var statusLabel: WKInterfaceLabel!
    
    var shaker:WatchShaker = WatchShaker(delay: 2.0)

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        if WCSession.isSupported() {
            wcSession = WCSession.default
            wcSession.delegate = self
            wcSession.activate()
        }
        
//        crownSequencer.delegate = self
//        crownSequencer.focus()
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        crownSequencer.delegate = self
        crownSequencer.focus()
        
        shaker.delegate = self
        shaker.start()
    }
    
    @IBAction func shakeStopPressed() {
            shaker.stop()
    }
    
    @IBAction func shakeStartPressed() {
        shaker.delegate = self
        shaker.start()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    @IBAction func nextTouched() {
        self.sendButton("NEXT")
    }
    @IBAction func previousTouched() {
        self.sendButton("BACK")
    }
    
    func sendButton(_ button:String) {
        
        print("\nAt the watch end...")
        let data:Data = button.data(using: .utf8)!
        wcSession.sendMessageData(data, replyHandler: nil, errorHandler: {(error) -> Void in
            print("WCSession errors have occurred: \(error.localizedDescription)")
        })
        
    }
    
    var canTrigger = true
    
    func crownDidRotate(_ crownSequencer: WKCrownSequencer?, rotationalDelta: Double)
    {
        if rotationalDelta > 0.01 && canTrigger {
            canTrigger = false
            self.sendButton("BACK")
            let when = DispatchTime.now() + 2 // change 2 to desired number of seconds to reactivate trigger
            DispatchQueue.main.asyncAfter(deadline: when) {
                self.canTrigger = true
            }
        } else if rotationalDelta < 0 && canTrigger {
            canTrigger = false
            self.sendButton("NEXT")
            let when = DispatchTime.now() + 2 // change 2 to desired number of seconds to reactivate trigger
            DispatchQueue.main.asyncAfter(deadline: when) {
                self.canTrigger = true
            }
        }
        //statusLabel.setText("\(rotationalDelta)")
    }
    
}

extension InterfaceController: WatchShakerDelegate
{
    func watchShakerDidShake(_ watchShaker: WatchShaker) {
        print("YOU HAVE SHAKEN YOUR ⌚️⌚️⌚️")
//        statusLabel.setText("Shook < 2.0")
        self.sendButton("NEXT")
    }
    
    func watchShakerDidShake2(_ watchShaker: WatchShaker) {
        print("YOU HAVE SHAKEN YOUR ⌚️⌚️⌚️")
        self.sendButton("BACK")
//        statusLabel.setText("Shook >= 2.0")
    }
    
    func watchShaker(_ watchShaker: WatchShaker, didFailWith error: Error) {
        print(error.localizedDescription)
    }
}

extension InterfaceController : WCSessionDelegate {
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {}
    
    func session(_ session: WCSession, didReceiveMessageData messageData: Data) {
        DispatchQueue.main.async {
            
            if let status = String(data: messageData, encoding: .utf8) {
                self.statusLabel.setText(status)
            }
        }
    }
}
