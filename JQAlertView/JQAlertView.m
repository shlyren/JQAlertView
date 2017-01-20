//
//  JQAlertController.m
//  https://github.com/shlyren/JQAlertView
//
//  Created by JiaQi on 2016/11/14.
//  Copyright © 2016年 任玉祥. All rights reserved.
//

#import "JQAlertView.h"

#pragma mark - UIColor Categoty
@implementation UIColor (JQImage)
- (UIImage *)image
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [self CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}
@end

#pragma mark - JQAlertAction
@interface JQAlertAction ()
@property (nonatomic, strong) NSString *actionTitle;
@property (nonatomic, assign) JQAlertActionStyle actionStyle;
@property (nonatomic, strong) void (^action)(JQAlertAction *action);
@end

@implementation JQAlertAction
+ (instancetype)actionWithTitle:(nullable NSString *)title style:(JQAlertActionStyle)style handler:(void (^ __nullable)(JQAlertAction *action))handler
{
    JQAlertAction *action = [JQAlertAction new];
    action.actionTitle = title;
    action.actionStyle = style;
    action.action = handler;
    return action;
}

- (NSString *)title
{
    return self.actionTitle;
}

- (JQAlertActionStyle)style
{
    return self.actionStyle;
}

@end

#pragma mark - const
CGFloat const kRowHeight = 48.0f;
CGFloat const kRowLineHeight = 1.0f;
CGFloat const kSeparatorHeight = 6.0f;
CGFloat const kTitleFontSize = 15.0f;
CGFloat const kMsgFontSize = 13.0f;
CGFloat const kBtnTitleFontSize = 18.0f;
NSTimeInterval const kShowAnimateDuration = 0.4f;
NSTimeInterval const kDismissAnimateDuration = 0.2f;

#pragma mark - JQAlertView
@interface JQAlertView()
@property (nonatomic, assign) JQAlertViewStyle style;
@property (nonatomic, strong) NSMutableArray <JQAlertAction *> *alertActions;
/** 背景图片 */
@property (weak, nonatomic) UIView *backgroundView;
/** 弹出视图 */
@property (weak, nonatomic) UIView *actionSheetView;
/** 回调 */
@property (nonatomic, copy) void (^alertViewHandler)(JQAlertView *alertView, NSInteger index);

@property (nonatomic, assign) NSInteger count;

@end

@implementation JQAlertView

#define actionSheetViewWidth ([UIScreen mainScreen].bounds.size.width * 0.7)

#pragma mark - lazy load
- (NSMutableArray<JQAlertAction *> *)alertActions
{
    return _alertActions ?: (_alertActions = [NSMutableArray array]);
}
#pragma mark - getter
- (JQAlertViewStyle)preferredStyle
{
    return _style;
}

- (NSArray<JQAlertAction *> *)actions
{
    return self.alertActions;
}

#pragma mark - super init methods
- (instancetype)initWithFrame:(CGRect)frame
{
    return [self initWithTitle:nil message:nil preferredStyle:JQAlertViewStyleActionSheet];
}
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    return [self initWithTitle:nil message:nil preferredStyle:JQAlertViewStyleActionSheet];
}

#pragma mark - public methods
+ (instancetype)alertViewWithTitle:(nullable NSString *)title
                           message:(nullable NSString *)message
                    preferredStyle:(JQAlertViewStyle)preferredStyle
{
    return [[self alloc] initWithTitle:title message:message preferredStyle:preferredStyle];
}

