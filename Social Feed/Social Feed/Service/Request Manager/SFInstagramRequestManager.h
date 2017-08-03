//
//  SFInstagramRequestManager.h
//  Social Feed
//
//  Created by Ricardo Casanova on 03/08/2017.
//  Copyright © 2017 Social Feed. All rights reserved.
//

#import <Foundation/Foundation.h>

//__ Instagram Kit
#import "InstagramMedia.h"

typedef void(^SFInstagramRequestManagerCompletionBlock)(NSArray <InstagramMedia *> *items, BOOL success, NSError *error);

@interface SFInstagramRequestManager : NSObject

+ (instancetype)shared;
- (void)requestPopularMedia;
- (void)requestSelfFeedOncompletion:(SFInstagramRequestManagerCompletionBlock)completionBlock;
- (BOOL)isSessionValid;
- (NSURL *)authorizationURL;
- (BOOL)receivedValidAccessTokenFromURL:(NSURL *)requestURL;

@end
