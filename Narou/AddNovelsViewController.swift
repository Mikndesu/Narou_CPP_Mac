//
//  AddNovelsViewController.swift
//  Narou
//
//  Created by MitsukiGoto on 2019/12/23.
//  Copyright © 2019 五島充輝. All rights reserved.
//

import Cocoa

class AddNovelsViewController: NSViewController {

    @IBOutlet weak var name: NSTextField!
    @IBOutlet weak var ncode: NSTextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    @IBAction func doneClick(_ sender: Any) {
        let Name = name.stringValue
        let Ncode = ncode.stringValue
        UseCurlMain.init().addNovelonGUI(Name, ncode: Ncode)
    }
    
}
