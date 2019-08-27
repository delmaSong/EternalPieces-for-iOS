//
//  TattistAnimation.swift
//  EternalPieces
//
//  Created by delma on 24/08/2019.
//  Copyright © 2019 다0. All rights reserved.
//

import Foundation
import UIKit
class TattistAnimation: NSObject, UITabBarControllerDelegate{
   
    
    func tabBarController(_ tabBarController: UITabBarController, animationControllerForTransitionFrom fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return ScrollAni(tabBarController: tabBarController)
    }
}

class ScrollAni: NSObject, UIViewControllerAnimatedTransitioning{
    
    var transitionContext: UIViewControllerContextTransitioning?
    var tabBarController : UITabBarController!
    var fromIndex = 0
    
    init(tabBarController : UITabBarController){
        self.tabBarController = tabBarController
        self.fromIndex = tabBarController.selectedIndex
    }
    
    //애니메이션 시간 지정
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        //뷰 만들어주기
        self.transitionContext = transitionContext
        let containerView = transitionContext.containerView
        
        //원래 뷰
        let fromView = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)
        //추가될 뷰
        let toView = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)
        containerView.addSubview(toView!.view)
        
        var width = toView?.view.bounds.width
        
        //현재 포지션과 새로운 포지션 비교
        if tabBarController.selectedIndex < fromIndex{
            width = -width!
        }
        
        toView!.view.transform = CGAffineTransform(translationX: width!, y: 0)
        
        UIView.animate(withDuration: self.transitionDuration(using: (self.transitionContext)), animations: {
            //입력되는 뷰
            toView?.view.transform = CGAffineTransform.identity
            fromView?.view.transform = CGAffineTransform(translationX: -width!, y: 0)
        }, completion: { _ in
            
            fromView?.view.transform = CGAffineTransform.identity
            self.transitionContext?.completeTransition(!self.transitionContext!.transitionWasCancelled)
            
        })
    }
}
