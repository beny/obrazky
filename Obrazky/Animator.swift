//
//  TransitionManager.swift
//  Obrazky
//
//  Created by Ondra Benes on 13/01/15.
//  Copyright (c) 2015 OB. All rights reserved.
//

import UIKit

class Animator: NSObject, UIViewControllerAnimatedTransitioning, UIViewControllerTransitioningDelegate {

    // MARK: - View controller animated transitioning

    func transitionDuration(transitionContext: UIViewControllerContextTransitioning) -> NSTimeInterval {
        return 0.3
    }

    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {

        let viewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!
        if viewController.isBeingPresented() {
            animateZoomIn(transitionContext)
        }
        else {
            animateZoomOut(transitionContext)
        }
    }

    func animateZoomIn(context: UIViewControllerContextTransitioning) {
        let fromNavigationController = context.viewControllerForKey(UITransitionContextFromViewControllerKey)! as UINavigationController
        let rootController = fromNavigationController.topViewController as RootViewController
        let toNavigationController = context.viewControllerForKey(UITransitionContextToViewControllerKey)! as UINavigationController
        let detailController = toNavigationController.topViewController as DetailViewController
        let photoController = (detailController.viewControllers as NSArray).firstObject as PhotoViewController

        // add both controllers to container
        let container = context.containerView()
        container.addSubview(fromNavigationController.view)
        container.addSubview(toNavigationController.view)

        // hide origin image
        let selectedImageView = rootController.selectedImageView!
        selectedImageView.alpha = 0

        // create temporary view
        let transitionView = UIImageView(image: selectedImageView.image)
        transitionView.contentMode = .ScaleAspectFill
        transitionView.clipsToBounds = true
        transitionView.frame = context.containerView().convertRect(selectedImageView.bounds, fromView: selectedImageView)
        container.addSubview(transitionView)

        // calculate final frame
        let finalFrame = context.finalFrameForViewController(toNavigationController)
        let transitionViewFinalFrame = selectedImageView.image?.aspectRatioSize(finalFrame.size)
        toNavigationController.view.alpha = 0
        photoController.imageView.alpha = 0

        UIView.animateWithDuration(transitionDuration(context), animations: { () -> Void in
            fromNavigationController.view.alpha = 0
            toNavigationController.view.alpha = 1
            transitionView.frame = transitionViewFinalFrame!
            }) { (finished) -> Void in
                fromNavigationController.view.alpha = 1
                selectedImageView.alpha = 1
                photoController.imageView.alpha = 1
                detailController.startTimer()
                transitionView.removeFromSuperview()
                context.completeTransition(true)
        }
    }

    func animateZoomOut(context: UIViewControllerContextTransitioning) {

        let fromNavigationController = context.viewControllerForKey(UITransitionContextFromViewControllerKey)! as UINavigationController
        let detailController = fromNavigationController.topViewController as DetailViewController
        let photoController = (detailController.viewControllers as NSArray).firstObject as PhotoViewController
        let toNavigationController = context.viewControllerForKey(UITransitionContextToViewControllerKey)! as UINavigationController
        let rootController = toNavigationController.topViewController as RootViewController

        // add both controllers to container
        let container = context.containerView()
        container.addSubview(fromNavigationController.view)
        container.addSubview(toNavigationController.view)
        container.sendSubviewToBack(toNavigationController.view)

        // calculate initial and final frame
        let sourceImageView = detailController.currentViewController()?.imageView!
        let destinationImageView = rootController.findImageCell(detailController.currentViewController()!.image!)!.imageView
        let initFrame = sourceImageView!.image!.aspectRatioSize(sourceImageView!.bounds.size)
        let transitionInitialViewFrame = context.containerView().convertRect(initFrame, fromView: sourceImageView)
        let finalFrame = context.containerView().convertRect(destinationImageView.bounds, fromView: destinationImageView)

        // create temporary view
        let transitionView = UIImageView(image: destinationImageView.image)
        transitionView.contentMode = .ScaleAspectFill
        transitionView.clipsToBounds = true
        transitionView.frame = transitionInitialViewFrame
        container.addSubview(transitionView)

        toNavigationController.view.alpha = 0
        photoController.imageView.alpha = 0

        UIView.animateWithDuration(transitionDuration(context), animations: { () -> Void in
            fromNavigationController.view.alpha = 0
            toNavigationController.view.alpha = 1
            transitionView.frame = finalFrame
            }) { (finished) -> Void in
                fromNavigationController.view.alpha = 1
                destinationImageView.alpha = 1
                transitionView.removeFromSuperview()
                context.completeTransition(true)
        }
    }

    // MARK: - View controller transitioning delegate

    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }

    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
   
}
