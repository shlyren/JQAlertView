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
    JQAlertActionStyleDefault = 0,
    JQAlertActionStyleCancel = 1,
    JQAlertActionStyleDestructive = 2
};

@interface JQAlertAction : NSObject

@property (nullable, nonatomic, readonly) NSString *title;

@property (nonatomic, readonly, assign) JQAlertActionStyle style;

+ (instancetype)actionWithTitle:(nullable NSString *)title style:(JQAlertActionStyle)style handler:(void (^ __nullable)(JQAlertAction *action))handler;
@end


#pragma mark - JQAlertView
typedef NS_ENUM(NSInteger, JQAlertViewStyle) {
    JQAlertViewStyleActionSheet = 0, // modal
    JQAlertViewStyleAlert // show in screen center
};


@interface JQAlertView : UIView

@property (nullable, nonatomic, readonly) NSString *title;

@property (nullable, nonatomic, readonly) NSString *message;

@property (nonatomic, assign, readonly) JQAlertViewStyle preferredStyle;

@property (nonatomic, readonly, strong) NSArray<JQAlertAction *> *actions;

/**
 快速显示alertView

 @param title 标题
 @param message 显示信息
 @param preferredStyle JQAlertViewStyle
 @param titles 标题 (字符串数组)
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
                       handler:(void (^)(JQAlertView *alertView, NSInteger index))handler;



+ (instancetype)alertViewWithTitle:(nullable NSString *)title
                           message:(nullable NSString *)message
                    preferredStyle:(JQAlertViewStyle)preferredStyle;

- (void)addActions:(NSArray <JQAlertAction *>*)actions;

- (void)show;

NS_ASSUME_NONNULL_END
@end
