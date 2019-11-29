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
    
    func notification() {
        let notification = NSUserNotification()
        notification.identifier = "unique-id"
        notification.title = "New ReNewal"
        notification.informativeText = "This is a test"
        notification.soundName = NSUserNotificationDefaultSoundName
        let notificationCenter = NSUserNotificationCenter.default
        notificationCenter.deliver(notification)
    }
    
    func userNotificationCenter(_ center: NSUserNotificationCenter, shouldPresent notification: NSUserNotification) -> Bool {
        return true;
    }

    private func userNotificationCenter(_ center: NSUserNotificationCenter, didActivate notification: NSUserNotification) -> Bool {
        print("ok");
        return true;
    }

    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }
    
    @IBAction func preferences(_ sender: Any) {
        notification()
    }
    
    @IBAction func reload(_ sender: Any) {
        UseCurlMain.init().usecurlmain()
        print(UseCurlMain.init().getIsReNew());
    }
    
    @IBAction func quit(_ sender: Any) {
        NSApplication.shared.terminate(self)
    }


}

