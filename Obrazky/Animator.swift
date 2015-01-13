//
//  TransitionManager.swift
//  Obrazky
//
//  Created by Ondra Benes on 13/01/15.
//  Copyright (c) 2015 OB. All rights reserved.
//

import UIKit

class Animator: NSObject, UIViewControllerAnimatedTransitioning, UIViewControllerTransitioningDelegate {

    var presenting = true

    // MARK: - View controller animated transitioning

    func transitionDuration(transitionContext: UIViewControllerContextTransitioning) -> NSTimeInterval {
        return 0.5
    }

    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        // get reference for views and controller which are playing roles in animation
        let fromController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!
        let fromView = fromController.view
        let toController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!
        let toView = toController.view

        // superview for the transition animation
        let container = transitionContext.containerView()
        container.addSubview(toView)
        container.addSubview(fromView)

        // prepare for animation
        toView.alpha = 0
        let duration = self.transitionDuration(transitionContext)

        // animate the transition
        UIView.animateWithDuration(duration, animations: { () -> Void in
            fromView.transform = CGAffineTransformMakeScale(0.1, 0.1);
            toView.alpha = 1
            }, completion: { finished in
                fromView.transform = CGAffineTransformIdentity;
                transitionContext.completeTransition(true)
        })
    }

    // MARK: - View controller transitioning delegate

    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        presenting = true
        return self
    }

    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.presenting = false
        return self
    }
   
}
