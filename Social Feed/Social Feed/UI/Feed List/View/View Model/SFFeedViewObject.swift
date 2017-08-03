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
    internal var itemUsername : String?
    internal var itemImageURL : URL?
    internal var itemText : String?
    internal var itemUserImageURL : URL?
    internal var itemLocationName : String?
    
    //__ Init method
    init(itemUsername: String, itemImageURL: URL, itemText: String, itemUserImageURL: URL, itemLocationName: String) {
        super.init()
        self.itemUsername = itemUsername
        self.itemImageURL = itemImageURL
        self.itemText = itemText
        self.itemUserImageURL = itemUserImageURL
        self.itemLocationName = itemLocationName
    }
    
    //__ Generate the account objects to use un UI (all accounts)
    internal class func generateItemObjects(itemObjects : [SFItemFeed]) -> Array<SFFeedViewObject> {
        var items: [SFFeedViewObject] = []
        for item in itemObjects {
            let item = SFFeedViewObject(itemUsername: item.username!, itemImageURL: item.standardResolutionImageURL!, itemText: item.text!, itemUserImageURL: item.userImageURL!, itemLocationName: item.locationName!)
            items.append(item)
        }
        return items
    }
    
    //__ Set the cell identifier
    func dva_cellIdentifier() -> String! {
        return SFInstagramFeedTableViewCell.description()
    }
}
