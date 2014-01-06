/**
 *
 * NTEditeView.m
 *
 * Create By limao@rimi.com 2014-1-3.
 * Copyright (c) 2014 Nemo. All rights reserved.
 *
 */

/* ARC Warning */
#if ! __has_feature(objc_arc)
#warning This file must be compiled with ARC. Use -fobjc-arc flag (or convert project to ARC).
#endif

#import "NTEditeView.h"
#import "NSTools.h"

@interface NTEditeView () <UITextViewDelegate>
{
    UIView * contentView;
    UITextView * contentTextView;
    UILabel * wordsLeftCountLabel;
    
    NSInteger minWords;
    NSInteger maxWords;
}
@property (nonatomic, strong) NSString * originMessage;

- (void)cancelButtonCallback;
- (void)submitButtonCallback;
- (void)wordsCountChanged;

@end


@implementation NTEditeView

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    self.originMessage = nil;
}

- (id)initWithTitle:(NSString *)title originMessage:(NSString *)message confirmButtonTitle:(NSString *)confirmButtonTitle delegate:(UIView<NTEditeViewDelegate> *)delegate maxWordsCount:(NSInteger)maxWordsCount minWordsCount:(NSInteger)minWordsCount
{
    self = [super initWithFrame:[NSTools rootViewController].view.bounds];
    if (self) {
        self.backgroundColor = _ShadeBack;
        self.delegate = delegate;
        self.originMessage = message;
        
        maxWords = maxWordsCount;
        minWords = minWordsCount;
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width/2.0f, self.bounds.size.height/4.0f)];
        }
        else{
            contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width/1.5f, self.bounds.size.height/2.0f)];
        }
        [[contentView layer]setCornerRadius:_CornerRadius];
        [contentView setBackgroundColor:[UIColor whiteColor]];
        [self addSubview:contentView];
        contentView.center = self.center;
        
        UILabel * titleLabel = [[UILabel  alloc] initWithFrame:CGRectMake(0, 5, contentView.frame.size.width, 25)];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.font = [UIFont boldSystemFontOfSize:20];
        titleLabel.textColor = _KeyWordsColor;
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.text = title;
        [contentView addSubview:titleLabel];
        
        contentTextView = [[UITextView alloc] initWithFrame:CGRectMake(15, 35, contentView.frame.size.width-30, contentView.frame.size.height - 100)];
        [[contentTextView layer] setCornerRadius:_CornerRadius];
        [contentTextView setBackgroundColor:_AlmostWhite];
        contentTextView.font = [UIFont systemFontOfSize:16];
        contentTextView.textColor = [UIColor darkGrayColor];
        contentTextView.delegate = self;
        contentTextView.text = message;
        [contentView addSubview:contentTextView];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(wordsCountChanged) name:UITextViewTextDidChangeNotification object:contentTextView];
        
        wordsLeftCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 35+contentTextView.frame.size.height, contentTextView.frame.size.width, 20)];
        wordsLeftCountLabel.backgroundColor = [UIColor clearColor];
        wordsLeftCountLabel.font = [UIFont systemFontOfSize:14];
        wordsLeftCountLabel.textColor = [UIColor darkGrayColor];
        wordsLeftCountLabel.textAlignment = NSTextAlignmentRight;
        [contentView addSubview:wordsLeftCountLabel];
        [wordsLeftCountLabel setText:[NSString stringWithFormat:_WordsLeftCount,minWords,maxWords,maxWords - self.originMessage.length]];
        
        UIButton * cancelButton = [[UIButton  alloc]initWithFrame:CGRectMake(0, 0, 120, 35)];
        [NSTools setButtonStyle:cancelButton cornerRadius:_CornerRadius backgroundColor:_AlmostWhite titleColor:[UIColor darkGrayColor] titleFont:nil];
        [cancelButton setTitle:_CancelButtonTitle forState:UIControlStateNormal];
        [cancelButton addTarget:self action:@selector(cancelButtonCallback) forControlEvents:UIControlEventTouchUpInside];
        [contentView addSubview:cancelButton];
        cancelButton.center = CGPointMake(contentView.bounds.size.width/2.0f-90, contentView.bounds.size.height-25);
        
        UIButton * submitButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 120, 35)];
        [NSTools setButtonStyle:submitButton cornerRadius:_CornerRadius backgroundColor:_AlmostWhite titleColor:_KeyWordsColor titleFont:_KeyWordsFont];
        [submitButton setTitleColor:_KeyWordsColor forState:UIControlStateNormal];
        [submitButton setTitle:confirmButtonTitle forState:UIControlStateNormal];
        [submitButton addTarget:self action:@selector(submitButtonCallback) forControlEvents:UIControlEventTouchUpInside];
        [contentView addSubview:submitButton];
        submitButton.center = CGPointMake(contentView.bounds.size.width/2.0f+90, contentView.bounds.size.height-25);
    }
    return self;
}

- (void)fadeIn
{
    self.alpha = 0;
    UIViewController * viewController = [NSTools currentViewControllerForView:self.delegate];
    [viewController.view addSubview:self];
    [contentView becomeFirstResponder];
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.alpha = 1;
    } completion:^(BOOL finished) {
    }];
}

- (void)cancelButtonCallback
{
    self.userInteractionEnabled = NO;
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)submitButtonCallback
{
    if ([contentTextView.text length] < minWords) {
        [[[UIAlertView alloc] initWithTitle:_AlertTitle message:[NSString stringWithFormat:_MinAlertMessage,minWords] delegate:nil cancelButtonTitle:_CancelButtonTitle otherButtonTitles:nil, nil] show];
        return;
    }
    if ([self.delegate respondsToSelector:@selector(editeView:didFinishedEditeWithMessage:)]) {
        [self.delegate editeView:self didFinishedEditeWithMessage:contentTextView.text];
    }
    [self cancelButtonCallback];
}

- (void)wordsCountChanged
{
    [wordsLeftCountLabel setText:[NSString stringWithFormat:_WordsLeftCount,minWords,maxWords,maxWords - contentTextView.text.length]];
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        contentView.center = CGPointMake(contentView.center.x, contentView.center.y - 140);
    } completion:^(BOOL finished) {
    }];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        contentView.center = CGPointMake(contentView.center.x, contentView.center.y + 140);
    } completion:^(BOOL finished) {
    }];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (![NSTools isStringWithContents:text]) {
        return YES;
    }
    else{
        if ([textView.text length] >= maxWords) {
            [[[UIAlertView alloc]initWithTitle:_AlertTitle message:_MaxAlertMessage delegate:nil cancelButtonTitle:_CancelButtonTitle otherButtonTitles:nil, nil] show];
            return NO;
        }
    }
    return YES;
}
@end
