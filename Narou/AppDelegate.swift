//
//  AppDelegate.swift
//  Narou
//
//  Created by MitsukiGoto on 2019/11/19.
//  Copyright © 2019 五島充輝. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    let statusItem = NSStatusBar.system.statusItem(withLength: -1)

    @IBOutlet weak var menu: NSMenu!
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        let menu = NSMenu()
        self.statusItem.title = "Narou"
        self.statusItem.highlightMode = true
        self.statusItem.menu = menu
        
        let PreferItem = NSMenuItem()
        PreferItem.title = "Preferences"
        PreferItem.action = #selector(AppDelegate.preferences(_:))
        menu.addItem(PreferItem)
        
        let reloadItem = NSMenuItem()
        reloadItem.title = "Reload"
        reloadItem.action = #selector(AppDelegate.reload(_:))
        menu.addItem(reloadItem)
        
        let quitItem = NSMenuItem()
        quitItem.title = "Quit Application"
        quitItem.action = #selector(AppDelegate.quit(_:))
        menu.addItem(quitItem)
               
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    @IBAction func preferences(_ sender: Any) {
    }
    
    @IBAction func reload(_ sender: Any) {
        UseCurl.init().usecurl()
    }
    
    @IBAction func quit(_ sender: Any) {
        NSApplication.shared.terminate(self)
    }


}

