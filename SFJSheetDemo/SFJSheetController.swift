//
//  SFJAlertSheetController.swift
//  SFJAlertSheetController
//
//  Created by Shafujiu on 2020/9/8.
//  Copyright © 2020 Shafujiu. All rights reserved.
//

import UIKit

//class SFJSheetPresentAnimate: NSObject, UIViewControllerAnimatedTransitioning {
//    
//    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
//        
//        guard let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) as? SFJSheetController,
//            let _ = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)  else {
//            return
//        }
//        
//        let containerV = transitionContext.containerView
//        let duration = self.transitionDuration(using: transitionContext)
//        
//        containerV.addSubview(toVC.view)
//        toVC.view.frame = containerV.bounds
//        toVC.view.alpha = 0
//        // toVC 的 承载内容的动画
//        toVC.showTableView()
//        
//        UIView.animate(withDuration: duration, animations: {
//            toVC.view.alpha = 1
//        }) { (_) in
//            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
//        }
//    }
//    
//    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
//        0.3
//    }
//}
//
//class SFJSheetDismissAnimate: NSObject, UIViewControllerAnimatedTransitioning {
//    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
//        guard let _ = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to),
//            let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from) as? SFJSheetController else {
//                return
//        }
//        
//        let duration = self.transitionDuration(using: transitionContext)
//        fromVC.dismissTableView { (_) in
//            
//        }
//        UIView.animate(withDuration: duration, animations: {
//            fromVC.view.alpha = 0
//        }) { (_) in
//            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
//        }
//    }
//    
//    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
//        0.25
//    }
//}

class SFJSheetCell: UITableViewCell {
    
    lazy var titleLbl: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: 16)
        lbl.textColor = UIColor.darkText
        lbl.textAlignment = .center
        return lbl
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    private func setupUI() {
        selectionStyle = .none
        addSubview(titleLbl)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let offset: CGFloat = 15
        let width = contentView.bounds.width - offset * 2
        let height = contentView.bounds.height
        titleLbl.frame = CGRect(x: offset, y: 0, width: width, height: height)
    }
}

struct SFJSheetAction {
    typealias SFJAlertActionBlock = ()->()
    
    var name: String
    var itemColor: UIColor = UIColor.darkText
    var action: SFJAlertActionBlock?
    
}

class SFJSheetController: SFJBaseAlertController {

    private var kDefaultLeftRightMargin: CGFloat = 8
    private var kDefaultTableSpaceColor: UIColor = #colorLiteral(red: 0.8174290061, green: 0.8279278278, blue: 0.8440498114, alpha: 1)
    private var kDefaultCornerRadius: CGFloat = 12
    
    enum SheetStyle {
        case normal
        case topCorner
    }
    
    private var cellHeight: CGFloat
    private var kLeftSpace: CGFloat {
        switch style {
        case .normal:
            return kDefaultLeftRightMargin
        case .topCorner:
            return 0
        }
    }
    private var kRightSpace: CGFloat {
        return kLeftSpace
    }
    
    private var tableBottomSpace: CGFloat {
        var tableBottomSpace: CGFloat = 8
        if #available(iOS 11.0, *) {
            tableBottomSpace = view.safeAreaInsets.bottom == 0 ? tableBottomSpace : view.safeAreaInsets.bottom
        }
        return tableBottomSpace
    }
    
    /// 取消与上方选项的间隙
    private let kOffsetSpace: CGFloat = 8
    
    /// 取消与上方选项的间隙的颜色
    private var tableSpaceColor: UIColor {
        switch style {
        case .normal:
            return tableBgColor
        case .topCorner:
            return kDefaultTableSpaceColor
        }
    }
    /// tableview的背景颜色
    private var tableBgColor: UIColor {
        switch style {
        case .normal:
            return .clear
        case .topCorner:
            return .white
        }
    }
    
    
    private var actions: [SFJSheetAction] = []
    private var cancelAction: SFJSheetAction
    private var style: SheetStyle = .topCorner
    
    
    private var tableHeight: CGFloat {
        cellHeight * CGFloat((actions.count + 1)) + kOffsetSpace
    }
    
    private lazy var tableView: UITableView = {
        let view = UITableView(frame: .zero, style: .grouped)
        
        view.delegate = self
        view.dataSource = self
        view.estimatedRowHeight = 44
        view.estimatedSectionFooterHeight = 0
        view.estimatedSectionHeaderHeight = 0
        view.backgroundColor = .clear
        view.alwaysBounceVertical = false
        view.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//        view.separatorColor =
        view.separatorStyle = .none
        view.register(SFJSheetCell.self, forCellReuseIdentifier: SFJSheetCell.description())
        view.backgroundColor = tableBgColor
        view.layer.cornerRadius = kDefaultCornerRadius
        return view
    }()
    
    
    /// 初始化方法
    /// - Parameters:
    ///   - cellHeight: cellHeight description
    ///   - cancelText: cancelText description
    ///   - cancelTextColor: cancelTextColor description
    init(style: SheetStyle = .normal, cellHeight: CGFloat = 54, cancelText: String = "取消", cancelTextColor: UIColor = UIColor.darkText) {
        self.cancelAction = SFJSheetAction(name: cancelText, itemColor: cancelTextColor, action: nil)
        self.cellHeight = cellHeight
        self.style = style
        super.init(nibName: nil, bundle:nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        tableView.reloadData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let tableH = cellHeight * CGFloat((actions.count + 1)) + kOffsetSpace + tableBottomSpace
        let tableY = view.bounds.height - tableH
        let tableW = view.bounds.width - kLeftSpace - kRightSpace
        let tableX = kLeftSpace
        tableView.frame = CGRect(x: tableX, y: tableY, width: tableW, height: tableH)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - public api
extension SFJSheetController {
    fileprivate func showTableView() {
        tableView.transform = CGAffineTransform(translationX: 0, y: tableHeight)
        UIView.animate(withDuration: 0.35, animations: {
            self.tableView.transform = CGAffineTransform.identity
        }) { (_) in
            
        }
    }
    
    fileprivate func dismissTableView(completion: ((Bool) -> Void)? = nil) {
        UIView.animate(withDuration: 0.25, animations: {
            self.tableView.frame.origin.y += self.tableHeight
        }, completion: completion)
    }
    
    func addAction(_ action: SFJSheetAction) {
        actions.append(action)
    }
}

extension SFJSheetController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? self.actions.count : 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SFJSheetCell.description(), for: indexPath) as! SFJSheetCell
        let action = (indexPath.section == 0) ? actions[indexPath.row] : cancelAction
        cell.titleLbl.text = action.name
        cell.titleLbl.textColor = action.itemColor
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        cellHeight
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? CGFloat.leastNormalMagnitude : kOffsetSpace
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = tableSpaceColor
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
}