+ (void)showAlertViewWithTitle:(nullable NSString *)title
                       message:(nullable NSString *)message
                preferredStyle:(JQAlertViewStyle)preferredStyle
                        titles:(nullable NSArray <NSString *>*)titles
              destructiveTitle:(nullable NSString *)destructiveTitle
                   cancelTitle:(nullable NSString *)cancelTitle
                       handler:(void (^ __nullable)(JQAlertView *alertView, NSInteger index))handler;
{
    JQAlertView *alertView = [self alertViewWithTitle:title message:message preferredStyle:preferredStyle];

    for (NSString *otherTitle in titles)
        [alertView.alertActions addObject:[JQAlertAction actionWithTitle:otherTitle
                                                                   style:JQAlertActionStyleDefault
                                                                 handler:nil]];
    
    if (destructiveTitle && destructiveTitle.length)
        [alertView.alertActions addObject:[JQAlertAction actionWithTitle:destructiveTitle
                                                                   style:JQAlertActionStyleDestructive
                                                                 handler:nil]];
    
    if (cancelTitle && cancelTitle.length)
        [alertView.alertActions addObject:[JQAlertAction actionWithTitle:cancelTitle
                                                                   style:JQAlertActionStyleCancel
                                                                 handler:nil]];
    
    alertView.alertViewHandler = handler;
    
    [alertView show];
}

+ (void)showActionSheetWithTitle:(nullable NSString *)title
                         message:(nullable NSString *)message
                          titles:(nullable NSArray <NSString *>*)titles
                destructiveTitle:(nullable NSString *)destructiveTitle
                     cancelTitle:(nullable NSString *)cancelTitle
                         handler:(void (^ __nullable)(JQAlertView *alertView, NSInteger index))handler
{
    [self showAlertViewWithTitle:title
                         message:message
                  preferredStyle:JQAlertViewStyleActionSheet
                          titles:titles
                destructiveTitle:destructiveTitle
                     cancelTitle:cancelTitle
                         handler:handler];
}

#pragma mark - main method
- (instancetype)initWithTitle:(nullable NSString *)title
                      message:(nullable NSString *)message
               preferredStyle:(JQAlertViewStyle)preferredStyle
{
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    if (self)
    {
        _title = title;
        _message = message;
        self.style = preferredStyle;
        
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        UIView *backgroundView = [[UIView alloc] initWithFrame:self.bounds];
        backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        backgroundView.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.4f];
        backgroundView.alpha = 0.0f;
        [self addSubview:_backgroundView = backgroundView];
        
        UIView *actionSheetView = [[UIView alloc] initWithFrame:self.bounds];
        if (preferredStyle == JQAlertViewStyleActionSheet)
            actionSheetView.frame = CGRectMake(0.0f, self.frame.size.height, self.frame.size.width, 0.0f);
        actionSheetView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
        actionSheetView.backgroundColor = [UIColor colorWithWhite:0.933f alpha:1.0f];
        [self addSubview:_actionSheetView = actionSheetView];

    }
    
    return self;
}

- (void)addActions:(NSArray <JQAlertAction *>*)actions
{
    JQAlertAction *cancelAction = nil;
    for (JQAlertAction *action in actions)
    {
        if (action.style == JQAlertActionStyleCancel)
        {
            cancelAction = action;
            self.count++;
        }else {
            [self.alertActions addObject:action];
        }
        NSAssert(self.count < 2, @"JQAlertView can only have one action with a style of JQAlertActionStyleCancel");
    }
    
    if (cancelAction) [self.alertActions addObject:cancelAction];

}

- (void)show
{
    [self setupSubView];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        NSEnumerator *frontToBackWindows = [UIApplication.sharedApplication.windows reverseObjectEnumerator];
        for (UIWindow *window in frontToBackWindows)
        {
            BOOL windowOnMainScreen = window.screen == UIScreen.mainScreen;
            BOOL windowIsVisible = !window.hidden && window.alpha > 0.0f;
            BOOL windowLevelNormal = window.windowLevel == UIWindowLevelNormal;
            
            if(windowOnMainScreen && windowIsVisible && windowLevelNormal)
            {
                [window addSubview:self];
                break;
            }
        }
        
        [UIView animateWithDuration:kShowAnimateDuration
                              delay:0.0f
             usingSpringWithDamping:0.7f
              initialSpringVelocity:0.7f
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
             self.backgroundView.alpha = 1.0f;
             if (self.style == JQAlertViewStyleActionSheet)
             {
                 self.actionSheetView.frame = CGRectMake(0.0f, self.frame.size.height-self.actionSheetView.frame.size.height, self.frame.size.width, self.actionSheetView.frame.size.height);
             }else{
                 self.actionSheetView.alpha = 1.0f;
             }
                             
        } completion:nil];
    });
    
}

