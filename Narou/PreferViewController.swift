//
//  PreferViewController.swift
//  Narou
//
//  Created by MitsukiGoto on 2019/12/07.
//  Copyright © 2019 五島充輝. All rights reserved.
//

import Cocoa

class PreferViewController: NSViewController {
    
    @IBOutlet weak var ncodefield: NSTextField!
    @IBOutlet weak var offield: NSTextField!
    @IBOutlet weak var done: NSButton!
    //    UseCurlMain.init().writelog("\n");
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    @IBAction func doneclick(_ sender: Any) {
        let ncode = ncodefield.stringValue
        print(ncode)
        OnClickFun.init().rewriteJson(ncode)
        //        self.dismiss(self)
    }
    
}
