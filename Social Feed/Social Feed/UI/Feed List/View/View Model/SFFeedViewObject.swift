//
//  SFFeedViewObject.swift
//  Social Feed
//
//  Created by Ricardo Casanova on 03/08/2017.
//  Copyright © 2017 Social Feed. All rights reserved.
//

import UIKit

class SFFeedViewObject: NSObject, DVATableViewModelProtocol {
    //__ Atributtes
    internal var itemUsername: String?
    internal var itemImageURL: URL?
    internal var itemText: String!
    internal var itemUserImageURL: URL?
    internal var itemLocationName: String?
    internal var itemType: ItemFeedType?
    internal var itemTextFont: UIFont!
    
    //__ Init method
    init(itemUsername: String, itemImageURL: URL, itemText: String, itemUserImageURL: URL, itemLocationName: String, itemType: ItemFeedType) {
        super.init()
        self.itemUsername = itemUsername
        self.itemImageURL = itemImageURL
        self.itemText = itemText
        self.itemUserImageURL = itemUserImageURL
        self.itemLocationName = itemLocationName
        self.itemTextFont = UIFont.systemFont(ofSize: 15.0)
        self.itemType = itemType
    }
    
    //__ Init method for twitter feed
    init(itemText: String, itemUserImageURL: URL, username: String, itemImageURL: URL?, itemType: ItemFeedType) {
        super.init()
        self.itemUsername = username
        self.itemImageURL = itemImageURL
        self.itemText = itemText
        self.itemUserImageURL = itemUserImageURL
        self.itemLocationName = ""
        self.itemTextFont = UIFont.systemFont(ofSize: 15.0)
        self.itemType = itemType
    }
    
    //__ Generate the account objects to use un UI (all accounts)
    internal class func generateItemObjects(itemObjects : [SFItemFeed]) -> Array<SFFeedViewObject> {
        var items: [SFFeedViewObject] = []
        for item in itemObjects {
            if (item.feedType == ItemFeedType.instagramFeedType) {
                let instagramItem = SFFeedViewObject(itemUsername: item.username!, itemImageURL: item.standardResolutionImageURL!, itemText: item.text!, itemUserImageURL: item.userImageURL!, itemLocationName: item.locationName!, itemType: item.feedType!)
                items.append(instagramItem)
            }
            else {
                let twitterItem = SFFeedViewObject(itemText: item.text!, itemUserImageURL: item.userImageURL!, username: item.username!, itemImageURL: item.standardResolutionImageURL, itemType: item.feedType!)
                items.append(twitterItem)
            }
        }
        return items
    }
    
    //__ Set the cell identifier
    func dva_cellIdentifier() -> String! {
        if self.itemType == ItemFeedType.instagramFeedType {
            return SFInstagramFeedTableViewCell.description()
        }
        
        if self.itemType == ItemFeedType.twitterFeedType && self.itemImageURL != nil {
            return SFTwitterFeedImageTableViewCell.description()
        }
        
        return SFTwitterFeedTableViewCell.description()
    }
}
