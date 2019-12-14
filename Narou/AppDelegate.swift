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
    @IBOutlet weak var showLog: NSMenuItem!
    @IBOutlet weak var deleteSettings: NSMenuItem!
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        self.statusItem.title = "Narou"
        self.statusItem.highlightMode = true
        self.statusItem.menu = menu
        
        let reloadItem = NSMenuItem()
        reloadItem.title = "Reload"
        reloadItem.action = #selector(AppDelegate.reload(_:))
        menu.addItem(reloadItem)
        
        let quitItem = NSMenuItem()
        quitItem.title = "Quit Application"
        quitItem.action = #selector(AppDelegate.quit(_:))
        menu.addItem(quitItem)
        
        timer = Timer.scheduledTimer(withTimeInterval: 3600, repeats: true, block: { (timer) in
            UseCurlMain.init().usecurlmain()
            let isReNew = UseCurlMain.init().getIsReNew()
            let novelname = UseCurlMain.init().getnovelname()
            if(isReNew == 1) {
                print("ReNew")
                UseCurlMain.init().writelog("ReNew");
                UseCurlMain.init().writelog(self.getDate());
                UseCurlMain.init().writelog("\n");
                self.notification(n_id: novelname!)
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
    
    func notification(n_id: String) {
        let notification = NSUserNotification()
        notification.identifier = n_id + "s"
        notification.title = "ReNewal of NAROU"
        notification.informativeText = "ReNew!!!"
        notification.soundName = NSUserNotificationDefaultSoundName
        let notificationCenter = NSUserNotificationCenter.default
        notificationCenter.deliver(notification)
    }
    
    @IBAction func reload(_ sender: Any) {
        UseCurlMain.init().usecurlmain()
        let novelname = UseCurlMain.init().getnovelname()!
        let isReNew = UseCurlMain.init().getIsReNew()
        if(isReNew == 1) {
            print("ReNew")
            UseCurlMain.init().writelog("ReNew");
            UseCurlMain.init().writelog(self.getDate());
            UseCurlMain.init().writelog("\n");
            self.notification(n_id: novelname)
        } else if (isReNew == 0) {
            print("No ReNew")
            UseCurlMain.init().writelog("No ReNew");
            UseCurlMain.init().writelog(self.getDate());
            UseCurlMain.init().writelog("\n");
            print(novelname)
        }
    }
    
    @IBAction func showLogClick(_ sender: Any) {
        UseCurlMain.init().showLog();
    }
    
    @IBAction func deleteSettingsClick(_ sender: Any) {
        UseCurlMain.init().deleteSettings();
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
    
    @IBAction func quit(_ sender: Any) {
        timer.invalidate()
        NSApplication.shared.terminate(self)
    }
    
    func userNotificationCenter(_ center: NSUserNotificationCenter, shouldPresent notification: NSUserNotification) -> Bool {
        return true;
    }

    private func userNotificationCenter(_ center: NSUserNotificationCenter, didActivate notification: NSUserNotification) -> Bool {
        return true
    }

    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return false
    }
    
}
