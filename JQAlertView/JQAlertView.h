//
//  JQAlertView.h
//  JQAlertControllerDemo
//
//  Created by JiaQi on 2016/11/14.
//  Copyright © 2016年 任玉祥. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#pragma mark - JQAlertAction
typedef NS_ENUM(NSInteger, JQAlertActionStyle) {
    JQAlertActionStyleDefault = 0, // 默认
    JQAlertActionStyleCancel,   // 取消
    JQAlertActionStyleDestructive // 毁灭性
};

@interface JQAlertAction : NSObject

/** 标题 */
@property (nullable, nonatomic, readonly) NSString *title;

/** 样式 */
@property (nonatomic, assign, readonly) JQAlertActionStyle style;


/**
 快速创建一个动作

 @param title 标题
 @param style 样式
 @param handler 回调
 @return 对象
 */
+ (instancetype)actionWithTitle:(nullable NSString *)title style:(JQAlertActionStyle)style handler:(void (^ __nullable)(JQAlertAction *action))handler;
@end


#pragma mark - JQAlertView
typedef NS_ENUM(NSInteger, JQAlertViewStyle) {
    JQAlertViewStyleActionSheet = 0, // modal
    JQAlertViewStyleAlert // show in window center
};


@interface JQAlertView : UIView

/** 标题 */
@property (nullable, nonatomic, readonly) NSString *title;

/** 子标题 */
@property (nullable, nonatomic, readonly) NSString *message;

/** 展示方式 */
@property (nonatomic, assign, readonly) JQAlertViewStyle preferredStyle;

/** 动作组 */
@property (nonatomic, readonly, strong) NSArray<JQAlertAction *> *actions;

/**
 快速显示alertView

 @param title title
 @param message subTitle
 @param preferredStyle JQAlertViewStyle
 @param titles action title, is string
 @param destructiveTitle destructive action, such as delete
 @param cancelTitle cacel action
 @param handler 回调 index说明:视图显示后,从上往下的index依次为0,1,2,3...; 即:`otherTitles`数组的index, destructiveTitle, cancelTitle
 */
+ (void)showAlertViewWithTitle:(nullable NSString *)title
                       message:(nullable NSString *)message
                preferredStyle:(JQAlertViewStyle)preferredStyle
                        titles:(nullable NSArray <NSString *>*)titles // index: [0 ... titles.count-1]
              destructiveTitle:(nullable NSString *)destructiveTitle // index == titles.count
                   cancelTitle:(nullable NSString *)cancelTitle // if destructiveTitle != nil or @"" index is `titles.count+1`, else index is `titles.count`
                       handler:(void (^ __nullable)(JQAlertView *alertView, NSInteger index))handler;


/**
 创建一个弹框

 @param title 标题
 @param message 子标题
 @param preferredStyle 样式
 @return 对象
 */
+ (instancetype)alertViewWithTitle:(nullable NSString *)title
                           message:(nullable NSString *)message
                    preferredStyle:(JQAlertViewStyle)preferredStyle;

- (void)addActions:(NSArray <JQAlertAction *>*)actions;

- (void)show;

NS_ASSUME_NONNULL_END
@end
