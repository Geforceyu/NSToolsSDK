/**
 *
 * NSTools.h
 *
 * Create By limao@rimi.com 2014-1-3.
 * Copyright (c) 2014 Nemo. All rights reserved.
 *
 */

/* ARC Warning */
#if ! __has_feature(objc_arc)
#warning This SDK must be compiled with ARC. Use -fobjc-arc flag (or convert project to ARC).
#endif

/* Better Performance On iOS_7 Or Latter */
/* DateFormat: yyyy-MM-dd HH:mm:ss */

/* Lazy Define */
#define _NSTools [NSTools sharedTools]

/* NTools Instance Define */
#define _FullDateFormat @"yyyy-MM-dd HH:mm:ss"
#define _DateOnlyFormat @"yyyy-MM-dd"
#define _TimeOnlyFormat @"HH:mm:ss"
#define _mmssFormat     @"mm:ss"
#define _OriginTime     @"00:00:00"

/* NTEditeView Instance Define */
#define _CornerRadius       10.0f
#define _KeyWordsFont       [UIFont boldSystemFontOfSize:20]
#define _CancelButtonTitle  @"Cancel"
#define _AlertTitle         @"Tips"
#define _AlertButtonTitle   @"OK"
#define _MaxAlertMessage    @"Up to max words input limited!"
#define _MinAlertMessage    @"Please input at least %d word(s)!"
#define _WordsLeftCount     @"%d to %d words, %u word(s) left"

/* PostRequest Instance Define */
#define _PostTimeout    5.0f

/* Colors Define */
#define _KeyWordsColor  [UIColor colorWithRed:0 green:0.6 blue:1 alpha:1]
#define _ShadeBack      [UIColor colorWithWhite:0 alpha:0.3]
#define _AlmostWhite    [UIColor colorWithWhite:0.98 alpha:1]

#import <Foundation/Foundation.h>

#import "NTEditeView.h"
#import "NTAlertView.h"

#import "PostRequest.h"


@interface NSTools : NSObject

/* Shared Instances */
@property (nonatomic, strong) NSFileManager   * fileManager;
@property (nonatomic, strong) NSDateFormatter * dateFormatter_mmss;
@property (nonatomic, strong) NSDateFormatter * dateFormatter_TimeOnly;
@property (nonatomic, strong) NSDateFormatter * dateFormatter_DateOnly;
@property (nonatomic, strong) NSDateFormatter * dateFormatter_Full;
@property (nonatomic, strong) NSDate          * originTime;
@property (nonatomic, assign) BOOL              prefersStatusBarHidden;

+ (NSTools *)sharedTools;

/* 计算目标路径'path'所包含的所有文件大小（单位:KB） */
+ (float)sizeOfDirectoryAtPath:(NSString *)path;

/* 将指定文件'file'保存在指定路径'path'，当'necessary'为'YES'时将复写源文件（如果有必要） */
+ (BOOL)saveFile:(id)file toPath:(NSString *)path overWriteIfNecessary:(BOOL)necessary;

/* 判断目标对象'instance'是否是有内容的'NSString'或'NSMutableString'对象 */
+ (BOOL)isStringWithContents:(id)instance;

/* 判断目标对象'instance'是否是有内容的'NSDictionary'或'NSMutableDictionary'对象 */
+ (BOOL)isDictionaryWithContents:(id)instance;

/* 检查路径为'path'的目标文件夹是否存在，当'necessary'为'NO'时 目标存在返回'真'，不存在返回'假'；当'necessary'为'YES'时，目标存在返回'真'，目标不存在创建成功返回'真'，其余情况返回'假' */
+ (BOOL)checkDirectoryExistedAtIndexPath:(NSString *)path creatDirectoryIfNecessary:(BOOL)necesarray;

/* 将字典'dictionary'对象转换为'NSDate'类型 */
+ (NSData *)dataWithDictionary:(NSDictionary *)dictionary;

/* 返回当前'view'对象的'UIViewController'对象 */
+ (UIViewController *)currentViewControllerForView:(UIView *)view;

/* 返回当前应用程序根视图控制器 */
+ (UIViewController *)rootViewController;

/* 快捷设置'button'对象的样式 */
+ (void)setButtonStyle:(UIButton *)button cornerRadius:(float)radius backgroundColor:(UIColor *)backgroundColor titleColor:(UIColor *)titleColor titleFont:(UIFont *)titleFont;

/* 生成一个编辑框对象，可指定标题'title'，内容'message'，确定按钮名称'confirmButtonTitle'，代理'delegate'及最大输入字数'maxWordsCount'和最小输入字数'minWordsCount' */
+ (void)showEditeViewWithTitle:(NSString *)title originMessage:(NSString *)message confirmButtonTitle:(NSString *)confirmButtonTitle delegate:(id<NTEditeViewDelegate>)delegate maxWordsCount:(NSInteger)maxWordsCount minWordsCount:(NSInteger)minWordsCount;

/* 使用指定的参数进行异步Post请求，请求结果内容及请求结束状态会返回在'completion'Block中 */
+ (void)asyncPostWithURLString:(NSString *)URLString paramsDic:(NSDictionary *)paramsDic postName:(NSString *)name withCompletion:(void (^)(id content, PostEndState state))completion;

/* 结束名称为'name'的异步Post请求 */
+ (BOOL)cancelPostWithPostName:(NSString *)name;

/* 生成一个带有回调Block的AlertView，可选择性保存该AlertView的指针 */
+ (void)showAlertWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle confirmButtonTitle:(NSString *)confirmButtonTitle callBackAction:(void(^)(NSInteger buttonIndex))callbackAction keepPointer:(NTAlertView **)alertView delegate:(id<NTAlertViewDelegate>)delegate;

+ (void)test;
@end
