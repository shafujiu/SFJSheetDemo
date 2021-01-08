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
    
        let alert = SFJSheetController(style: .topCorner, cellHeight: 54, cancelText: "cancel", cancelTextColor: UIColor.blue)
        alert.addAction(SFJSheetAction(name: "保存", itemColor: UIColor.red, action: {
        }))
        alert.addAction(SFJSheetAction(name: "清空", action: {
        }))
        alert.addAction(SFJSheetAction(name: "清空", action: {
        }))
        self.present(alert, animated: true, completion: nil)
        
        
//        let alert = SFJBaseAlertController()
//        present(alert, animated: true, completion: nil)
    }

    @IBAction func onAlertBtnClick(_ sender: Any) {
//
//        let alert = UIAlertController(title: "测试", message: nil, preferredStyle:.alert)
//        alert.addAction(UIAlertAction(title: "comfirm", style: .default, handler: { (_) in
//            
//        }))
        
        let alert = SFJAlertController(title: "title", message: "message")
        alert.addAction(SFJAlertAction(title: "取消", style: .default))
        alert.addAction(SFJAlertAction(title: "确认", style: .cancel, handler: {
            print("确认")
        }))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    @IBAction func onFirlterBtnClick(_ sender: Any) {
        
        let filter =  FilterAlertController(topOffsetY: 88, groups: [
                                                
            [FilterModel(title: "1", isSeleted: true),
             FilterModel(title: "2", isSeleted: false),
             FilterModel(title: "3", isSeleted: false),
             FilterModel(title: "4", isSeleted: false),
             FilterModel(title: "5", isSeleted: false)],
                                                
            [FilterModel(title: "1", isSeleted: true),
             FilterModel(title: "2", isSeleted: false),
             FilterModel(title: "3", isSeleted: false),
             FilterModel(title: "4", isSeleted: false),
             FilterModel(title: "5", isSeleted: false)],
            
            [FilterModel(title: "1", isSeleted: true),
             FilterModel(title: "2", isSeleted: false),
             FilterModel(title: "3", isSeleted: false),
             FilterModel(title: "4", isSeleted: false),
             FilterModel(title: "5", isSeleted: false)],
            
            [FilterModel(title: "1", isSeleted: true),
             FilterModel(title: "2", isSeleted: false),
             FilterModel(title: "3", isSeleted: false),
             FilterModel(title: "4", isSeleted: false),
             FilterModel(title: "5", isSeleted: false)]
                                                ])
        
        
        self.present(filter, animated: true, completion: nil)
    }
}

