//
//  FilterAlertController.swift
//  SFJSheetDemo
//
//  Created by Shafujiu on 2021/1/8.
//  Copyright © 2021 Shafujiu. All rights reserved.
//

import UIKit

class FilterAlertController: SFJBaseAlertController {

    typealias FilterAlertComfirmBlock = (_ groups: [[FilterModel]])->()
    private let ScreenWidth = UIScreen.main.bounds.width
    private let ScreenHeight = UIScreen.main.bounds.height
    // 底部stack 与 最底部的约束
    private let kContentBottomSpace: CGFloat = 16
    private let kBottomBtnH: CGFloat = 40
    private let kCollVBottmSpace: CGFloat = 27
    private let kFilterBtnContentH: CGFloat = 39 - 12
    private let kDefaultSeletedColor = #colorLiteral(red: 0.1178690866, green: 0.5011495948, blue: 1, alpha: 1)
    
    private var topOffsetY: CGFloat
    private var groups: [[FilterModel]] = []
    
    var comfirmBlock: FilterAlertComfirmBlock?

    private var contentH: CGFloat {
        return constantHeight + collectionH
    }
    
    private var constantHeight: CGFloat {
        topOffsetY + kFilterBtnContentH + kCollVBottmSpace + kBottomBtnH + kContentBottomSpace
    }
    
    private var collectionH: CGFloat {
        let maxCollectionH = (ScreenHeight * 2.0 / 3.0) - constantHeight
        let collH = collectionV.collectionViewLayout.collectionViewContentSize.height
        return collH > maxCollectionH ? maxCollectionH : collH
    }
    /// 顶部占位透明View
    private lazy var topTrancView: UIView = {
        let view = UIView()
        return view
    }()
    
