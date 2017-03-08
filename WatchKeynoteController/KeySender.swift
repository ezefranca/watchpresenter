//
//  KeySender.swift
//  WatchKeynoteControllerApp
//
//  Created by Ezequiel on 06/03/17.
//  Copyright © 2017 Ezequiel. All rights reserved.
//

import Foundation

protocol KeySender {
    var keyCode: CGKeyCode { get }
    func send()
}

extension KeySender {
    func send() {
        let downEvent = CGEvent(keyboardEventSource: nil, virtualKey: keyCode, keyDown: true)
        let upEvent = CGEvent(keyboardEventSource: nil, virtualKey: keyCode, keyDown: false)
        
        downEvent?.post(tap: .cghidEventTap)
        upEvent?.post(tap: .cghidEventTap)
    }
}

struct NextKeySender: KeySender {
    let keyCode: CGKeyCode = 124
}

struct BackKeySender: KeySender {
    let keyCode: CGKeyCode = 123
}
