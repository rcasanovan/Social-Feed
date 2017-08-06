//
//  SFInstagramRequestManager.m
//  Social Feed
//
//  Created by Ricardo Casanova on 03/08/2017.
//  Copyright © 2017 Social Feed. All rights reserved.
//

#import "SFInstagramRequestManager.h"

//__ Instagram Kit
#import "InstagramKit.h"

@interface SFInstagramRequestManager ()

@property (nonatomic, weak) InstagramEngine         *instagramEngine;
@property (nonatomic, weak) InstagramPaginationInfo *currentPaginationInfo;

@end

@implementation SFInstagramRequestManager

//__ Shared instance (singleton's instance)
+ (instancetype)shared {
    static SFInstagramRequestManager *requestManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        requestManager = [SFInstagramRequestManager new];
        requestManager.instagramEngine = [InstagramEngine sharedEngine];
        requestManager.currentPaginationInfo = nil;
    });
    return requestManager;
}

//__ This method is just for testing. We can't get this information in Sandbox mode
- (void)requestPopularMedia {
    [self.instagramEngine getPopularMediaWithSuccess:^(NSArray<InstagramMedia *> * _Nonnull media, InstagramPaginationInfo * _Nonnull paginationInfo) {
    } failure:^(NSError * _Nonnull error, NSInteger serverStatusCode) {
    }];
}

//__ Method to get user's own feed list
- (void)requestSelfFeedOncompletion:(SFInstagramRequestManagerCompletionBlock)completionBlock {
    [self.instagramEngine getSelfFeedWithCount:20 maxId:self.currentPaginationInfo.nextMaxId success:^(NSArray<InstagramMedia *> * _Nonnull media, InstagramPaginationInfo * _Nonnull paginationInfo) {
        //__ If we receive information -> self current page pagination info for the next api call
        self.currentPaginationInfo = paginationInfo;
        if (completionBlock) completionBlock(media, YES, nil);
    } failure:^(NSError * _Nonnull error, NSInteger serverStatusCode) {
        if (completionBlock) completionBlock(nil, NO, error);
    }];
}

//__ Method to validate is user's session is valid
- (BOOL)isSessionValid {
    return self.instagramEngine.isSessionValid;
}

//__ Method to get authorization URL
- (NSURL *)authorizationURL {
    return [self.instagramEngine authorizationURL];
}

//__ Method to get user's token
- (BOOL)receivedValidAccessTokenFromURL:(NSURL *)requestURL {
    NSError *error;
    if ([[InstagramEngine sharedEngine] receivedValidAccessTokenFromURL:requestURL error:&error]) {
        return YES;
    }
    return NO;
}

//__ Method to logout
- (void)logout {
    [[InstagramEngine sharedEngine] logout];
}

@end
