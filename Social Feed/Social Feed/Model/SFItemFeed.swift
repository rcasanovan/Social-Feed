//
//  SFItemFeed.swift
//  Social Feed
//
//  Created by Ricardo Casanova on 03/08/2017.
//  Copyright © 2017 Social Feed. All rights reserved.
//

import UIKit

enum ItemFeedType {
    case instagramFeedType
    case twitterFeedType
}

class SFItemFeed: NSObject {
    //__ Atributtes
    internal var text : String?
    internal var lowResolutionImageURL : URL?
    internal var standardResolutionImageURL : URL?
    internal var username : String?
    internal var createdDate : Date?
    internal var userImageURL : URL?
    internal var locationName : String?
    internal var feedType: ItemFeedType?

    //__ Init method for Instagram
    init(text: String, lowResolutionImageURL: URL, standardResolutionImageURL: URL, username: String, createdDate: Date, userImageURL: URL, locationName: String) {
        super.init()
        self.text = text
        self.lowResolutionImageURL = lowResolutionImageURL
        self.standardResolutionImageURL = standardResolutionImageURL
        self.username = username
        self.createdDate = createdDate
        self.userImageURL = userImageURL
        self.locationName = locationName
        self.feedType = ItemFeedType.instagramFeedType
    }
    
    //__ Init method for Twitter
    init(text: String, userImageURL: URL, username: String, standardResolutionImageURL: URL?, createdDate: Date) {
        super.init()
        self.text = text
        self.userImageURL = userImageURL
        self.standardResolutionImageURL = standardResolutionImageURL
        self.lowResolutionImageURL = nil
        self.username = username
        self.createdDate = createdDate
        self.locationName = ""
        self.feedType = ItemFeedType.twitterFeedType
    }
}
