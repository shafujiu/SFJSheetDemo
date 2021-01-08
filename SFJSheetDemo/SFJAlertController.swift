//
//  XTAlertController.swift
//  SFJSheetDemo
//
//  Created by Shafujiu on 2021/1/7.
//  Copyright © 2021 Shafujiu. All rights reserved.
//

import UIKit
import SnapKit

class SFJAlertController: SFJBaseAlertController {

    /// 内容宽度
    private let kContentW: CGFloat = 300
    private let kContentCornerRadius: CGFloat = 8
    private let kDefaultActionBtnFont = UIFont.systemFont(ofSize: 16)
    private let kDefaultSegViewColor = #colorLiteral(red: 0.9215686275, green: 0.9215686275, blue: 0.9215686275, alpha: 1)
    private static let kDefaultContentInset = UIEdgeInsets(top: 28, left: 20, bottom: 28, right: 20)
    
    private var contentInset: UIEdgeInsets = kDefaultContentInset
    
    var titleFont = UIFont.systemFont(ofSize: 16)
    var titleInset = UIEdgeInsets(top: 0, left: kDefaultContentInset.left, bottom: 0, right: kDefaultContentInset.right)
    var titleColor = #colorLiteral(red: 0.05882352941, green: 0.1058823529, blue: 0.2, alpha: 1)
    var messageFont = UIFont.systemFont(ofSize: 14)
    var messageInset = UIEdgeInsets(top: 0, left: kDefaultContentInset.left, bottom: 0, right: kDefaultContentInset.right)
    var messageColor = #colorLiteral(red: 0.4039215686, green: 0.4196078431, blue: 0.4509803922, alpha: 1)
    
    private var actions: [SFJAlertAction] = []
    private var message: String?
    private var cTitle: String?
    
    private lazy var contentV: UIView = {
        let view = UIView()
        view.layer.cornerRadius = kContentCornerRadius
        view.backgroundColor = .white
        return view
    }()
    
    private lazy var topStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 12
        return stack
    }()
    
    private lazy var titleLbl: LableView = {
        let lbl = LableView()
        return lbl
    }()
    
    private lazy var messageLbl: LableView = {
        let lbl = LableView(contentInset: .zero)
        return lbl
    }()
    
    // 底部
    private lazy var bottomContentV: UIView = {
        let view = UIView()
        let segView = UIView()
        segView.backgroundColor = kDefaultSegViewColor
        view.addSubview(segView)
        view.addSubview(bottomStack)
        segView.snp.makeConstraints { (make) in
            make.height.equalTo(0.5)
            make.top.left.right.equalToSuperview()
        }
        bottomStack.snp.makeConstraints { (make) in
            make.left.right.top.bottom.equalToSuperview()
        }
        return view
    }()
    
    private lazy var bottomStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        return stack
    }()
    
    init(title: String?, message: String?, contentInset: UIEdgeInsets = kDefaultContentInset) {
        super.init(nibName: nil, bundle: nil)
        self.contentInset = contentInset
        setTitle(title)
        setMessage(message)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubViews()
    }
    
    private func setupSubViews() {
        view.addSubview(contentV)
        contentV.addSubview(topStack)
        contentV.addSubview(bottomContentV)
        contentV.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.equalTo(kContentW)
        }
        
        topStack.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(contentInset.left)
            make.right.equalToSuperview().offset(-contentInset.right)
            make.top.equalToSuperview().offset(contentInset.top)
            make.bottom.equalTo(bottomContentV.snp.top).offset(-contentInset.bottom)
        }
        
        bottomContentV.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
//            make.height.equalTo(50)
        }
    }
    
    private func setTitle(_ cTitle: String?) {
        self.cTitle = cTitle
        if let title = cTitle {
            topStack.addArrangedSubview(titleLbl)
            titleLbl.lbl.font = titleFont
            titleLbl.contentInset = titleInset
            titleLbl.lbl.textColor = titleColor
            titleLbl.lbl.text = title
        }
    }
    
    private func setMessage(_ message: String?) {
        self.message = message
        if let msg = message {
            topStack.addArrangedSubview(messageLbl)
            messageLbl.contentInset = messageInset
            messageLbl.lbl.font = messageFont
            messageLbl.lbl.textColor = messageColor
            messageLbl.lbl.text = msg
        }
    }
    
    private func addActionBtn(_ action: SFJAlertAction) {
        guard bottomStack.arrangedSubviews.count < 2 else {return}
        let btn = UIButton(type: .system)
        if let color = action.color {
            btn.setTitleColor(color, for: .normal)
        }else {
            let color = action.style == .cancel ? #colorLiteral(red: 0.1019607843, green: 0.4, blue: 1, alpha: 1) : #colorLiteral(red: 0.05882352941, green: 0.1058823529, blue: 0.2, alpha: 1)
            btn.setTitleColor(color, for: .normal)
        }
        btn.titleLabel?.font = kDefaultActionBtnFont
        btn.setTitle(action.title, for: .normal)
        bottomStack.addArrangedSubview(btn)
        btn.snp.makeConstraints { (make) in
            make.height.equalTo(50)
        }
        
        if bottomStack.arrangedSubviews.count == 2 {
            let segv = UIView()
            segv.backgroundColor = kDefaultSegViewColor
            bottomContentV.addSubview(segv)
            segv.snp.makeConstraints { (make) in
                make.top.bottom.centerX.equalToSuperview()
                make.width.equalTo(0.5)
            }
        }
        btn.addTarget(self, action: #selector(onActionBtnClick(_:)), for: .touchUpInside)
    }
    
    @objc private func onActionBtnClick(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
        
        let index = bottomStack.arrangedSubviews.firstIndex(of: sender)!
        let action = actions[index]
        action.handler?()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    
    class LableView: UIView {
        
        var contentInset: UIEdgeInsets = .zero {
            didSet {
                lbl.snp.updateConstraints { (make) in
                    make.left.equalToSuperview().offset(contentInset.left)
                    make.right.equalToSuperview().offset(-contentInset.right)
                    make.top.equalToSuperview().offset(contentInset.top)
                    make.bottom.equalToSuperview().offset(-contentInset.bottom)
                }
            }
        }
        
        lazy var lbl: UILabel = {
            let l = UILabel()
            l.textAlignment = .center
            l.numberOfLines = 0
            return l
        }()
        
        
        init(contentInset: UIEdgeInsets = .zero) {
            super.init(frame: .zero)
            setupUI()
        }

        
        required init?(coder: NSCoder) {
            super.init(coder: coder)
            setupUI()
        }
        
        private func setupUI() {
            addSubview(lbl)
            lbl.snp.makeConstraints { (make) in
                make.left.equalToSuperview().offset(contentInset.left)
                make.right.equalToSuperview().offset(-contentInset.right)
                make.top.equalToSuperview().offset(contentInset.top)
                make.bottom.equalToSuperview().offset(-contentInset.bottom)
            }
        }
    }
    
}

// public API
extension SFJAlertController {
    
    func addAction(_ action: SFJAlertAction) {
        actions.append(action)
        addActionBtn(action)
    }
    
    /// 留一手定制 内容
    /// - Parameter view: view description  
    func addMoreContent(_ view: UIView) {
        topStack.addArrangedSubview(view)
    }
}



struct SFJAlertAction {
    
    enum Style {
        case cancel
        case `default`
    }
    
    var title: String?
    var color: UIColor?
    var style: Style
    var handler: (()->())?
    
    
    init(title: String?, color: UIColor? = nil, style: Style, handler: (()->())? = nil) {
        self.title = title
        self.color = color
        self.style = style
        self.handler = handler
    }
    
    
 
    
    
    

}