/** 初始化子控件 */
- (void)setupSubView
{
    CGFloat actionSheetHeight = 0.0f;
    
    // title
    if (self.title && self.title.length)
    {
        actionSheetHeight += kRowLineHeight;
        
        CGFloat titleHeight = ceil([self.title boundingRectWithSize:CGSizeMake(actionSheetViewWidth, MAXFLOAT)
                                                            options:NSStringDrawingUsesLineFragmentOrigin
                                                         attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:kTitleFontSize]}
                                                            context:nil].size.height) + 10.0f;
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, actionSheetHeight, self.frame.size.width, titleHeight)];
        titleLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        titleLabel.text = self.title;
        titleLabel.backgroundColor = [UIColor whiteColor];
        titleLabel.textColor = [UIColor colorWithWhite:0.392f alpha:1.0f];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.font = [UIFont systemFontOfSize:kTitleFontSize];
        titleLabel.numberOfLines = 0.0f;
        [_actionSheetView addSubview:titleLabel];
        
        actionSheetHeight += titleHeight;
    }
    
    // message
    if (self.message && self.message.length)
    {
        
        CGFloat msgHeight = ceil([self.message boundingRectWithSize:CGSizeMake(actionSheetViewWidth, MAXFLOAT)
                                                            options:NSStringDrawingUsesLineFragmentOrigin
                                                         attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:kMsgFontSize]}
                                                            context:nil].size.height) + 15.0f;
        
        UILabel *msgLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, actionSheetHeight -= 5.0f, self.frame.size.width, msgHeight)];
        msgLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        msgLabel.text = self.message;
        msgLabel.backgroundColor = [UIColor whiteColor];
        msgLabel.textColor = [UIColor colorWithWhite:0.588f alpha:1.0f];
        msgLabel.textAlignment = NSTextAlignmentCenter;
        msgLabel.font = [UIFont systemFontOfSize:kMsgFontSize];
        msgLabel.numberOfLines = 0.0f;
        [_actionSheetView addSubview:msgLabel];
        
        actionSheetHeight += msgHeight;
    }
    
    // 记录当按钮为两个的时候 alert模式下 文字时候正常显示
    CGFloat btnWidth = actionSheetViewWidth * 0.5f - kRowLineHeight;
    BOOL isInOneLine = true;
    if (self.alertActions.count == 2 && self.style == JQAlertViewStyleAlert)
    {
        for (JQAlertAction *action in self.alertActions)
        {
            CGFloat titleWidth = ceil([action.title boundingRectWithSize:CGSizeMake(MAXFLOAT, actionSheetHeight)
                                                                 options:NSStringDrawingUsesLineFragmentOrigin
                                                              attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:kBtnTitleFontSize]}
                                                                 context:nil].size.width);
            if (titleWidth > btnWidth)
            {
                
                isInOneLine = false;
                break;
            }
        }
    }
    
    
