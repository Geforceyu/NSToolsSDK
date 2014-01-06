//
//  RootView.m
//  NSToolsSDK
//
//  Created by Nemo on 14-1-4.
//  Copyright (c) 2014年 Nemo. All rights reserved.
//

#import "RootView.h"
#import "NSTools.h"

@interface RootView ()<NTEditeViewDelegate, NTAlertViewDelegate>
{
    UITextView * editeViewTestTtv;
    UITextView * postTestURLTtv;
    UITextView * postTestActionTtv;
    UIButton * alertTest;
}
- (void)editeViewTest;

@end

@implementation RootView

- (id)init
{
    self = [super init];
    if (self) {
        UIButton * editeViewTestButton = [[UIButton alloc] initWithFrame:CGRectMake(20, 20, 150, 35)];
        [editeViewTestButton setTitle:@"TextViewTest" forState:UIControlStateNormal];
        [NSTools setButtonStyle:editeViewTestButton cornerRadius:10 backgroundColor:_AlmostWhite titleColor:_KeyWordsColor titleFont:_KeyWordsFont];
        [self addSubview:editeViewTestButton];
        [editeViewTestButton addTarget:self action:@selector(editeViewTest) forControlEvents:UIControlEventTouchUpInside];
        
        editeViewTestTtv = [[UITextView alloc] initWithFrame:CGRectMake(180, 20, 800, 35)];
        editeViewTestTtv.font = [UIFont systemFontOfSize:16];
        editeViewTestTtv.textColor = [UIColor darkGrayColor];
        editeViewTestTtv.text = @"EditeView Widget Test.";
        editeViewTestTtv.editable = NO;
        [[editeViewTestTtv layer] setCornerRadius:10];
        editeViewTestTtv.backgroundColor = [UIColor colorWithWhite:0.975 alpha:1];
        [self addSubview:editeViewTestTtv];
        
        UIButton * postTest = [[UIButton alloc] initWithFrame:CGRectMake(20, 60, 150, 35)];
        [postTest setTitle:@"PostTest" forState:UIControlStateNormal];
        [NSTools setButtonStyle:postTest cornerRadius:10 backgroundColor:_AlmostWhite titleColor:_KeyWordsColor titleFont:_KeyWordsFont];
        [self addSubview:postTest];
        [postTest addTarget:self action:@selector(testPost) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton * cancelPost = [[UIButton alloc] initWithFrame:CGRectMake(20, 100, 150, 35)];
        [cancelPost setTitle:@"Cancel" forState:UIControlStateNormal];
        [NSTools setButtonStyle:cancelPost cornerRadius:10 backgroundColor:_AlmostWhite titleColor:_KeyWordsColor titleFont:_KeyWordsFont];
        [self addSubview:cancelPost];
        [cancelPost addTarget:self action:@selector(cancelPost) forControlEvents:UIControlEventTouchUpInside];
        
        UILabel * URLTips = [[UILabel alloc] initWithFrame:CGRectMake(180, 65, 80, 25)];
        [URLTips setText:@"PostURL:"];
        [self addSubview:URLTips];
        
        postTestURLTtv = [[UITextView alloc] initWithFrame:CGRectMake(270, 60, 710, 35)];
        postTestURLTtv.text = @"http://e.rimiedu.com/front_ios!home.action";
        postTestURLTtv.font = [UIFont systemFontOfSize:16];
        postTestURLTtv.textColor = [UIColor darkGrayColor];
        [[postTestURLTtv layer] setCornerRadius:10];
        postTestURLTtv.backgroundColor = [UIColor colorWithWhite:0.975 alpha:1];
        [self addSubview:postTestURLTtv];
        
        alertTest = [[UIButton alloc] initWithFrame:CGRectMake(20, 140, 150, 35)];
        [alertTest setTitle:@"AlertTest" forState:UIControlStateNormal];
        [NSTools setButtonStyle:alertTest cornerRadius:10 backgroundColor:_AlmostWhite titleColor:_KeyWordsColor titleFont:_KeyWordsFont];
        [self addSubview:alertTest];
        [alertTest addTarget:self action:@selector(alertTest) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return self;
}

- (void)reLayout
{
    alertTest.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    NSLog(@"%@",NSStringFromCGPoint(self.center));
}

- (void)editeViewTest
{
    [NSTools showEditeViewWithTitle:@"Test" originMessage:editeViewTestTtv.text confirmButtonTitle:@"Comfirm" delegate:self maxWordsCount:60 minWordsCount:10];
}

- (void)editeView:(NTEditeView *)editeView didFinishedEditeWithMessage:(NSString *)message
{
    if (![message isEqualToString:editeViewTestTtv.text]) {
        editeViewTestTtv.text = message;
    }
}

- (void)testPost
{
    NTAlertView * alertView = nil;
    [NSTools showAlertWithTitle:@"Tips" message:@"Posting Request! Please Wait..." cancelButtonTitle:@"Cancel" confirmButtonTitle:nil callBackAction:^(NSInteger buttonIndex) {
        if ([alertView.message isEqualToString:@"Posting Request! Please Wait..."]) {
            [NSTools cancelPostWithPostName:@"testPost"];
        }
    } keepPointer:&alertView delegate:nil];
    
    [NSTools asyncPostWithURLString:postTestURLTtv.text  paramsDic:nil postName:@"testPost" withCompletion:^(id content, PostEndState state) {
        if (state == PostEndStateSucceed) {
            [alertView cancelWithMessage:nil dely:0.5];
        }
        if (state == PostEndStateFailed || state == PostEndStateAnalysisFailed) {
            [alertView reloadMessage:[NSString stringWithFormat:@"Post Failed!\n%@",content] cancelButtonTitle:@"OK" confirmButtonTitile:nil];
        }
    }];
}

- (void)cancelPost
{
    [NSTools cancelPostWithPostName:@"testPost"];
}

- (void)alertTest
{
    [NSTools showAlertWithTitle:@"Tips" message:@"This is a NTAlertView" cancelButtonTitle:@"Cancel" confirmButtonTitle:@"OK" callBackAction:^(NSInteger buttonIndex) {
        NSLog(@"%d",buttonIndex);
    } keepPointer:nil delegate:nil];
}

@end
