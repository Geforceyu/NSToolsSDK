/**
 *
 * NTAlertView.h
 *
 * Create By limao@rimi.com 2014-1-5.
 * Copyright (c) 2014 Nemo. All rights reserved.
 *
 */

/* ARC Warning */
#if ! __has_feature(objc_arc)
#warning This file must be compiled with ARC. Use -fobjc-arc flag (or convert project to ARC).
#endif

#import <UIKit/UIKit.h>
@protocol NTAlertViewDelegate;

#pragma mark NTAlertView Interface
@interface NTAlertView : UIView

@property (nonatomic, assign)NSString * message;

- (id)initWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle confirmButtonTitle:(NSString *)confirmButtonTitle callBackAction:(void(^)(NSInteger buttonIndex))callbackAction keepPointer:(NTAlertView **)alertView delegate:(id<NTAlertViewDelegate>)delegate;
- (void)cancelWithMessage:(NSString *)message dely:(NSTimeInterval)timeInterval;
- (void)reloadMessage:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle confirmButtonTitile:(NSString *)confirmButtonTitle;
- (void)show;

@end


#pragma mark NTAlertViewDelegate Protocol
@protocol NTAlertViewDelegate <NSObject>
@optional

- (void)alertView:(NTAlertView *)alertView cancelledWithButtonIndex:(NSInteger)index;

@end


#pragma mark AlertViewController Interface
@interface AlertViewController : UIViewController

@end
