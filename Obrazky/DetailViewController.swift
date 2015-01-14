//
//  DetailPageViewController.swift
//  Obrazky
//
//  Created by Ondra Benes on 13/01/15.
//  Copyright (c) 2015 OB. All rights reserved.
//

import UIKit

class DetailViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {

    var images: Array<Image> = [Image]()
    var selectedImage: Image?

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.setNavigationBarHidden(true, animated: false)

        // self background
        view.backgroundColor = UIColor.blackColor()

        // add share button
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Action, target: self, action: Selector("shareCurrentImage"))

        // data source is myself
        dataSource = self

        // prepare starting view controller
        if let image = selectedImage {
            let viewController = viewControllerForImage(image)
            setViewControllers([viewController], direction: .Forward, animated: false, completion: nil)
        }
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.navigationBar.barStyle = .BlackTranslucent
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)

        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.navigationBar.barStyle = .Default
    }

    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }

    // MARK: - Actions

    func hideNavigationBar() {
        navigationController?.setNavigationBarHidden(true, animated: true)
    }

    func showNavigationBar() {
        navigationController?.setNavigationBarHidden(false, animated: true)
    }

    func shareCurrentImage() {
        if let photoController = viewControllers.last as? PhotoViewController {
            if let image = photoController.imageView.image {
                let items = [image]
                let activityController = UIActivityViewController(activityItems: items, applicationActivities: nil)
                presentViewController(activityController, animated: true, completion: nil)
            }
        }
    }

    // MARK: - Auxiliary

    func findImageIndex(image: Image) -> Int? {

        // find current image in array
        let imageIndex = find(images, image)
        return imageIndex
    }

    func viewControllerForImage(image: Image) -> PhotoViewController {

        // instantiate controller from storyboard
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("photoController") as PhotoViewController
        viewController.image = image

        return viewController
    }

    // MARK: - Page view controller data source

    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {

        let photoController = viewController as PhotoViewController
        if let image = photoController.image {
            if let index = findImageIndex(image) {
                let nextIndex = index + 1

                // check the end
                if nextIndex >= images.endIndex {
                    return nil
                }

                // return next controller
                let nextImage = images[nextIndex]
                return viewControllerForImage(nextImage)
            }
        }

        return nil
    }

    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        let photoController = viewController as PhotoViewController
        if let image = photoController.image {
            if let index = findImageIndex(image) {
                let prevIndex = index - 1

                // check the beginnig
                if prevIndex < 0 {
                    return nil
                }

                // return previous controller
                let prevImage = images[prevIndex]
                return viewControllerForImage(prevImage)
            }
        }
        
        return nil
    }
    
}
