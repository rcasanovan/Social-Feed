//
//  SFBaseProvider.swift
//  Social Feed
//
//  Created by Ricardo Casanova on 03/08/2017.
//  Copyright © 2017 Social Feed. All rights reserved.
//

import UIKit

class SFBaseProvider: NSObject {
    public var instagramRequestManager: SFInstagramRequestManager!;
    
    override init() {
        self.instagramRequestManager = SFInstagramRequestManager.shared()
    }
}
