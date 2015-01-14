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
        let photoController = detailController.viewControllers.first as PhotoViewController

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

        //        // Create a temporary view for the zoom in transition and set the initial frame based
        //        // on the reference image view
        //        UIImageView *transitionView = [[UIImageView alloc] initWithImage:self.referenceImageView.image];
        //        transitionView.contentMode = UIViewContentModeScaleAspectFill;
        //        transitionView.clipsToBounds = YES;
        //        transitionView.frame = [transitionContext.containerView convertRect:self.referenceImageView.bounds
        //            fromView:self.referenceImageView];
        //        [transitionContext.containerView addSubview:transitionView];
        //
        //        // Compute the final frame for the temporary view
        //        CGRect finalFrame = [transitionContext finalFrameForViewController:toViewController];
        //        CGRect transitionViewFinalFrame = [self.referenceImageView.image tgr_aspectFitRectForSize:finalFrame.size];
        //
        //        // Perform the transition using a spring motion effect
        //        NSTimeInterval duration = [self transitionDuration:transitionContext];
        //
        //        self.referenceImageView.alpha = 0;
        //
        //        [UIView animateWithDuration:duration
        //            delay:0
        //            usingSpringWithDamping:0.7
        //            initialSpringVelocity:0
        //            options:UIViewAnimationOptionCurveLinear
        //            animations:^{
        //            fromViewController.view.alpha = 0;
        //            transitionView.frame = transitionViewFinalFrame;
        //            }
        //            completion:^(BOOL finished) {
        //            fromViewController.view.alpha = 1;
        //
        //            [transitionView removeFromSuperview];
        //            [transitionContext.containerView addSubview:toViewController.view];
        //
        //            [transitionContext completeTransition:YES];
        //            }];
    }

    func animateZoomOut(context: UIViewControllerContextTransitioning) {
        let fromNavigationController = context.viewControllerForKey(UITransitionContextFromViewControllerKey)! as UINavigationController
        let detailController = fromNavigationController.topViewController as DetailViewController
        let toNavigationController = context.viewControllerForKey(UITransitionContextToViewControllerKey)! as UINavigationController
        let rootController = toNavigationController.topViewController as RootViewController

        let container = context.containerView()
        container.addSubview(fromNavigationController.view)
        container.addSubview(toNavigationController.view)

        fromNavigationController.view.alpha = 1
        toNavigationController.view.alpha = 0

        UIView.animateWithDuration(transitionDuration(context), animations: { () -> Void in
            fromNavigationController.view.alpha = 0
            toNavigationController.view.alpha = 1
        }) { (finished) -> Void in
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
