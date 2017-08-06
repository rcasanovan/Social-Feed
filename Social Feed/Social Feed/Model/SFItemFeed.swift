//
//  SFItemFeed.swift
//  Social Feed
//
//  Created by Ricardo Casanova on 03/08/2017.
//  Copyright © 2017 Social Feed. All rights reserved.
//

import UIKit

//__ Enum for Feed type (Instagram / Twitter)
enum ItemFeedType {
    case instagramFeedType
    case twitterFeedType
}

class SFItemFeed: NSObject {
    //__ Atributtes
    internal var text : String? //__ Text for item feed
    internal var lowResolutionImageURL : URL? //__ Low resolution for image
    internal var standardResolutionImageURL : URL? //__ Standard resolution for image
    internal var username : String? //__ Username
    internal var createdDate : Date? //__ Created at
    internal var userImageURL : URL? //__ User image
    internal var locationName : String? //__ Location
    internal var feedType: ItemFeedType? //__ Feed type (Instagram / Twitter)

    //__ Init method for Instagram feed
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
    
    //__ Init method for Twitter feed
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
