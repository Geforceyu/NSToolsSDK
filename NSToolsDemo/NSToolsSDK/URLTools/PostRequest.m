/**
 *
 * PostRequest.m
 *
 * Create By limao@rimi.com 2014-1-3.
 * Copyright (c) 2014 Nemo. All rights reserved.
 *
 */

/* ARC Warning */
#if ! __has_feature(objc_arc)
#warning This file must be compiled with ARC. Use -fobjc-arc flag (or convert project to ARC).
#endif

#import "PostRequest.h"
#import "NSTools.h"

@interface PostRequest () <NSURLConnectionDataDelegate>

@property (nonatomic, strong) NSMutableData * receivedData;
@property (nonatomic, assign) NSURLConnection * connection;

@end



@implementation PostRequest

- (void)dealloc
{
    self.completion = nil;
    self.name = nil;
    self.receivedData = nil;
}

- (id)initWithURL:(NSURL *)URL paramsDic:(NSDictionary *)paramsDic timeoutInterval:(NSTimeInterval)timeoutInterval completion:(void (^)(id, PostEndState))completion
{
    self = [super initWithURL:URL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:timeoutInterval];
    if (self) {
        self.completion = completion;
        self.HTTPMethod = @"POST";
        self.receivedData = [[NSMutableData alloc]init];
        if (paramsDic) {
            self.HTTPBody = [NSTools dataWithDictionary:paramsDic];
        }
    }
    return self;
}

- (void)startAsync
{
    NSURLConnection * connection = [[NSURLConnection alloc] initWithRequest:self delegate:self startImmediately:YES];
    self.connection = connection;
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.receivedData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSError * error = nil;
    id content = [NSJSONSerialization JSONObjectWithData:self.receivedData options:NSJSONReadingMutableLeaves error:&error];
    if (error) {
        NSLog(@"JSON Analysis Error:%@",error.localizedDescription);
        if (self.completion) {
            self.completion(nil, PostEndStateAnalysisFailed);
        }
        [self.delegate PostRequestEnded:self];
    }
    else {
        if (self.completion) {
            self.completion(content, PostEndStateSucceed);
        }
        [self.delegate PostRequestEnded:self];
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"Request Failed! Error:%@",error.localizedDescription);
    if (self.completion) {
        self.completion(nil, PostEndStateFailed);
    }
    [self.delegate PostRequestEnded:self];
}

-(void)cancel
{
    [self.connection cancel];
    NSLog(@"Requst Cancelled!");
    if (self.completion) {
        self.completion(nil, PostEndStateCancelled);
    }
    [self.delegate PostRequestEnded:self];

}
@end