extension SFJSheetController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let action = (indexPath.section == 0) ? actions[indexPath.row] : cancelAction
        dismiss(animated: true, completion: nil)
        action.action?()
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // section 圆角
        if (cell.responds(to: #selector(getter: UIView.tintColor))){
            if tableView == self.tableView {
                let cornerRadius: CGFloat = kDefaultCornerRadius
                cell.backgroundColor = .clear
                let layer: CAShapeLayer = CAShapeLayer()
                let path: CGMutablePath = CGMutablePath()
                let bounds: CGRect = cell.bounds
                //                   cell.frame = bounds.insetBy(dx: 25.0, dy: 0.0)
                
                var addLine: Bool = false
                
                if indexPath.row == 0 && indexPath.row == ( tableView.numberOfRows(inSection: indexPath.section) - 1) {
                    path.addRoundedRect(in: bounds, cornerWidth: cornerRadius, cornerHeight: cornerRadius)
                    
                } else if indexPath.row == 0 {
                    path.move(to: CGPoint(x: bounds.minX, y: bounds.maxY))
                    path.addArc(tangent1End: CGPoint(x: bounds.minX, y: bounds.minY), tangent2End: CGPoint(x: bounds.midX, y: bounds.minY), radius: cornerRadius)
                    path.addArc(tangent1End: CGPoint(x: bounds.maxX, y: bounds.minY), tangent2End: CGPoint(x: bounds.maxX, y: bounds.midY), radius: cornerRadius)
                    path.addLine(to: CGPoint(x: bounds.maxX, y: bounds.maxY))
                    addLine = true
                } else if indexPath.row == (tableView.numberOfRows(inSection: indexPath.section) - 1) {
                    path.move(to: CGPoint(x: bounds.minX, y: bounds.minY))
                    path.addArc(tangent1End: CGPoint(x: bounds.minX, y: bounds.maxY), tangent2End: CGPoint(x: bounds.midX, y: bounds.maxY), radius: cornerRadius)
                    path.addArc(tangent1End: CGPoint(x: bounds.maxX, y: bounds.maxY), tangent2End: CGPoint(x: bounds.maxX, y: bounds.midY), radius: cornerRadius)
                    path.addLine(to: CGPoint(x: bounds.maxX, y: bounds.minY))
                    
                } else {
                    path.addRect(bounds)
                    addLine = true
                }
                
                
                
                layer.path = path
                layer.fillColor = UIColor.white.withAlphaComponent(0.8).cgColor
                
                if addLine {
                    let lineLayer: CALayer = CALayer()
                    let lineHeight: CGFloat = 1.0 / UIScreen.main.scale
                    lineLayer.frame = CGRect(x: bounds.minX + 0, y: bounds.size.height - lineHeight, width: bounds.size.width, height: lineHeight)
                    lineLayer.backgroundColor = tableView.separatorColor?.cgColor
                    layer.addSublayer(lineLayer)
                }
                
                let testView: UIView = UIView(frame: bounds)
                testView.layer.insertSublayer(layer, at: 0)
                testView.backgroundColor = .clear
                cell.backgroundView = testView
            }
        }
    }
}
// UIViewControllerTransitioningDelegate
extension SFJSheetController {
    
    override func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        SFJBasePresentAnimate { 
            (presented as? SFJSheetController)?.showTableView()
        }
    }
    
    override func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        SFJBaseDismissAnimate {
            (dismissed as? SFJSheetController)?.dismissTableView()
        }
    }
    
}