//    BOOL alertOneLine = self.alertActions.count == 2 && self.style == JQAlertViewStyleAlert && isInOneLine;
//    
//    actionSheetHeight += alertOneLine ? kRowLineHeight : 0;
//    for (NSInteger i = 0; i < self.alertActions.count; i++)
//    {
//        actionSheetHeight += alertOneLine ? 0 : self.alertActions[i].style == JQAlertActionStyleCancel ? kSeparatorHeight : kRowLineHeight;
//        
//        CGRect frame = alertOneLine ? CGRectMake(i * (btnWidth + kRowLineHeight), actionSheetHeight, btnWidth, kRowHeight) :
//                                      CGRectMake(0, actionSheetHeight, _actionSheetView.frame.size.width, kRowHeight);
//        [self setupBtnWithAction:self.alertActions[i]
//                           frame:frame
//                    resizingMask:alertOneLine ? UIViewAutoresizingNone : UIViewAutoresizingFlexibleWidth];
//        if (alertOneLine) continue;
//        
//        actionSheetHeight += kRowHeight;
//    }
//    actionSheetHeight += alertOneLine ? kRowHeight : 0;
    
    // button
    if (self.alertActions.count == 2 && self.style == JQAlertViewStyleAlert && isInOneLine)
    {
        
        actionSheetHeight += kRowLineHeight;
        for (NSInteger i = 0; i < self.alertActions.count; i++)
            [self setupBtnWithFrame:CGRectMake(i * (btnWidth + kRowLineHeight), actionSheetHeight, btnWidth, kRowHeight)
                               index:i
                        resizingMask:UIViewAutoresizingNone];
        actionSheetHeight += kRowHeight;
        
    }else{
        
        for (NSInteger i = 0; i < self.alertActions.count; i++)
        {
            JQAlertAction *action = self.alertActions[i];
            
            actionSheetHeight += action.style == JQAlertActionStyleCancel ? kSeparatorHeight : kRowLineHeight;
    
            [self setupBtnWithFrame:CGRectMake(0.0f, actionSheetHeight, _actionSheetView.frame.size.width, kRowHeight)
                               index:i
                        resizingMask:UIViewAutoresizingFlexibleWidth];
            actionSheetHeight += kRowHeight;
        }
    }
    
    // 设置frame
    if (self.style == JQAlertViewStyleActionSheet)
    {
        _actionSheetView.frame = CGRectMake(0.0f, self.frame.size.height, self.frame.size.width, actionSheetHeight);
        
    } else{
        
        CGFloat x = ([UIScreen mainScreen].bounds.size.width - actionSheetViewWidth) * 0.5f;
        CGFloat y = ([UIScreen mainScreen].bounds.size.height - actionSheetHeight) * 0.5f;
        _actionSheetView.frame = CGRectMake(x, y, actionSheetViewWidth, actionSheetHeight);
        _actionSheetView.alpha = 0.0f;
    }
}

/** 创建按钮 */
- (void)setupBtnWithFrame:(CGRect)frame index:(NSInteger)index resizingMask:(UIViewAutoresizing)resizingMask
{
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    button.autoresizingMask = resizingMask;
    button.tag = index;
    button.titleLabel.font = [UIFont systemFontOfSize:kBtnTitleFontSize];
    [button setTitle:self.actions[index].title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithWhite:0.251f alpha:1.0f] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIColor whiteColor].image forState:UIControlStateNormal];
    [button setBackgroundImage:[UIColor colorWithWhite:0.949f alpha:1.0f].image forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];

    if (self.actions[index].style == JQAlertActionStyleDestructive)
        [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    
    [_actionSheetView addSubview:button];
}

#pragma mark - 按钮点击
- (void)buttonClicked:(UIButton *)button
{
    [UIView animateWithDuration:kDismissAnimateDuration
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{

         self.backgroundView.alpha = 0.0f;
         if (self.style == JQAlertViewStyleActionSheet)
         {
             self.actionSheetView.frame = CGRectMake(0.0f, self.frame.size.height, self.frame.size.width, self.actionSheetView.frame.size.height);
         }else{
             self.actionSheetView.alpha = 0.0f;
         }
                         
                     } completion:^(BOOL finished) {

         if (button)
         {
             JQAlertAction *action = self.alertActions[button.tag];
             if (action.action)
                 action.action(action);
             if (self.alertViewHandler)
                 self.alertViewHandler(self, button.tag);
         }
         
         [self removeFromSuperview];
     }];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint point = [[touches anyObject] locationInView:self.backgroundView];
    if (CGRectContainsPoint(self.actionSheetView.frame, point)) return;
    [self buttonClicked:nil];
}

