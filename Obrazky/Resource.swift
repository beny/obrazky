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

                    // unwrapping JSON hell
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
