//
//  AppDelegate.swift
//  WatchKeynoteController
//
//  Created by Ezequiel on 06/03/17.
//  Copyright © 2017 Ezequiel. All rights reserved.
//

import Cocoa
import MultipeerConnectivity

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var statusMenu: NSMenu!
    
    var server: KeySenderRecivingService?
    
    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        
        statusItem.image = NSImage(named: NSImage.Name(rawValue: "menuIcon"))
//        statusBar.menu = mainMenu
//        statusBar.highlightMode = true
        statusItem.menu = statusMenu
        statusItem.highlightMode = true
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    @IBAction func statusMenuAction(_ sender: NSMenuItem) {

        if let _ = server {
            server = nil
            sender.state = .off
        }
        else {
            server = KeySenderRecivingService()
            sender.state = .on
        }
    }
}
