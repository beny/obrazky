//
//  PhotoViewController.swift
//  Obrazky
//
//  Created by Ondra Benes on 14/01/15.
//  Copyright (c) 2015 OB. All rights reserved.
//

import UIKit

class PhotoViewController: UIViewController, UIScrollViewDelegate {

    // views
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!

    // data
    var image: Image?

    // MARK: - View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        // add constraints
        scrollView.removeConstraints(scrollView.constraints())
        imageView.removeConstraints(imageView.constraints())
        let views = ["scrollView": scrollView, "imageView": imageView]
//        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[scrollView]|", options: nil, metrics: nil, views: views))
//        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[scrollView]|", options: nil, metrics: nil, views: views))
        view.addConstraint(NSLayoutConstraint(item: imageView, attribute: .Width, relatedBy: .Equal, toItem: view, attribute: .Width, multiplier: 1, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: imageView, attribute: .Height, relatedBy: .Equal, toItem: view, attribute: .Height, multiplier: 1, constant: 0))
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)

        if let image = image {
            imageView.setImageWithURL(image.originURL, placeholderImage: UIImage(named: "default-placeholder"))
        }
    }

    // MARK: - Actions

    @IBAction func toggleBarVisibility(sender: AnyObject) {

        if let navigationController = navigationController {
            if navigationController.navigationBarHidden {
                navigationController.setNavigationBarHidden(false, animated: true)
            }
            else {
                navigationController.setNavigationBarHidden(true, animated: true)
            }
        }
    }

    // MARK: - Scroll view delegate

    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return self.imageView
    }
}
