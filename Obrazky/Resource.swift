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
        session = AFURLSessionManager(sessionConfiguration: NSURLSessionConfiguration.defaultSessionConfiguration())
        session.responseSerializer = AFHTTPResponseSerializer()
    }

    func parseData(response: AnyObject?) {
        
    }

}
