//
//  NSURLExtension.swift
//  Obrazky
//
//  Created by Ondra Benes on 11/01/15.
//  Copyright (c) 2015 OB. All rights reserved.
//

import UIKit

extension NSURL {

    func imageURL(width: Int) -> NSURL? {
        if let string = self.absoluteString {
            return NSURL(string: string + "&width=\(width)")
        }

        return nil
    }
}
