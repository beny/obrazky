//
//  RootViewController.swift
//  Obrazky
//
//  Created by Ondra Benes on 10/01/15.
//  Copyright (c) 2015 OB. All rights reserved.
//

import UIKit

class RootViewController: UICollectionViewController, UISearchBarDelegate {

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
                if let responseObject = JSON as? NSDictionary {
                    if let result = responseObject["result"] as? NSDictionary {
                        if let boxes = result["boxes"] as? NSString {

                            // title anchorlike'>(.*?)</span>
                            // size <span>(.*?)</span>
                            // originURL dot=\"(.*?)\"
                            // obrazkyURL src=\"(.*?)&

                            var error: NSError?
                            let regexTitle = NSRegularExpression(pattern: "anchorlike'>(.*?)</span>", options: nil, error: &error)
                            let matchesTitle = regexTitle?.matchesInString(boxes, options: nil, range: NSMakeRange(0, boxes.length)) as Array<NSTextCheckingResult>
                            let titles: Array<String> = matchesTitle.map { boxes.substringWithRange($0.rangeAtIndex(1)) }

                            error = nil
                            let regexSize = NSRegularExpression(pattern: "<span>(.*?)</span>", options: nil, error: &error)
                            let matchesSize = regexSize?.matchesInString(boxes, options: nil, range: NSMakeRange(0, boxes.length)) as Array<NSTextCheckingResult>
                            let sizes: Array<String> = matchesSize.map { boxes.substringWithRange($0.rangeAtIndex(1)) }

                            error = nil
                            let regexOriginURL = NSRegularExpression(pattern: "dot=\"(.*?)\"", options: nil, error: &error)
                            let matchesOriginURL = regexOriginURL?.matchesInString(boxes, options: nil, range: NSMakeRange(0, boxes.length)) as Array<NSTextCheckingResult>
                            let originURLs: Array<String> = matchesOriginURL.map { boxes.substringWithRange($0.rangeAtIndex(1)) }

                            error = nil
                            let regexObrazkyURL = NSRegularExpression(pattern: "src=\"(.*?)&", options: nil, error: &error)
                            let matchesObrazkyURL = regexObrazkyURL?.matchesInString(boxes, options: nil, range: NSMakeRange(0, boxes.length)) as Array<NSTextCheckingResult>
                            let obrazkyURLs: Array<String> = matchesObrazkyURL.map { boxes.substringWithRange($0.rangeAtIndex(1)) }

                            self.images.removeAll(keepCapacity: false)
                            for (index, title) in enumerate(titles) {
                                let image = Image(title: title, size: sizes[index], obrazkyURL: obrazkyURLs[index], originURL: originURLs[index])
                                self.images.append(image)
                            }
                        }
                    }
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
        cell.imageView.setImageWithURL(image.obrazkyURL, placeholderImage: UIImage(named: "default-placeholder"))
        return cell
    }

    override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        let view = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "searchHeader", forIndexPath: indexPath) as SearchHeader
        return view
    }

    // MARK: - Collection view delegate

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
