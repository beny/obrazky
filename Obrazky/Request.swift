//
//  Request.swift
//  Obrazky
//
//  Created by Ondra Benes on 11/01/15.
//  Copyright (c) 2015 OB. All rights reserved.
//

import UIKit

enum Color: String {
    case Any = "any"
    case BlackWhite = "no"
}

enum Size: String {
    case Any = "any"
    case Small = "800-"
    case Large = "50-400"
}

class Request: NSMutableURLRequest {

    class func searchAjaxRequest(query: String, from: Int = 0, step: Int = 10, size: Size = .Any, color: Color = .Any) -> NSMutableURLRequest? {
        let baseURL = "http://obrazky.cz/searchAjax"
        let params = ["q": query, "s": "", "step": step, "size": "any", "color": "any", "filter": true, "from": 21]

        var error: NSError?
        let request = AFHTTPRequestSerializer().requestWithMethod("GET", URLString: baseURL, parameters: params, error: &error)

        if (error != nil) {
            return nil
        }
        else {
            return request
        }
    }
    
}