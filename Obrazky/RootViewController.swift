//
//  RootViewController.swift
//  Obrazky
//
//  Created by Ondra Benes on 10/01/15.
//  Copyright (c) 2015 OB. All rights reserved.
//

import UIKit

class RootViewController: UICollectionViewController, UISearchBarDelegate, UICollectionViewDelegateFlowLayout, DetailViewControllerDelegate {

    var images = Array<Image>()
    var session = Resource().session
    var animator = Animator()
    var selectedImageView: UIImageView?

    var currentDataPage = 1
    var currentQuery: String?
    var currentTask: NSURLSessionDataTask?

    // MARK: - View lifecycle
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

        // choose selected image
        if let cell = sender as? ImageCell {
            if let indexPath = collectionView?.indexPathForCell(cell) {
                let image = images[indexPath.row]
                let navigationController = segue.destinationViewController as UINavigationController
                navigationController.transitioningDelegate = animator
                let detailController = navigationController.topViewController as DetailViewController
                detailController.detailDelegate = self
                detailController.selectedImage = image
                detailController.images = images

                selectedImageView = cell.imageView
            }
        }
    }

    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return self.presentingViewController == nil ? .Default : .LightContent
    }

    // MARK: - Actions

    @IBAction func unwindToViewController(sender: UIStoryboardSegue) {
    }

    // MARK: - Auxiliary

    func fetchData(query: String, fetchNextPage: Bool = false) {

        // new search
        if fetchNextPage {
            currentDataPage += 1
        }
        else {
            currentDataPage = 1
        }

        // save current query
        currentQuery = query

        let request = Request.searchAjaxRequest(query, from: currentDataPage)
        currentTask = session.dataTaskWithRequest(request, completionHandler: { (response, data, error) -> Void in
            if let data = data as? NSData {

                // fix HTML escaping to be valid JSON
                var fixedString = NSString(data: data, encoding: NSUTF8StringEncoding)
                if let string = fixedString {
                    fixedString = string.stringByReplacingOccurrencesOfString("\\'", withString: "'")
                }
                let fixedData = fixedString?.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)

                var error: NSError?
                let JSON: AnyObject? = NSJSONSerialization.JSONObjectWithData(fixedData!, options: NSJSONReadingOptions.MutableContainers, error: &error)

                if (error != nil) {
                    let alert = UIAlertView(title: "Chyba", message: "Došlo k chybě při stahování dat ze serveru. Zkuste prosím hledat znovu", delegate: nil, cancelButtonTitle: nil, otherButtonTitles: "OK")
                    alert.show()
                    return
                }

                // update images
                if !fetchNextPage {
                    // replace all
                    self.images.removeAll(keepCapacity: false)
                    if let images = Resource.parseData(JSON) {
                        self.images = images
                    }
                }
                else {
                    // append new
                    if let images = Resource.parseData(JSON) {
                        for image in images {
                            self.images.append(image)
                        }
                    }
                }
            }
            self.collectionView?.reloadData()
            self.collectionView?.flashScrollIndicators()
        })

        // do not run two task at a moment
        if let task = currentTask {
            if task.state == .Running {
                return
            }
        }

        // start request
        if let task = currentTask {
            task.resume()
        }


    }

    func findImageCell(image: Image) -> ImageCell? {
        if let imageIndex = find(images, image) {
            let indexPath = NSIndexPath(forRow: imageIndex, inSection: 0)
            let cell = collectionView?.cellForItemAtIndexPath(indexPath) as? ImageCell
            return cell
        }

        return nil
    }

    // MARK: - Collection view data source

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {

        let image = images[indexPath.row]
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("imageCell", forIndexPath: indexPath) as ImageCell
        cell.imageView.contentMode = .ScaleAspectFill
        // obrazkyURL?.imageURL(Int(UIScreen.mainScreen().nativeBounds.size.width)
        cell.imageView.setImageWithURL(image.originURL, placeholderImage: UIImage(named: "default-placeholder"))
        cell.titleLabel.text = image.title
        cell.sizeLabel.text = "\(Int(image.size.width))x\(Int(image.size.height))"
        return cell
    }

    // MARK: - Collection view layout

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {

        let image = images[indexPath.row]


        let screenSize = UIScreen.mainScreen().bounds.size
        var width = screenSize.width
        let margin: CGFloat = 8

        // for smaller screens on portrait, for larger screens 
        if screenSize.width < 400 {
            width = width - 2 * margin
        }
        else if screenSize.width < 700 {
            width = (screenSize.width / 2) - 4 * margin
        }
        else {
            width = (screenSize.width / 3) - 6 * margin
        }

        return CGSizeMake(width, width / image.ratio + 21)
    }

    override func didRotateFromInterfaceOrientation(fromInterfaceOrientation: UIInterfaceOrientation) {
        collectionView?.performBatchUpdates(nil, completion: nil)
    }

    // MARK: - Search bar delegate

    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {

        if searchText.isEmpty {
            images.removeAll(keepCapacity: false)
            self.collectionView?.reloadData()
        }
    }

    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        fetchData(searchBar.text)
    }

    // MARK: - Scroll view delegate

    override func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        // hide keyboard when starts scrolling
        self.view.endEditing(true)
    }

    override func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        let currentOffset = scrollView.contentOffset.y
        let maxOffset = scrollView.contentSize.height
        let currentPosition = currentOffset/maxOffset * 100

        if currentPosition > 50 {
            if let query = currentQuery {
                fetchData(query, fetchNextPage: true)
            }
        }
    }

    // MARK: - Detail view controller delegate

    func detailSwitchPageToImage(image: Image) {
        if let imageIndex = find(images, image) {
            let indexPath = NSIndexPath(forRow: imageIndex, inSection: 0)
            collectionView?.scrollToItemAtIndexPath(indexPath, atScrollPosition: .CenteredVertically, animated: false)

            // new layout is needed because otherwise the cell would be offscreen and without frame
            collectionView?.layoutIfNeeded()
        }
    }

}
