//
//  KeySenderRecivingService.swift
//  WatchKeynoteControllerApp
//
//  Created by Ezequiel on 06/03/17.
//  Copyright © 2017 Ezequiel. All rights reserved.
//

import Foundation
import MultipeerConnectivity

class KeySenderRecivingService: NSObject, MCSessionDelegate {
    let peerID = MCPeerID(displayName: Host.current().name!)
    let session: MCSession
    let advertiser: MCAdvertiserAssistant
    
    override init() {
        session = MCSession(peer: peerID, securityIdentity: nil, encryptionPreference: .required)
        advertiser = MCAdvertiserAssistant(serviceType: "Keyboard", discoveryInfo: nil, session: session)
        
        super.init()
        
        session.delegate = self
        advertiser.start()
    }
    
    deinit {
        advertiser.stop()
        session.disconnect()
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        
        guard let string = String(data: data, encoding: .utf8) else {
            return
        }
        
        switch string {
        case "NEXT":
            let sender = NextKeySender()
            sender.send()
        case "BACK":
            let sender = BackKeySender()
            sender.send()
        default:
            return
        }
        
    }
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {}
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {}
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {}
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {}
    func session(_ session: MCSession, didReceiveCertificate certificate: [Any]?, fromPeer peerID: MCPeerID, certificateHandler: @escaping (Bool) -> Void) {
        certificateHandler(true)
    }
}
