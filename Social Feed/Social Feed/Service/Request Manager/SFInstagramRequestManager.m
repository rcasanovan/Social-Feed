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

- (void)requestSelfFeedOncompletion:(SFInstagramRequestManagerCompletionBlock)completionBlock {
    [self.instagramEngine getSelfFeedWithCount:20 maxId:self.currentPaginationInfo.nextMaxId success:^(NSArray<InstagramMedia *> * _Nonnull media, InstagramPaginationInfo * _Nonnull paginationInfo) {
        self.currentPaginationInfo = paginationInfo;
        if (completionBlock) completionBlock(media, YES, nil);
    } failure:^(NSError * _Nonnull error, NSInteger serverStatusCode) {
        if (completionBlock) completionBlock(nil, NO, error);
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
