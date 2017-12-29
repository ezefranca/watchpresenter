//
//  ViewController.swift
//  WatchKeynoteControllerApp
//
//  Created by Ezequiel on 06/03/17.
//  Copyright © 2017 Ezequiel. All rights reserved.
//

import UIKit
import MultipeerConnectivity
import WatchConnectivity

class ViewController: UIViewController, MCBrowserViewControllerDelegate {
    
    fileprivate var wcSession: WCSession!
    
    @IBOutlet weak var connectionToggleButton: UIButton!
    
    let session = MCSession(peer: MCPeerID(displayName: UIDevice.current.name))
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if WCSession.isSupported() {
            wcSession = WCSession.default
            wcSession.delegate = self
            wcSession.activate()
        }
        updateConnectButtonTitle()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    @IBAction func nextButtonTapped(_ sender: Any?) {
        self.doNext()
    }
    
    @IBAction func backButtonTapped(_ sender: Any?) {
        self.doBack()
    }
    
    fileprivate func doBack() {
        let key = "BACK".data(using: .utf8)
        do {
            let _ = try session.send(key!, toPeers: session.connectedPeers, with: .reliable)
        }
        catch (_) {
            
        }
    }
    
    fileprivate func doNext() {
        let key = "NEXT".data(using: .utf8)
        do {
            let _ = try session.send(key!, toPeers: session.connectedPeers, with: .reliable)
        }
        catch (_) {
            
        }
    }
    
    @IBAction func toggleConnectionButtonTapped(_ sender: Any?) {
        if session.hasPeers() {
            session.disconnect()
            updateConnectButtonTitle()
        }
        else {
            let controller = MCBrowserViewController(serviceType: "Keyboard", session: session)
            controller.delegate = self
            controller.maximumNumberOfPeers = 1
            updateConnectButtonTitle()
            showDetailViewController(controller, sender: self)
        }
    }
    
    func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
        browserViewController.dismiss(animated: true, completion: nil)
        updateConnectButtonTitle()
    }
    
    func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
        browserViewController.dismiss(animated: true, completion: nil)
        updateConnectButtonTitle()
    }
    
    private func updateConnectButtonTitle() {
        let text = session.hasPeers() ? "Tap to Disconnect" : "Tap to Connect"
        let status = session.hasPeers() ? "Connected" : "Disconnected"
        connectionToggleButton.setTitle(text, for: .normal)
        
        let data:Data = status.data(using: .utf8)!
        wcSession.sendMessageData(data, replyHandler: nil, errorHandler: {(error) -> Void in
            print("WCSession errors have occurred: \(error.localizedDescription)")
        })
    }
}

private extension MCSession {
    func hasPeers() -> Bool {
        return self.connectedPeers.count > 0
    }
}

extension ViewController: WCSessionDelegate {
    
    func session(_ session: WCSession, didReceiveMessageData messageData: Data) {
        
        print("\nAt the phone end...")
        print(messageData)
        
        DispatchQueue.main.async {
            
            if let button = String(data: messageData, encoding: .utf8) {
                
                switch button {
            
                case "NEXT":
                    self.doNext()
                
                case "BACK":
                    self.doBack()
                
                default:
                    return
                }
            }
        }
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {}
    func sessionDidDeactivate(_ session: WCSession) {}
    func sessionDidBecomeInactive(_ session: WCSession) {}
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {}
}
