//
//  SFBaseProvider.swift
//  Social Feed
//
//  Created by Ricardo Casanova on 03/08/2017.
//  Copyright © 2017 Social Feed. All rights reserved.
//

import UIKit

//__ Enum for server response
//__ everythingOKCode -> not errors at all
//__ serverErrorCode -> something happens
enum ProviderErrorCode {
    case everythingOKCode
    case serverErrorCode
}

class SFBaseProvider: NSObject {
    //__ Base provider has two manager
    //__ instagramRequestManager -> Methods to get instagram information
    //__ twitterRequestManager -> Methods to get twitter information
    public var instagramRequestManager: SFInstagramRequestManager!;
    public var twitterRequestManager: SFTwitterRequestManager!;
    
    override init() {
        //__ Get the shared instances
        self.instagramRequestManager = SFInstagramRequestManager.shared()
        self.twitterRequestManager = SFTwitterRequestManager.shared
    }
}
