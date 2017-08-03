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
    
    public func instagramProviderSelfFeed() {
        self.instagramRequestManager.requestSelfFeed()
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