- (void)dealloc
{
#ifdef DEBUG
    NSLog(@"JQAlertView dealloc");
#endif
}
@end

#pragma mark - UIAlertController扩展
@implementation UIAlertController (JQAlert)

+ (void)showAlertWithTitle:(nullable NSString *)title
                   message:(nullable NSString *)message
               cancelTitle:(nullable NSString *)cancelTitle // index == 0
          destructiveTitle:(nullable NSString *)destructiveTitle // index == -1
               otherTitles:(nullable NSArray <NSString *>*)titles // index == 1...titles.cout
                   handler:(void (^__nullable)(NSInteger index))handler;
{
    [self showWithTitle:title message:message style:UIAlertControllerStyleAlert cancelTitle:cancelTitle destructiveTitle:destructiveTitle otherTitles:titles handler:handler];
}


+ (void)showDefaultAlertWithTitle:(nullable NSString *)title
                          message:(nullable NSString *)message
                      cancelTitle:(nullable NSString *)cancelTitle// index == 0
                     defaultTitle:(nullable NSString *)defaultTitle // index == 1
                          handler:(void (^__nullable)(NSInteger index))handler
{
    
    [self showAlertWithTitle:title message:message cancelTitle:cancelTitle destructiveTitle:nil otherTitles:@[defaultTitle] handler:handler];
    
}

+ (void)showDestructiveAlertWithTitle:(nullable NSString *)title
                              message:(nullable NSString *)message
                          cancelTitle:(nullable NSString *)cancelTitle// index == 0
                     destructiveTitle:(nullable NSString *)destructiveTitle // index == -1
                              handler:(void (^__nullable)(NSInteger index))handler
{
    [self showAlertWithTitle:title message:message cancelTitle:cancelTitle destructiveTitle:destructiveTitle otherTitles:nil handler:handler];
}


+ (void)showAlertWithTitle:(nullable NSString *)title message:(nullable NSString *)message cancelTitle:(nullable NSString *)cancelTitle handler:(void (^__nullable)(NSInteger index))handler;
{
    [self showAlertWithTitle:title message:message cancelTitle:cancelTitle destructiveTitle:nil otherTitles:nil handler:handler];
}

+ (void)showSheetWithTitle:(nullable NSString *)title
                   message:(nullable NSString *)message
               cancelTitle:(nullable NSString *)cancelTitle // index == 0
          destructiveTitle:(nullable NSString *)destructiveTitle // index == -1
               otherTitles:(nullable NSArray <NSString *>*)titles // index == 1...titles.cout
                   handler:(void (^__nullable)(NSInteger index))handler
{
    [self showWithTitle:title message:message style:UIAlertControllerStyleActionSheet cancelTitle:cancelTitle destructiveTitle:destructiveTitle otherTitles:titles handler:handler];
}



/**
 主要方法
 */
+ (void)showWithTitle:(nullable NSString *)title
              message:(nullable NSString *)message
                style:(UIAlertControllerStyle)style
          cancelTitle:(nullable NSString *)cancelTitle // index == 0
     destructiveTitle:(nullable NSString *)destructiveTitle // index == -1
          otherTitles:(nullable NSArray <NSString *>*)titles // index == 1...titles.cout
              handler:(void (^__nullable)(NSInteger index))handler;
{
    
    UIAlertController *alertC = [self alertControllerWithTitle:title message:message preferredStyle:style];
    
    if (cancelTitle && cancelTitle.length) {
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:cancelTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            if (handler) handler(0);
        }];
        [alertC addAction:cancel];
    }
    
    if (destructiveTitle && destructiveTitle.length) {
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:destructiveTitle style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            
            if (handler) handler(-1);
        }];
        [alertC addAction:cancel];
    }
    
    
    for (NSInteger i = 0; i < titles.count; i++) {
        UIAlertAction *action = [UIAlertAction actionWithTitle:titles[i] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            if (handler) handler(i+1);
        }];
        [alertC addAction:action];
    }
    
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertC animated:true completion:nil];
    
}

@end

