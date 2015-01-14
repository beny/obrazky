//
//  UIImage.swift
//  Obrazky
//
//  Created by Ondra Benes on 14/01/15.
//  Copyright (c) 2015 OB. All rights reserved.
//

import UIKit

extension UIImage {

    func aspectRatioSize(size: CGSize) -> CGRect {
        let targetAspect = Float(size.width / size.height);
        let sourceAspect = Float(self.size.width / self.size.height);
        var rectHeight: Float = 0, rectWidth: Float = 0, rectX: Float = 0, rectY: Float = 0

        if (targetAspect > sourceAspect) {
            rectHeight = Float(size.height);
            rectWidth = ceilf(rectHeight * sourceAspect);
            rectX = ceilf((Float(size.width) - rectWidth) * 0.5);
        }
        else {
            rectWidth = Float(size.width);
            rectHeight = ceilf(rectWidth / sourceAspect);
            rectY = ceilf((Float(size.height) - rectHeight) * 0.5);
        }

        return CGRectMake(CGFloat(rectX), CGFloat(rectY), CGFloat(rectWidth), CGFloat(rectHeight))
    }
}

