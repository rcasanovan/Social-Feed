//
//  SFInstagramProvider.swift
//  Social Feed
//
//  Created by Ricardo Casanova on 03/08/2017.
//  Copyright © 2017 Social Feed. All rights reserved.
//

import UIKit

class SFInstagramProvider: SFBaseProvider {
    //__ Method to get popular media feed list
    //__ NOTE: this method is just for testing. We can't retrieve this data in Sandbox mode
    public func instagramProviderPopularMedia() {
        self.instagramRequestManager.requestPopularMedia()
    }
    
    //__ Method to get user's own feed list
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
                    
                    //__ Not process video feed
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
    
    //__ Method to validate if session is valid or not
    public func instagramProviderIsSessionValid()-> Bool {
        return self.instagramRequestManager.isSessionValid()
    }
    
    //__ Method to get authorization URL
    public func instagramProviderAuthorizationURL()-> NSURL {
        return self.instagramRequestManager.authorizationURL()! as NSURL
    }
    
    //__ Method to get user's token from URL
    public func instagramProviderReceivedValidAccessTokenFromURL(url: NSURL)-> Bool {
        return self.instagramRequestManager.receivedValidAccessToken(from: url as URL!)
    }
    
    //__ Method to logout
    public func instagramProviderLogout() {
        return self.instagramRequestManager.logout()
    }
}
