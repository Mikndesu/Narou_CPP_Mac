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
    var timer = Timer()
    
    @IBOutlet weak var menu: NSMenu!
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        self.statusItem.title = "Narou"
        self.statusItem.highlightMode = true
        self.statusItem.menu = menu
        
        let reloadItem = NSMenuItem()
        reloadItem.title = "Reload"
        reloadItem.action = #selector(AppDelegate.reload(_:))
        menu.addItem(reloadItem)
        
        let stopTimerItem = NSMenuItem()
        stopTimerItem.title = "Timer Stop"
        stopTimerItem.action = #selector(AppDelegate.stopTimer(_:))
        menu.addItem(stopTimerItem)
        
        let quitItem = NSMenuItem()
        quitItem.title = "Quit Application"
        quitItem.action = #selector(AppDelegate.quit(_:))
        menu.addItem(quitItem)
        
        timer = Timer.scheduledTimer(withTimeInterval: 3600, repeats: true, block: { (timer) in
            UseCurlMain.init().usecurlmain()
            let isReNew = UseCurlMain.init().getIsReNew()
            if(isReNew == 1) {
                print("ReNew")
                let notification = NSUserNotification()
                notification.identifier = "unique-id"
                notification.title = "New ReNewal of NAROU"
                notification.informativeText = "New ReNew!!!"
                notification.soundName = NSUserNotificationDefaultSoundName
                let notificationCenter = NSUserNotificationCenter.default
                notificationCenter.deliver(notification)
            } else if (isReNew == 0) {
                print("No ReNew")
            }
        })
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        UseCurlMain.init().usecurlmain()
        // Insert code here to tear down your application
    }
    
    func notification() {
        let notification = NSUserNotification()
        notification.identifier = "unique-id"
        notification.title = "New ReNewal of NAROU"
        notification.informativeText = "New ReNew!!!"
        notification.soundName = NSUserNotificationDefaultSoundName
        let notificationCenter = NSUserNotificationCenter.default
        notificationCenter.deliver(notification)
    }
    
    @IBAction func reload(_ sender: Any) {
        UseCurlMain.init().usecurlmain()
        let isReNew = UseCurlMain.init().getIsReNew()
        if(isReNew == 1) {
            print("ReNew")
            notification()
        } else if (isReNew == 0) {
            print("No ReNew")
        }
    }
    
    @IBAction func stopTimer(_ sender: Any) {
        timer.invalidate()
    }
    
    @IBAction func quit(_ sender: Any) {
        NSApplication.shared.terminate(self)
    }
    
    func userNotificationCenter(_ center: NSUserNotificationCenter, shouldPresent notification: NSUserNotification) -> Bool {
        return true;
    }

    private func userNotificationCenter(_ center: NSUserNotificationCenter, didActivate notification: NSUserNotification) -> Bool {
        print("ok")
        return true
    }

    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }

}
