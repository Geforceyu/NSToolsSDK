/**
 *
 * NTAlertView.m
 *
 * Create By limao@rimi.com 2014-1-5.
 * Copyright (c) 2014 Nemo. All rights reserved.
 *
 */

/* ARC Warning */
#if ! __has_feature(objc_arc)
#warning This file must be compiled with ARC. Use -fobjc-arc flag (or convert project to ARC).
#endif

#import "NTAlertView.h"
#import "NSTools.h"

@interface NTAlertView ()
{
    AlertViewController * viewController;
    UIView              * contentView;
    UILabel             * titleLabel;
    UILabel             * messageLabel;
    UIButton            * cancelButton;
    UIButton            * confirmButton;
}
@property (nonatomic, strong) void(^callbackAction)(NSInteger buttonIndex);
@property (nonatomic, strong) UIWindow * alertWindow;
@property (nonatomic, assign) id<NTAlertViewDelegate> delegate;

- (void)reLayout;

@end

@implementation NTAlertView

- (void)dealloc
{
    self.alertWindow = nil;
    self.callbackAction = nil;
}

- (id)initWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle confirmButtonTitle:(NSString *)confirmButtonTitle callBackAction:(void (^)(NSInteger))callbackAction keepPointer:(NTAlertView *__autoreleasing *)alertView delegate:(id<NTAlertViewDelegate>)delegate
{
    self = [super initWithFrame:[NSTools rootViewController].view.bounds];
    if (self) {
        self.alertWindow = [[UIWindow alloc] initWithFrame:[NSTools rootViewController].view.bounds];
        self.alertWindow.windowLevel = UIWindowLevelAlert;
        viewController = [[AlertViewController alloc] init];
        self.alertWindow.rootViewController = viewController;
        viewController.view = self;
        self.backgroundColor = _ShadeBack;
        
        contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 250, 80)];
        [[contentView layer] setCornerRadius:10];
        [contentView setClipsToBounds:YES];
        contentView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.85];
        [self addSubview:contentView];
        
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, 15, 200, 20)];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.font = [UIFont boldSystemFontOfSize:17];
        titleLabel.text = title ? title : @"Tips";
        [contentView addSubview:titleLabel];
        
        messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, 30, 200, 40)];
        messageLabel.textAlignment = NSTextAlignmentCenter;
        messageLabel.backgroundColor = [UIColor clearColor];
        messageLabel.textColor = [UIColor colorWithWhite:0.2 alpha:1];
        messageLabel.font = [UIFont systemFontOfSize:15];
        messageLabel.numberOfLines = 2;
        messageLabel.text = message ? message : @"Empty Message!\nEmpty Message!";
        _message = message;
        [contentView addSubview:messageLabel];
        
        if (cancelButtonTitle) {
            contentView.frame = CGRectMake(0, 0, 250, 110);
            
            cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(-1, 70, 252, 41)];
            [[cancelButton layer] setBorderWidth:1];
            [[cancelButton layer] setBorderColor:[UIColor colorWithWhite:0.7 alpha:1].CGColor];
            [cancelButton setTitleColor:_KeyWordsColor forState:UIControlStateNormal];
            [cancelButton setTitle:cancelButtonTitle forState:UIControlStateNormal];
            cancelButton.titleLabel.font = [UIFont boldSystemFontOfSize:18];
            [contentView addSubview:cancelButton];
            cancelButton.tag = 0;
            [cancelButton addTarget:self action:@selector(buttonCallbackAction:) forControlEvents:UIControlEventTouchUpInside];
            
            if (confirmButtonTitle) {
                cancelButton.frame = CGRectMake(-1, 70, 127, 41);
                cancelButton.titleLabel.font = [UIFont systemFontOfSize:17];
                
                confirmButton = [[UIButton alloc] initWithFrame:CGRectMake(125, 70, 126, 41)];
                [[confirmButton layer] setBorderWidth:1];
                [[confirmButton layer] setBorderColor:[UIColor colorWithWhite:0.7 alpha:1].CGColor];
                [confirmButton setTitleColor:_KeyWordsColor forState:UIControlStateNormal];
                [confirmButton setTitle:confirmButtonTitle forState:UIControlStateNormal];
                confirmButton.titleLabel.font = [UIFont boldSystemFontOfSize:18];
                [contentView addSubview:confirmButton];
                confirmButton.tag = 1;
                [confirmButton addTarget:self action:@selector(buttonCallbackAction:) forControlEvents:UIControlEventTouchUpInside];
            }
        }
        if (callbackAction) {
            self.callbackAction = callbackAction;
        }
        if (alertView) {
            * alertView = self;
        }
        if (delegate) {
            self.delegate = delegate;
        }
    }
    return self;
}

