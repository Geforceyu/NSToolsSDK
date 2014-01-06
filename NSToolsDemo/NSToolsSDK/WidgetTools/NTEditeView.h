/**
 *
 * NTEditeView.h
 *
 * Create By limao@rimi.com 2014-1-3.
 * Copyright (c) 2014 Nemo. All rights reserved.
 *
 */

/* ARC Warning */
#if ! __has_feature(objc_arc)
#warning This file must be compiled with ARC. Use -fobjc-arc flag (or convert project to ARC).
#endif

#import <UIKit/UIKit.h>

@protocol NTEditeViewDelegate;

@interface NTEditeView : UIView

@property (nonatomic, assign) UIView<NTEditeViewDelegate> * delegate;

- (id)initWithTitle:(NSString *)title originMessage:(NSString *)message confirmButtonTitle:(NSString *)confirmButtonTitle delegate:(UIView<NTEditeViewDelegate> *)delegate maxWordsCount:(NSInteger)maxWordsCount minWordsCount:(NSInteger)minWordsCount;
- (void)fadeIn;

@end



/* NTEditeViewDelegate Protocol */
@protocol NTEditeViewDelegate <NSObject>

@optional

- (void)editeView:(NTEditeView *)editeView didFinishedEditeWithMessage:(NSString *)message;

@end
