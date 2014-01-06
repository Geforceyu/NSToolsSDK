/**
 *
 * NSTools.m
 *
 * Create By limao@rimi.com 2014-1-3.
 * Copyright (c) 2014 Nemo. All rights reserved.
 *
 */


/* ARC Warning */
#if ! __has_feature(objc_arc)
#warning This file must be compiled with ARC. Use -fobjc-arc flag (or convert project to ARC).
#endif

#import "NSTools.h"

static NSTools * singleton = nil;

/* NSTools Extension */

@interface NSTools ()<PostRequestDelegate>

@property (nonatomic, strong) NSMutableArray  * activingPostRequests;

@end

/* NSTools Implementation */

@implementation NSTools

- (void)dealloc
{
    self.fileManager = nil;
    
    self.dateFormatter_mmss     = nil;
    self.dateFormatter_TimeOnly = nil;
    self.dateFormatter_DateOnly = nil;
    self.dateFormatter_Full     = nil;
    self.originTime             = nil;
}

+ (NSTools *)sharedTools
{
    @synchronized (self)
    {
        if (singleton == nil) {
            singleton = [[NSTools alloc] init];
            singleton.originTime = [singleton.dateFormatter_TimeOnly dateFromString:_OriginTime];
        }
    }
    return singleton;
}

- (id)init
{
    self = [super init];
    if (self) {
        self.fileManager = [[NSFileManager alloc] init];
        
        self.dateFormatter_mmss = [[NSDateFormatter alloc] init];
        self.dateFormatter_mmss.dateFormat = _mmssFormat;
        
        self.dateFormatter_TimeOnly = [[NSDateFormatter alloc] init];
        self.dateFormatter_TimeOnly.dateFormat = _TimeOnlyFormat;
        
        self.dateFormatter_DateOnly = [[NSDateFormatter alloc] init];
        self.dateFormatter_DateOnly.dateFormat = _DateOnlyFormat;
        
        self.dateFormatter_Full = [[NSDateFormatter alloc] init];
        self.dateFormatter_Full.dateFormat = _FullDateFormat;
        
        self.activingPostRequests = [[NSMutableArray alloc] init];
    }
    return self;
}

+ (float)sizeOfDirectoryAtPath:(NSString *)path
{
    float size = 0;
    NSArray * subFiles = [_NSTools.fileManager contentsOfDirectoryAtPath:path error:nil];
    for(int i = 0; i < [subFiles count]; i++)
    {
        NSString * filePath = [path stringByAppendingPathComponent:[subFiles objectAtIndex:i]];
        BOOL isDirectory;
        if ( !([_NSTools.fileManager fileExistsAtPath: filePath isDirectory:&isDirectory] && isDirectory) )
        {
            NSDictionary * fileAttributeDic=[_NSTools.fileManager attributesOfItemAtPath: filePath error:nil];
            size += fileAttributeDic.fileSize/ 1024.0/1024.0;
        }
        else
        {
            size += [NSTools sizeOfDirectoryAtPath: filePath];
        }
    }
    return size;
}

+ (BOOL)saveFile:(id)file toPath:(NSString *)path overWriteIfNecessary:(BOOL)necessary
{
    if (!file) {
        NSLog(@"Empty Instance!");
        return NO;
    }
    if (![file respondsToSelector:@selector(writeToFile:atomically:)]) {
        NSLog(@"Unsavable Instance!");
        return NO;
    }
    if ([_NSTools.fileManager fileExistsAtPath:path]) {
        if (necessary) {
            NSError * error = nil;
            [_NSTools.fileManager removeItemAtPath:path error:&error];
            if (error) {
                NSLog(@"Remove Origin File Failed! Error:%@",error.localizedDescription);
                return NO;
            }
        }
        else{
            NSLog(@"File Existed At Path!");
            return NO;
        }
    }
    NSError * error = nil;
    if ([file writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:&error]) {
        return YES;
    }
    NSLog(@"File Write To Path Failed! Error:%@",error.localizedDescription);
    return NO;
}

+ (BOOL)isStringWithContents:(id)instance
{
    return (instance && [instance respondsToSelector:@selector(length)] && [instance length]);
}

+ (BOOL)isDictionaryWithContents:(id)instance
{
    if ( ([instance isKindOfClass:[NSDictionary class]]||[instance isKindOfClass:[NSMutableDictionary class]]) && [[instance allKeys] count] > 0) {
        return YES;
    }
    return NO;
}

