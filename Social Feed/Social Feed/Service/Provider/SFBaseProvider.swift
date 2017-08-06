//
//  SFBaseProvider.swift
//  Social Feed
//
//  Created by Ricardo Casanova on 03/08/2017.
//  Copyright © 2017 Social Feed. All rights reserved.
//

import UIKit

enum ProviderErrorCode {
    case everythingOKCode
    case serverErrorCode
}

class SFBaseProvider: NSObject {
    public var instagramRequestManager: SFInstagramRequestManager!;
    public var twitterRequestManager: SFTwitterRequestManager!;
    
    override init() {
        self.instagramRequestManager = SFInstagramRequestManager.shared()
        self.twitterRequestManager = SFTwitterRequestManager.shared
    }
}
