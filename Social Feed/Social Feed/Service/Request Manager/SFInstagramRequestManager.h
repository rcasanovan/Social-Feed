//
//  SFInstagramRequestManager.h
//  Social Feed
//
//  Created by Ricardo Casanova on 03/08/2017.
//  Copyright © 2017 Social Feed. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SFInstagramRequestManager : NSObject

+ (instancetype)shared;
- (void)requestPopularMedia;
- (void)requestSelfFeed;
- (BOOL)isSessionValid;
- (NSURL *)authorizationURL;
- (BOOL)receivedValidAccessTokenFromURL:(NSURL *)requestURL;

@end
