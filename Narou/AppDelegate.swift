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
        
        let showItem = NSMenuItem()
        showItem.title = "Show Log"
        showItem.action = #selector(AppDelegate.showLog(_:))
        menu.addItem(showItem)
        
        let quitItem = NSMenuItem()
        quitItem.title = "Quit Application"
        quitItem.action = #selector(AppDelegate.quit(_:))
        menu.addItem(quitItem)
        
        timer = Timer.scheduledTimer(withTimeInterval: 3600, repeats: true, block: { (timer) in
            UseCurlMain.init().usecurlmain()
            let isReNew = UseCurlMain.init().getIsReNew()
            if(isReNew == 1) {
                print("ReNew")
                self.notification()
                UseCurlMain.init().writelog("ReNew");
                UseCurlMain.init().writelog(self.getDate());
                UseCurlMain.init().writelog("\n");
            } else if (isReNew == 0) {
                print("No ReNew")
                UseCurlMain.init().writelog("No ReNew");
                UseCurlMain.init().writelog(self.getDate());
                UseCurlMain.init().writelog("\n");
            }
        })
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        UseCurlMain.init().usecurlmain()
        print("Quit This")
        // Insert code here to tear down your application
    }
    
    func notification() {
        let notification = NSUserNotification()
        notification.identifier = "unique-id"
        notification.title = "ReNewal of NAROU"
        notification.informativeText = "ReNew!!!"
        notification.soundName = NSUserNotificationDefaultSoundName
        let notificationCenter = NSUserNotificationCenter.default
        notificationCenter.deliver(notification)
    }
    
    @IBAction func reload(_ sender: Any) {
        UseCurlMain.init().usecurlmain()
        let isReNew = UseCurlMain.init().getIsReNew()
        if(isReNew == 1) {
            print("ReNew")
            UseCurlMain.init().writelog("ReNew");
            UseCurlMain.init().writelog(self.getDate());
            UseCurlMain.init().writelog("\n");
            notification()
        } else if (isReNew == 0) {
            print("No ReNew")
            UseCurlMain.init().writelog("No ReNew");
            UseCurlMain.init().writelog(self.getDate());
            UseCurlMain.init().writelog("\n");
        }
    }
    
    func getDate() -> String {
        let date = Date()

        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd HH:mm"
        format.timeZone   = TimeZone(identifier: "Asia/Tokyo")

        let result = format.string(from: date)
        print( "現在時刻： ", result )

        return result
    }
    
    @IBAction func showLog(_ sender: Any) {
        UseCurlMain.init().showLog();
    }
    
    @IBAction func quit(_ sender: Any) {
        timer.invalidate()
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
        return false
    }
    
}
