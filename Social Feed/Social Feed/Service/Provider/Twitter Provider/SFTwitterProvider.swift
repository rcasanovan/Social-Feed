//
//  SFTwitterProvider.swift
//  Social Feed
//
//  Created by Ricardo Casanova on 04/08/2017.
//  Copyright © 2017 Social Feed. All rights reserved.
//

import UIKit

import TwitterKit

class SFTwitterProvider: SFBaseProvider {
    private var lasItemId:NSNumber = 0
    
    public func twitterProviderSelfFeedOn(completion: @escaping (_ itemFeeds: [SFItemFeed]?, _ error: ProviderErrorCode) -> Void) {
        self.twitterRequestManager.requestSelfFeed(userId:(Twitter.sharedInstance().sessionStore.session()?.userID)! ,lasItemId: self.lasItemId) { (items: [Any]?, success: Bool, error: Error?) in
            if (success) {
                var modelItems: [SFItemFeed] = []
                for item in items! {
                    var embeddedImageURL: URL?
                    let iTemDictionary = item as! Dictionary<String, AnyObject>
                    let createdAtString = iTemDictionary["created_at"] as! String
                    let createdAt = Date.getDateFromTwitterFormart(stringDate: createdAtString)
                    let initialText = iTemDictionary["text"] as! String
                    var text = initialText
                    let internalUrl = String.extractURLs(text: initialText).first as URL?
                    if (internalUrl != nil) {
                        text = initialText.replacingOccurrences(of: ((String.extractURLs(text: initialText).first as URL?)?.absoluteString)!, with: "")
                    }
                    let entities = iTemDictionary["entities"] as! Dictionary<String, AnyObject>
                        let mediaObject = entities["media"] as! NSArray!
                        if (mediaObject != nil) {
                            let media = mediaObject?.firstObject as! Dictionary<String, AnyObject>?
                            embeddedImageURL = URL(string: media?["media_url_https"] as! String)
                        }
                    let user = iTemDictionary["user"]
                    let userImageURL = user?["profile_image_url"] as! String
                    let username = user?["name"] as! String
                    self.lasItemId = iTemDictionary["id"] as! NSNumber
                    let modelItem = SFItemFeed(text: text, userImageURL: NSURL(string: userImageURL)! as URL, username: username, standardResolutionImageURL: embeddedImageURL, createdDate: createdAt)
                    modelItems.append(modelItem)
                }
                if (modelItems.count > 0) {
                    modelItems.remove(at: modelItems.count-1)
                }
                completion(modelItems, ProviderErrorCode.everythingOKCode)
            }
            completion(nil, ProviderErrorCode.serverErrorCode)
        }
    }
    
    public func twitterProviderIsSessionValid()-> Bool {
        if Twitter.sharedInstance().sessionStore.session()?.userID != nil {
            return true
        }
        return false
    }
    
    public func twitterProviderLogout() {
        Twitter.sharedInstance().sessionStore.logOutUserID((Twitter.sharedInstance().sessionStore.session()?.userID)!)
    }
}
