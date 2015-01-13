//
//  RootViewController.swift
//  Obrazky
//
//  Created by Ondra Benes on 10/01/15.
//  Copyright (c) 2015 OB. All rights reserved.
//

import UIKit

class RootViewController: UICollectionViewController, UISearchBarDelegate, UICollectionViewDelegateFlowLayout {

    var images = Array<Image>()
    var session = Resource().session

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Actions

    @IBAction func backgroundTapped(sender: AnyObject) {
        view.endEditing(true)
    }

    // MARK: - Auxiliary

    func fetchData(query: String) {
        let request = Request.searchAjaxRequest(query)
        session.dataTaskWithRequest(request, completionHandler: { (response, data, error) -> Void in
            if let data = data as? NSData {

                // fix HTML escaping to be valid JSON
                var fixedString = NSString(data: data, encoding: NSUTF8StringEncoding)
                if let string = fixedString {
                    fixedString = string.stringByReplacingOccurrencesOfString("\\'", withString: "'")
                }
                let fixedData = fixedString?.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)

                var error: NSError?
                let JSON: AnyObject? = NSJSONSerialization.JSONObjectWithData(fixedData!, options: NSJSONReadingOptions.MutableContainers, error: &error)

                // update images
                self.images.removeAll(keepCapacity: false)
                if let images = Resource.parseData(JSON) {
                    self.images = images
                }
            }
            self.collectionView?.reloadData()
        }).resume()
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
//        #if DEBUG
//            // FIXME: debug
//            cell.layer.borderColor = UIColor.greenColor().CGColor
//            cell.layer.borderWidth = 1
//        #endif
        return cell
    }

    override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        let view = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "searchHeader", forIndexPath: indexPath) as SearchHeader
        return view
    }

    // MARK: - Collection view delegate

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

    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {

    }

    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {

        if searchText.isEmpty {
            images.removeAll(keepCapacity: false)
            self.collectionView?.reloadData()
        }
    }

    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        fetchData(searchBar.text)
    }

    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
    }


}
