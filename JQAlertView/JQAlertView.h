//
//  JQAlertView.h
//  JQAlertControllerDemo
//
//  Created by JiaQi on 2016/11/14.
//  Copyright © 2016年 任玉祥. All rights reserved.
//

#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN

/**
 按钮的类型
 
 - JQAlertActionStyleDefault: 默认
 - JQAlertActionStyleCancel: 取消
 - JQAlertActionStyleDestructive: 毁灭性操作
 */
typedef NS_ENUM(NSInteger, JQAlertActionStyle) {
    JQAlertActionStyleDefault = 0,
    JQAlertActionStyleCancel = 1,
    JQAlertActionStyleDestructive = 2
};

#pragma mark - JQAlertAction
@interface JQAlertAction : NSObject

@property (nullable, nonatomic, readonly) NSString *title;

@property (nonatomic, readonly, assign) JQAlertActionStyle style;

+ (instancetype)actionWithTitle:(nullable NSString *)title style:(JQAlertActionStyle)style handler:(void (^ __nullable)(JQAlertAction *action))handler;
@end



/**
 展示的方式

 - JQAlertControllerStyleActionSheet: 从中间弹出
 - JQAlertControllerStyleAlert: 从底部弹出
 */
typedef NS_ENUM(NSInteger, JQAlertViewStyle) {
    JQAlertControllerStyleActionSheet = 0,
//    JQAlertControllerStyleAlert
};


#pragma mark - JQAlertView
@interface JQAlertView : UIView

@property (nullable, nonatomic, copy) NSString *title;

@property (nullable, nonatomic, copy) NSString *message;

@property (nonatomic, assign, readonly) JQAlertViewStyle preferredStyle;

@property (nonatomic, readonly, strong) NSArray<JQAlertAction *> *actions;


+ (instancetype)alertViewWithTitle:(nullable NSString *)title message:(nullable NSString *)message preferredStyle:(JQAlertViewStyle)preferredStyle;

- (void)addActions:(NSArray <JQAlertAction *>*)actions;
- (void)show;

NS_ASSUME_NONNULL_END
@end
