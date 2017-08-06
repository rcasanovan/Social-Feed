//
//  SFTwitterRequestManager.swift
//  Social Feed
//
//  Created by Ricardo Casanova on 04/08/2017.
//  Copyright © 2017 Social Feed. All rights reserved.
//

import UIKit

import TwitterKit

class SFTwitterRequestManager: NSObject {
    //__ Shared instance (singleton's instance)
    static let shared = SFTwitterRequestManager()
    
    //__ Method to get user's own feed list
    public func requestSelfFeed(userId:String, lasItemId:NSNumber, completion: @escaping (_ items: [Any]?, _ succes: Bool, _ error: Error?) -> Void) {
        //__ Configure parameters for api call
        var parameters: [String:String] = [:]
        parameters["user_id"] = userId
        parameters["count"] = "20"
        parameters["exclude_replies"] = "1"
        //__ lasItemId.intValue != 0 ? -> isn't the first api call
        if (lasItemId.intValue != 0) {
            parameters["max_id"] = lasItemId.stringValue
        }
        var error : NSError?
        let req = TWTRAPIClient().urlRequest(withMethod: "GET", url: "https://api.twitter.com/1.1/statuses/user_timeline.json", parameters: parameters, error: &error)
        TWTRAPIClient().sendTwitterRequest(req, completion: { (response, data, error) in
            do {
                let response = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [[String : Any]]
                if response != nil {
                    completion(Array(response!), true, nil)
                }
            }
            catch {
                completion(nil, false, error)
            }
        })
    }
}