    /// 底部半透明背景
    private lazy var bottomBgView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        return view
    }()
    // 内容
    private lazy var contentV: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private lazy var firlterBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("收起", for: .normal)
        btn.setTitleColor(kDefaultSeletedColor, for: .normal)
        btn.setImage(UIImage(named: "my_class_filter_btn_sel"), for: .normal)
        btn.titleEdgeInsets = UIEdgeInsets(top: 0, left: -4, bottom: 0, right: 0)
        btn.semanticContentAttribute = UIApplication.shared
        .userInterfaceLayoutDirection == .rightToLeft ? .forceLeftToRight : .forceRightToLeft
        
        btn.addTarget(self, action: #selector(onFirlterBtnClick), for: .touchUpInside)
        return btn
    }()
    
    private lazy var collectionV: UICollectionView = {
        let tempL = UICollectionViewFlowLayout()
        let space: CGFloat = 16
        let rowCount: CGFloat = 3
        
        let width = (ScreenWidth - 15 * 2 - (rowCount - 1) * space) / rowCount
        tempL.itemSize = CGSize(width: width, height: 33)
        tempL.minimumLineSpacing =  12
        tempL.minimumInteritemSpacing = space
        let view = UICollectionView(frame: .zero, collectionViewLayout: tempL)
        view.register(FilterCell.self, forCellWithReuseIdentifier: "FilterCell")
        view.register(FilterCollectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "FilterCollectionHeaderView")
        view.delegate = self
        view.dataSource = self
        view.backgroundColor = .clear
        return view
    }()
    
    // 按钮容器
    private lazy var bottomBtnStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [resetBtn, comfirmBtn])
        stack.axis = .horizontal
        stack.spacing = 15
        stack.distribution = .fillEqually
        return stack
    }()
    
    private lazy var resetBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.layer.cornerRadius = 8
        btn.clipsToBounds = true
        btn.layer.borderWidth = 1
        btn.layer.borderColor = #colorLiteral(red: 0.7764705882, green: 0.7882352941, blue: 0.8078431373, alpha: 1).cgColor
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        btn.setTitleColor(#colorLiteral(red: 0.5764705882, green: 0.6, blue: 0.6431372549, alpha: 1), for: .normal)
        btn.setTitle("重置", for: .normal)
        btn.addTarget(self, action: #selector(onResetBtnClick), for: .touchUpInside)
        return btn
    }()
    
    private lazy var comfirmBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.layer.cornerRadius = 8
        btn.clipsToBounds = true
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        btn.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
        btn.setTitle("确认", for: .normal)
        btn.backgroundColor = #colorLiteral(red: 0.1178690866, green: 0.5011495948, blue: 1, alpha: 1)
        btn.addTarget(self, action: #selector(onComfirmBtnClick), for: .touchUpInside)
        return btn
    }()
    
    init(topOffsetY: CGFloat, groups: [[FilterModel]]) {
        self.topOffsetY = topOffsetY
        self.groups = groups
        super.init(nibName: nil, bundle: nil)
        self.view.backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSubViews()
        
        collectionV.reloadData()
        collectionV.layoutIfNeeded()
        updateHeight()
    }
    
    
    private func setupSubViews() {
        view.addSubview(topTrancView)
        view.addSubview(bottomBgView)
        bottomBgView.addSubview(contentV)
        contentV.addSubview(collectionV)
        contentV.addSubview(firlterBtn)
        contentV.addSubview(bottomBtnStack)
        
        topTrancView.snp.makeConstraints { (make) in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(topOffsetY)
        }
        
        bottomBgView.snp.makeConstraints { (make) in
            make.top.equalTo(topTrancView.snp.bottom)
            make.right.left.bottom.equalToSuperview()
            
        }
        contentV.snp.makeConstraints { (make) in
            make.left.top.right.equalToSuperview()
//            make.height.equalTo(300)
        }
        firlterBtn.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-15)
            make.top.equalTo(12)
            make.height.equalTo(15)
        }
        collectionV.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
            make.top.equalToSuperview().offset(kFilterBtnContentH)
            make.bottom.equalTo(bottomBtnStack.snp.top).offset(-kCollVBottmSpace)
            make.height.equalTo(0)
        }
        bottomBtnStack.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
            make.height.equalTo(kBottomBtnH)
            make.bottom.equalToSuperview().offset(-kContentBottomSpace)
        }
    }

    private func showContentV() {
        
//        self.contentV.transform = CGAffineTransform(translationX: 0, y: -self.contentH)
        UIView.animate(withDuration: 0.35, animations: {
            self.updateHeight()
//            self.contentV.layoutIfNeeded()
//            self.contentV.transform = CGAffineTransform.identity
        }) { (_) in
        }
    }
    
    private func dismissContentV() {
        UIView.animate(withDuration: 0.25, animations: {
            self.contentV.frame.origin.y -= self.contentH
        }, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let center = touches.first?.location(in: contentV), !contentV.frame.contains(center) else {
            return
        }
        dismiss()
    }
    
    private func dismiss() {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - click events
    
    @objc private func onResetBtnClick() {
//        dismiss()
        self.groups.forEach { (arr) in
            arr.enumerated().forEach { (index,item) in
                item.isSeleted = index == 0
            }
        }
        collectionV.reloadData()
    }
    
    @objc private func onComfirmBtnClick() {
        comfirmBlock?(self.groups)
        dismiss()
    }
    
    @objc private func onFirlterBtnClick() {
//        comfirmBlock?(self.groups)
        dismiss()
    }
    
}

extension FilterAlertController {
    func setGroups(_ groups: [[FilterModel]]) {
        self.groups = groups
        collectionV.reloadData()
        collectionV.layoutIfNeeded()
    }
    
    private func updateHeight() {
        
        
        collectionV.snp.updateConstraints { (make) in
            make.height.equalTo(collectionH)
        }
    }
}

extension FilterAlertController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        self.groups.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.groups[section].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FilterCell", for: indexPath) as! FilterCell
        let arr = self.groups[indexPath.section]
        let model = arr[indexPath.row]
        cell.model = model
        cell.btnClickBlock = {
            
            arr.forEach { (item) in
                item.isSeleted = false
            }
            model.isSeleted = true
            
            collectionView.reloadSections([indexPath.section])
        }
//        if let model = self.model {
//            switch indexPath.section {
//            case 0:
//                let item = model.`class`[indexPath.row]
//
//                cell.setClass(model.`class`[indexPath.row]) {
//                    // 将其他数据重新设置
//                    model.class.forEach {$0.p_seleted = false}
//                    item.p_seleted = true
//                    collectionView.reloadSections(IndexSet([0]))
//                }
//            case 1:
//                let item = model.lesson[indexPath.row]
//                cell.setLesson(item) {
//                    model.lesson.forEach {$0.p_seleted = false}
//                    item.p_seleted = true
//                    collectionView.reloadSections(IndexSet([1]))
//                }
//            case 2:
//                let item = model.work_num[indexPath.row]
//                cell.setWrokNum(item) {
//                    model.work_num.forEach {$0.p_seleted = false}
//                    item.p_seleted = true
//                    collectionView.reloadSections(IndexSet([2]))
//                }
//            default:
//                break
//            }
//        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        func p_title() -> String {
            switch indexPath.section {
            case 0:
                return "班级"
            case 1:
                return "课次"
            case 2:
                return "作业"
            default:
                return  ""
            }
        }
        if kind == UICollectionView.elementKindSectionHeader {
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "FilterCollectionHeaderView", for: indexPath) as! FilterCollectionHeaderView
            header.setTitle(p_title())
            return header
        }
        return UICollectionReusableView()
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return  CGSize(width: 100, height: 56)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        .zero
    }
    
}

