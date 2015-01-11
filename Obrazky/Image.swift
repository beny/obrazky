//
//  Image.swift
//  Obrazky
//
//  Created by Ondra Benes on 11/01/15.
//  Copyright (c) 2015 OB. All rights reserved.
//

import UIKit

class Image {

    var title: String
    var size: CGSize
    var obrazkyURL: NSURL?
    var originURL: NSURL?

    init(title: String, size: String, obrazkyURL: String, originURL: String) {
        self.title = title

        if let xPosition = size.rangeOfString("x") {
            let width = size.substringToIndex(xPosition.startIndex) as NSString
            let height = size.substringFromIndex(xPosition.endIndex) as NSString

            self.size = CGSizeMake(CGFloat(width.floatValue), CGFloat(height.floatValue))
        }
        else {
            self.size = CGSizeMake(0, 0)
        }

        if let URL = NSURL(string: obrazkyURL) {
            self.obrazkyURL = URL
        }

        if let URL = NSURL(string: originURL) {
            self.originURL = URL
        }
    }
}
