//
//  SFJBaseAlertController.swift
//  SFJSheetDemo
//
//  Created by Shafujiu on 2020/11/18.
//  Copyright © 2020 Shafujiu. All rights reserved.
//

import UIKit

class SFJBaseAlertController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        commentInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commentInit()
    }
    
    private func commentInit() {
        modalPresentationStyle = UIModalPresentationStyle.custom
        transitioningDelegate = self
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        dismiss(animated: true, completion: nil)
    }
}

extension SFJBaseAlertController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        SFJBasePresentAnimate(nil)
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        SFJBaseDismissAnimate(nil)
    }
}


class SFJBasePresentAnimate: NSObject, UIViewControllerAnimatedTransitioning {
    typealias SFJBasePresentAnimateShouldBeginBlock = ()->()
    private var animateShouldBeginBlock: SFJBasePresentAnimateShouldBeginBlock?
    
    init(_ animateShouldBeginBlock: SFJBasePresentAnimateShouldBeginBlock?) {
        self.animateShouldBeginBlock = animateShouldBeginBlock
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        guard let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to),
            let _ = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)  else {
            return
        }
        
        let containerV = transitionContext.containerView
        let duration = self.transitionDuration(using: transitionContext)
        
        containerV.addSubview(toVC.view)
        toVC.view.frame = containerV.bounds
        toVC.view.alpha = 0
        // toVC 的 承载内容的动画
//        toVC.showTableView()
        animateShouldBeginBlock?()
        UIView.animate(withDuration: duration, animations: {
            toVC.view.alpha = 1
        }) { (_) in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        0.3
    }
    
}

class SFJBaseDismissAnimate: NSObject, UIViewControllerAnimatedTransitioning {
    
    typealias SFJBaseDismissAnimateShouldBeginBlock = ()->()
    private var animateShouldBeginBlock: SFJBaseDismissAnimateShouldBeginBlock?
    
    init(_ animateShouldBeginBlock: SFJBaseDismissAnimateShouldBeginBlock?) {
        self.animateShouldBeginBlock = animateShouldBeginBlock
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let _ = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to),
            let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from) else {
                return
        }
        
        let duration = self.transitionDuration(using: transitionContext)
        animateShouldBeginBlock?()
        
        UIView.animate(withDuration: duration, animations: {
            fromVC.view.alpha = 0
        }) { (_) in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        0.25
    }
}
