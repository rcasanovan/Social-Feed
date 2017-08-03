//
//  SFInstagramProvider.swift
//  Social Feed
//
//  Created by Ricardo Casanova on 03/08/2017.
//  Copyright © 2017 Social Feed. All rights reserved.
//

import UIKit

class SFInstagramProvider: SFBaseProvider {
    public func instagramProviderPopularMedia() {
        self.instagramRequestManager.requestPopularMedia()
    }
    
    public func instagramProviderSelfFeedOn(completion: @escaping (_ itemFeeds: [SFItemFeed], _ error: ProviderErrorCode) -> Void) {
        self.instagramRequestManager.requestSelfFeedOncompletion { (items: [InstagramMedia]?, success: Bool, error: Error?) in
            var modelItems: [SFItemFeed] = []
            if (success) {
                for item in items! {
                    let text = item.caption?.text
                    let lowResolutionImageURL = item.lowResolutionImageURL
                    let standardResolutionImageURL = item.standardResolutionImageURL
                    let isVideo = item.isVideo
                    let username = item.user.username
                    let createdDate = item.createdDate
                    let userImageURL = item.user.profilePictureURL
                    let locationName = item.locationName != nil ? item.locationName : ""
                    
                    if (!isVideo) {
                        let modelItem = SFItemFeed(text: text!, lowResolutionImageURL: lowResolutionImageURL, standardResolutionImageURL: standardResolutionImageURL, username: username, createdDate: createdDate, userImageURL: userImageURL!, locationName: locationName!)
                        modelItems.append(modelItem)
                    }
                }
                completion(modelItems, ProviderErrorCode.everythingOKCode)
            }
            completion(modelItems, ProviderErrorCode.serverErrorCode)
        }
    }
    
    public func instagramProviderIsSessionValid()-> Bool {
        return self.instagramRequestManager.isSessionValid()
    }
    
    public func instagramProviderAuthorizationURL()-> NSURL {
        return self.instagramRequestManager.authorizationURL()! as NSURL
    }
    
    public func instagramProviderReceivedValidAccessTokenFromURL(url: NSURL)-> Bool {
        return self.instagramRequestManager.receivedValidAccessToken(from: url as URL!)
    }
}
