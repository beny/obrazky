//
//  Resource.swift
//  Obrazky
//
//  Created by Ondra Benes on 11/01/15.
//  Copyright (c) 2015 OB. All rights reserved.
//

import Foundation

class Resource {

    let session: AFURLSessionManager

    init() {
        // create session
        session = AFURLSessionManager(sessionConfiguration: NSURLSessionConfiguration.defaultSessionConfiguration())
        session.responseSerializer = AFHTTPResponseSerializer()
    }

    class func parseData(data: AnyObject?) -> (Array<Image>?) {

        // helper closure to find specific
        func findPattern(pattern: String, string: String) -> Array<String>? {
            var error: NSError?
            let regexTitle = NSRegularExpression(pattern: pattern, options: nil, error: &error)
            if (error != nil) {
                return nil
            }
            let matchesResults = regexTitle?.matchesInString(string, options: nil, range: NSMakeRange(0, string.utf16Count)) as Array<NSTextCheckingResult>
            let matches: Array<String> = matchesResults.map { NSString(string: string).substringWithRange($0.rangeAtIndex(1)) }

            return matches
        }

        if let responsObject = data as? NSDictionary {
            if let result = responsObject["result"] as? NSDictionary {
                if let boxes = result["boxes"] as? NSString {

                    // title anchorlike'>(.*?)</span>
                    // size <span>(.*?)</span>
                    // originURL dot=\"(.*?)\"
                    // obrazkyURL src=\"(.*?)&

                    let titles = findPattern("anchorlike'>(.*?)</span>", boxes)
                    let sizes = findPattern("<span>(.*?)</span>", boxes)
                    let originURLs = findPattern("dot=\"(.*?)\"", boxes)
                    let obrazkyURLs = findPattern("src=\"(.*?)&", boxes)

//                    var error: NSError?
//                    let regexTitle = NSRegularExpression(pattern: "anchorlike'>(.*?)</span>", options: nil, error: &error)
//                    let matchesTitle = regexTitle?.matchesInString(boxes, options: nil, range: NSMakeRange(0, boxes.length)) as Array<NSTextCheckingResult>
//                    let titles: Array<String> = matchesTitle.map { boxes.substringWithRange($0.rangeAtIndex(1)) }
//
//                    error = nil
//                    let regexSize = NSRegularExpression(pattern: "<span>(.*?)</span>", options: nil, error: &error)
//                    let matchesSize = regexSize?.matchesInString(boxes, options: nil, range: NSMakeRange(0, boxes.length)) as Array<NSTextCheckingResult>
//                    let sizes: Array<String> = matchesSize.map { boxes.substringWithRange($0.rangeAtIndex(1)) }
//
//                    error = nil
//                    let regexOriginURL = NSRegularExpression(pattern: "dot=\"(.*?)\"", options: nil, error: &error)
//                    let matchesOriginURL = regexOriginURL?.matchesInString(boxes, options: nil, range: NSMakeRange(0, boxes.length)) as Array<NSTextCheckingResult>
//                    let originURLs: Array<String> = matchesOriginURL.map { boxes.substringWithRange($0.rangeAtIndex(1)) }
//
//                    error = nil
//                    let regexObrazkyURL = NSRegularExpression(pattern: "src=\"(.*?)&", options: nil, error: &error)
//                    let matchesObrazkyURL = regexObrazkyURL?.matchesInString(boxes, options: nil, range: NSMakeRange(0, boxes.length)) as Array<NSTextCheckingResult>
//                    let obrazkyURLs: Array<String> = matchesObrazkyURL.map { boxes.substringWithRange($0.rangeAtIndex(1)) }

                    if let titles = titles {
                        if let sizes = sizes {
                            if let originURLs = originURLs {
                                if let obrazkyURLs = obrazkyURLs {
                                    var array = [Image]()
                                    for (index, title) in enumerate(titles) {
                                        let image = Image(title: title, size: sizes[index], obrazkyURL: obrazkyURLs[index], originURL: originURLs[index])
                                        array.append(image)
                                    }

                                    return array
                                }
                            }
                        }
                    }
                }
            }
        }

        return nil
    }

}