// UIViewControllerTransitioningDelegate
extension FilterAlertController {
    
    override func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        SFJBasePresentAnimate {
            (presented as? FilterAlertController)?.showContentV()
        }
    }
    
    override func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        SFJBaseDismissAnimate {
            (dismissed as? FilterAlertController)?.dismissContentV()
        }
    }
}


class FilterCollectionHeaderView: UICollectionReusableView {
    
    private lazy var titleLbl: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        lbl.textColor = #colorLiteral(red: 0.5764705882, green: 0.6, blue: 0.6431372549, alpha: 1)
        return lbl
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        addSubview(titleLbl)
        titleLbl.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(15)
            make.top.equalToSuperview().offset(24)
        }
    }
    
    func setTitle(_ title: String?) {
        titleLbl.text = title
    }
    
}

class FilterModel {
    var title: String
    var isSeleted: Bool
    init(title: String, isSeleted: Bool) {
        self.title = title
        self.isSeleted = isSeleted
    }
}

class FilterCell: UICollectionViewCell {
    
    typealias FilterCellBtnClick = ()->()
    var model: FilterModel? = nil {
        didSet {
            guard let model = model else {
                return
            }
            titleBtn.setTitle(model.title, for: .normal)
            titleBtn.isEnabled = !model.isSeleted
            p_setupBtnSeleted(titleBtn)
        }
    }
    
    var btnClickBlock: FilterCellBtnClick?
    
    private lazy var titleBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitleColor(#colorLiteral(red: 0.05882352941, green: 0.1058823529, blue: 0.2, alpha: 1), for: .normal)
        btn.setTitleColor(#colorLiteral(red: 0.1178690866, green: 0.5011495948, blue: 1, alpha: 1), for: .disabled)
        btn.tintColor = .clear
        btn.backgroundColor = #colorLiteral(red: 0.9803921569, green: 0.9803921569, blue: 0.9803921569, alpha: 1)
        btn.layer.cornerRadius = 4
        btn.layer.borderColor = #colorLiteral(red: 0.1178690866, green: 0.5011495948, blue: 1, alpha: 1).cgColor
        btn.clipsToBounds = true
        return btn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        self.backgroundColor = .clear
        
        contentView.addSubview(titleBtn)
        titleBtn.snp.makeConstraints { (make) in
            make.left.right.top.bottom.equalToSuperview()
        }
        titleBtn.addTarget(self, action: #selector(onTitleBtnClick(_:)), for: .touchUpInside)
        
        titleBtn.setTitle("test title", for: .normal)
//        titleBtn.isEnabled = false
        p_setupBtnSeleted(titleBtn)
    }
    
    private func p_setupBtnSeleted(_ btn: UIButton) {
        
        if !btn.isEnabled {
            btn.backgroundColor = #colorLiteral(red: 0.9490196078, green: 0.9647058824, blue: 1, alpha: 1)
            btn.layer.borderWidth = 0.5
        }else {
            btn.backgroundColor = #colorLiteral(red: 0.9803921569, green: 0.9803921569, blue: 0.9803921569, alpha: 1)
            btn.layer.borderWidth = 0
        }
    }
    
    @objc func onTitleBtnClick(_ sender: UIButton) {
        sender.isEnabled = false
        p_setupBtnSeleted(sender)
        
//        model?.isSeleted = true
        btnClickBlock?()
    }
}
