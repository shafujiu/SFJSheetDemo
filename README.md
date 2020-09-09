# SFJSheetDemo
自定义 SheetViewController

### 使用

``` Swift
let alert = SFJSheetController(cellHeight: 54, cancelText: "cancel", cancelTextColor: UIColor.blue)
alert.addAction(SFJSheetAction(name: "保存", itemColor: UIColor.red, action: {
}))
alert.addAction(SFJSheetAction(name: "清空", action: {
}))
alert.addAction(SFJSheetAction(name: "清空", action: {
}))
self.present(alert, animated: true, completion: nil)
```