- (void)buttonCallbackAction:(UIButton *)sender
{
    if (self.callbackAction) {
        self.callbackAction(sender.tag);
    }
    if ([self.delegate respondsToSelector:@selector(alertView:cancelledWithButtonIndex:)]) {
        [self.delegate alertView:self cancelledWithButtonIndex:sender.tag];
    }
    [self cancel];
}

- (void)cancelWithMessage:(NSString *)message dely:(NSTimeInterval)timeInterval
{
    if (message) {
        self.message = message;
    }
    [self performSelector:@selector(cancel) withObject:nil afterDelay:timeInterval];
}

- (void)show
{
    self.alertWindow.alpha = 0;
    contentView.transform = CGAffineTransformMakeScale(1.5, 1.5);
    [self.alertWindow makeKeyAndVisible];
    contentView.center = self.center;
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.alertWindow.alpha = 1;
        contentView.transform = CGAffineTransformMakeScale(1, 1);
    } completion:^(BOOL finished) {
    }];
}

- (void)cancel
{
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        contentView.transform = CGAffineTransformMakeScale(0.5, 0.5);
        self.alertWindow.alpha = 0;
    } completion:^(BOOL finished) {
        viewController.view = nil;
    }];
}

- (void)reLayout
{

    contentView.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
}

- (void)setMessage:(NSString *)message
{
    if (message) {
        _message = message;
        messageLabel.text = message;
    }
}

- (void)reloadMessage:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle confirmButtonTitile:(NSString *)confirmButtonTitle
{
    if (message) {
        self.message = message;
    }
    if (cancelButtonTitle) {
        if (cancelButton) {
            [cancelButton setTitle:cancelButtonTitle forState:UIControlStateNormal];
        }
        else{
            cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(-1, 70, 252, 41)];
            [[cancelButton layer] setBorderWidth:1];
            [[cancelButton layer] setBorderColor:[UIColor colorWithWhite:0.7 alpha:1].CGColor];
            [cancelButton setTitleColor:_KeyWordsColor forState:UIControlStateNormal];
            [cancelButton setTitle:cancelButtonTitle forState:UIControlStateNormal];
            cancelButton.titleLabel.font = [UIFont boldSystemFontOfSize:18];
            [contentView addSubview:cancelButton];
            cancelButton.tag = 0;
            [cancelButton addTarget:self action:@selector(buttonCallbackAction:) forControlEvents:UIControlEventTouchUpInside];
        }
        if (confirmButtonTitle) {
            if (confirmButton) {
                [confirmButton setTitle:confirmButtonTitle forState:UIControlStateNormal];
            }
            else{
                cancelButton.frame = CGRectMake(-1, 70, 127, 41);
                cancelButton.titleLabel.font = [UIFont systemFontOfSize:17];
                
                confirmButton = [[UIButton alloc] initWithFrame:CGRectMake(125, 70, 126, 41)];
                [[confirmButton layer] setBorderWidth:1];
                [[confirmButton layer] setBorderColor:[UIColor colorWithWhite:0.7 alpha:1].CGColor];
                [confirmButton setTitleColor:_KeyWordsColor forState:UIControlStateNormal];
                [confirmButton setTitle:confirmButtonTitle forState:UIControlStateNormal];
                confirmButton.titleLabel.font = [UIFont boldSystemFontOfSize:18];
                [contentView addSubview:confirmButton];
                confirmButton.tag = 1;
                [confirmButton addTarget:self action:@selector(buttonCallbackAction:) forControlEvents:UIControlEventTouchUpInside];
            }
        }
        
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            contentView.bounds = CGRectMake(0, 0, 250, 110);
        } completion:^(BOOL finished) {
            
        }];
    }
}

@end




/* AlertViewController Implementation */
@implementation AlertViewController

- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [(NTAlertView *)self.view reLayout];
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}

- (BOOL)prefersStatusBarHidden
{
    return [[NSTools rootViewController] prefersStatusBarHidden];
}

@end
