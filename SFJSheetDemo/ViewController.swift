//
//  ViewController.swift
//  SFJSheetDemo
//
//  Created by Shafujiu on 2020/9/9.
//  Copyright © 2020 Shafujiu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let alert = SFJSheetController(cellHeight: 54, cancelText: "cancel", cancelTextColor: UIColor.blue)
        alert.addAction(SFJSheetAction(name: "保存", itemColor: UIColor.red, action: {
        }))
        alert.addAction(SFJSheetAction(name: "清空", action: {
        }))
        alert.addAction(SFJSheetAction(name: "清空", action: {
        }))
        self.present(alert, animated: true, completion: nil)
    }

}

