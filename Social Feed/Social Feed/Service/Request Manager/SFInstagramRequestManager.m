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

- (void)requestPopularMedia {
    [self.instagramEngine getPopularMediaWithSuccess:^(NSArray<InstagramMedia *> * _Nonnull media, InstagramPaginationInfo * _Nonnull paginationInfo) {
        NSLog(@"test");
    } failure:^(NSError * _Nonnull error, NSInteger serverStatusCode) {
        NSLog(@"error");
    }];
}

- (void)requestSelfFeed {
    [self.instagramEngine getSelfFeedWithSuccess:^(NSArray<InstagramMedia *> * _Nonnull media, InstagramPaginationInfo * _Nonnull paginationInfo) {
        self.currentPaginationInfo = paginationInfo;
    } failure:^(NSError * _Nonnull error, NSInteger serverStatusCode) {
        NSLog(@"error");
    }];
}

- (BOOL)isSessionValid {
    return self.instagramEngine.isSessionValid;
}

- (NSURL *)authorizationURL {
    return [self.instagramEngine authorizationURL];
}

- (BOOL)receivedValidAccessTokenFromURL:(NSURL *)requestURL {
    NSError *error;
    if ([[InstagramEngine sharedEngine] receivedValidAccessTokenFromURL:requestURL error:&error]) {
        return YES;
    }
    return NO;
}

@end