+ (BOOL)checkDirectoryExistedAtIndexPath:(NSString *)path creatDirectoryIfNecessary:(BOOL)necesarray
{
    BOOL isDirectory;
    if ([_NSTools.fileManager fileExistsAtPath:path isDirectory:&isDirectory]) {
        if (isDirectory) {
            return YES;
        }
        else{
            NSLog(@"This Path Is Not A Directory!");
            return NO;
        }
    }
    if (!necesarray) {
        return NO;
    }
    NSError * error = nil;
    if ([_NSTools.fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error]) {
        return YES;
    }
    else{
        NSLog(@"Create Directory Failed! Error:%@",error.localizedDescription);
        return NO;
    }
}

+ (UIViewController *)currentViewControllerForView:(UIView *)view
{
    if ([[view nextResponder]isKindOfClass:[UIViewController class]]) {
        return (UIViewController *)[view nextResponder];
    }
    else{
        for (UIView * superview = view.superview; superview; superview = superview.superview) {
            if ([[superview nextResponder] isKindOfClass:[UIViewController class]]) {
                return (UIViewController *)[superview nextResponder];
            }
        }
    }
    return nil;
}

+ (UIViewController *)rootViewController
{
    return [UIApplication sharedApplication].keyWindow.rootViewController;
}

+ (void)setButtonStyle:(UIButton *)button cornerRadius:(float)radius backgroundColor:(UIColor *)backgroundColor titleColor:(UIColor *)titleColor titleFont:(UIFont *)titleFont
{
    [[button layer] setCornerRadius:radius];
    button.backgroundColor = backgroundColor;
    [button setTitleColor:titleColor forState:UIControlStateNormal];
    if (titleFont) {
        button.titleLabel.font = titleFont;
    }
}

+ (void)showEditeViewWithTitle:(NSString *)title originMessage:(NSString *)message confirmButtonTitle:(NSString *)confirmButtonTitle delegate:(UIView<NTEditeViewDelegate> *)delegate maxWordsCount:(NSInteger)maxWordsCount minWordsCount:(NSInteger)minWordsCount
{
    NTEditeView * editeView = [[NTEditeView alloc]initWithTitle:title originMessage:message confirmButtonTitle:confirmButtonTitle delegate:delegate maxWordsCount:maxWordsCount minWordsCount:minWordsCount];
    [editeView fadeIn];
}


+ (void)asyncPostWithURLString:(NSString *)URLString paramsDic:(NSDictionary *)paramsDic postName:(NSString *)name withCompletion:(void (^)(id, PostEndState))completion{
    PostRequest * request = [[PostRequest alloc]initWithURL:[NSURL URLWithString:URLString] paramsDic:paramsDic timeoutInterval:_PostTimeout completion:completion];
    if (name) {
        [request setName:name];
    }
    [_NSTools.activingPostRequests addObject:request];
    [request setDelegate:_NSTools];
    [request startAsync];
}

+ (BOOL)cancelPostWithPostName:(NSString *)name
{
    if (name) {
        PostRequest * targetRequest = nil;
        for (PostRequest * request in _NSTools.activingPostRequests) {
            if ([request.name isEqualToString:name]) {
                targetRequest = request;
                break;
            }
        }
        if (targetRequest) {
            [targetRequest cancel];
            return YES;
        }
    }
    NSLog(@"No Activing PostRequest With Such Name!");
    return NO;
}

- (void)PostRequestEnded:(PostRequest *)request
{
    [_NSTools.activingPostRequests removeObject:request];
}

+ (NSData *)dataWithDictionary:(NSDictionary *)dictionary
{
    if (!dictionary) {
        NSLog(@"Empty dictionary!");
        return nil;
    }
    NSMutableData * tempData = [NSMutableData data];
    NSKeyedArchiver * archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:tempData];
    [archiver encodeObject:dictionary forKey:@"Some Key Value"];
    [archiver finishEncoding];
    return (NSData *)tempData;
}

+ (void)showAlertWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle confirmButtonTitle:(NSString *)confirmButtonTitle callBackAction:(void(^)(NSInteger buttonIndex))callbackAction keepPointer:(NTAlertView **)alertView delegate:(id<NTAlertViewDelegate>)delegate
{
    [[[NTAlertView alloc]initWithTitle:title message:message cancelButtonTitle:cancelButtonTitle confirmButtonTitle:confirmButtonTitle callBackAction:callbackAction keepPointer:alertView delegate:delegate]show];
}

+ (void)test
{
    
}
@end
