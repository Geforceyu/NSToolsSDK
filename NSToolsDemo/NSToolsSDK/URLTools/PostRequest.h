/**
 *
 * PostRequest.h
 *
 * Create By limao@rimi.com 2014-1-3.
 * Copyright (c) 2014 Nemo. All rights reserved.
 *
 */

/* ARC Warning */
#if ! __has_feature(objc_arc)
#warning This file must be compiled with ARC. Use -fobjc-arc flag (or convert project to ARC).
#endif

#import <Foundation/Foundation.h>

typedef NSInteger PostEndState;
enum{
    PostEndStateSucceed = 1,
    PostEndStateFailed = 2,
    PostEndStateAnalysisFailed = 3,
    PostEndStateCancelled = 4
};

@protocol PostRequestDelegate;

@interface PostRequest : NSMutableURLRequest

@property (nonatomic, assign) id<PostRequestDelegate> delegate;
@property (nonatomic, strong) void(^completion)(id content, PostEndState state);
@property (nonatomic, strong) NSString * name;

- (id)initWithURL:(NSURL *)URL paramsDic:(NSDictionary *)paramsDic timeoutInterval:(NSTimeInterval)timeoutInterval completion:(void(^)(id content,PostEndState state))completion;
- (void)startAsync;
- (void)cancel;

@end


@protocol PostRequestDelegate <NSObject>

@optional

- (void)PostRequestEnded:(PostRequest *)request;

@end