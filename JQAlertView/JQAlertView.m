//
//  JQAlertController.m
//  JQAlertControllerDemo
//
//  Created by JiaQi on 2016/11/14.
//  Copyright © 2016年 任玉祥. All rights reserved.
//

#import "JQAlertView.h"

#pragma UIColor Categoty
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

@end

@implementation JQAlertView

#define actionSheetViewWidth ([UIScreen mainScreen].bounds.size.width * 0.7)
#define JQColor(r, g, b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1.0f]

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
        backgroundView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4f];
        backgroundView.alpha = 0;
        [self addSubview:_backgroundView = backgroundView];
        
        UIView *actionSheetView = [[UIView alloc] initWithFrame:self.bounds];
        if (preferredStyle == JQAlertViewStyleActionSheet)
            actionSheetView.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, 0);
        actionSheetView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
        actionSheetView.backgroundColor = JQColor(238, 238, 238);
        [self addSubview:_actionSheetView = actionSheetView];

    }
    
    return self;
}

- (void)addActions:(NSArray <JQAlertAction *>*)actions
{
    NSInteger count = 0;
    JQAlertAction *cancelAction = nil;
    for (JQAlertAction *action in actions)
    {
        if (action.style == JQAlertActionStyleCancel)
        {
            cancelAction = action;
            count++;
        }else {
            [self.alertActions addObject:action];
        }
        NSAssert(count < 2, @"JQAlertView can only have one action with a style of JQAlertActionStyleCancel");
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
            BOOL windowIsVisible = !window.hidden && window.alpha > 0;
            BOOL windowLevelNormal = window.windowLevel == UIWindowLevelNormal;
            
            if(windowOnMainScreen && windowIsVisible && windowLevelNormal)
            {
                [window addSubview:self];
                break;
            }
        }
        
        [UIView animateWithDuration:kShowAnimateDuration
                              delay:0
             usingSpringWithDamping:0.7f
              initialSpringVelocity:0.7f
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
             self.backgroundView.alpha = 1.0f;
             if (self.style == JQAlertViewStyleActionSheet)
             {
                 self.actionSheetView.frame = CGRectMake(0, self.frame.size.height-self.actionSheetView.frame.size.height, self.frame.size.width, self.actionSheetView.frame.size.height);
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
                                                            context:nil].size.height) + 10;
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, actionSheetHeight, self.frame.size.width, titleHeight)];
        titleLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        titleLabel.text = self.title;
        
        titleLabel.backgroundColor = [UIColor whiteColor];
        titleLabel.textColor = JQColor(100, 100, 100);
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.font = [UIFont systemFontOfSize:kTitleFontSize];
        titleLabel.numberOfLines = 0;
        [_actionSheetView addSubview:titleLabel];
        
        actionSheetHeight += titleHeight;
    }
    
    // message
    if (self.message && self.message.length)
    {
        
        CGFloat msgHeight = ceil([self.message boundingRectWithSize:CGSizeMake(actionSheetViewWidth, MAXFLOAT)
                                                            options:NSStringDrawingUsesLineFragmentOrigin
                                                         attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:kMsgFontSize]}
                                                            context:nil].size.height) + 15;
        
        UILabel *msgLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, actionSheetHeight -= 5, self.frame.size.width, msgHeight)];
        msgLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        msgLabel.text = self.message;
        msgLabel.backgroundColor = [UIColor whiteColor];
        msgLabel.textColor = JQColor(150, 150, 150);
        msgLabel.textAlignment = NSTextAlignmentCenter;
        msgLabel.font = [UIFont systemFontOfSize:kMsgFontSize];
        msgLabel.numberOfLines = 0;
        [_actionSheetView addSubview:msgLabel];
        
        actionSheetHeight += msgHeight;
    }
    
    // 记录当按钮为两个的时候 alert模式下 文字时候正常显示
    CGFloat btnWidth = actionSheetViewWidth * 0.5 - kRowLineHeight;
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
    
    
    // button
    UIImage *normalImg = [UIColor whiteColor].image;
    UIImage *highlightedImg = JQColor(242, 242, 242).image;
    if (self.alertActions.count == 2 && self.style == JQAlertViewStyleAlert && isInOneLine)
    {
        
        actionSheetHeight += kRowLineHeight;
        for (NSInteger i = 0; i < self.alertActions.count; i++)
        {
            JQAlertAction *action = self.alertActions[i];
            
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(i * (btnWidth + kRowLineHeight), actionSheetHeight, btnWidth, kRowHeight);
            button.tag = i;
            button.titleLabel.font = [UIFont systemFontOfSize:kBtnTitleFontSize];
            [button setTitle:action.title forState:UIControlStateNormal];
            [button setTitleColor:JQColor(64, 64, 64) forState:UIControlStateNormal];
            [button setBackgroundImage:normalImg forState:UIControlStateNormal];
            [button setBackgroundImage:highlightedImg forState:UIControlStateHighlighted];
            [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
            
            if (action.style == JQAlertActionStyleDestructive)
                [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            
            [_actionSheetView addSubview:button];
        }
        actionSheetHeight += kRowHeight;
        
    }else{
        
        for (NSInteger i = 0; i < self.alertActions.count; i++)
        {
            JQAlertAction *action = self.alertActions[i];
            
            actionSheetHeight += action.style == JQAlertActionStyleCancel ? kSeparatorHeight : kRowLineHeight;
            
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(0, actionSheetHeight, _actionSheetView.frame.size.width, kRowHeight);
            button.autoresizingMask = UIViewAutoresizingFlexibleWidth;
            button.tag = i;
            button.titleLabel.font = [UIFont systemFontOfSize:kBtnTitleFontSize];
            [button setTitle:action.title forState:UIControlStateNormal];
            [button setTitleColor:JQColor(64, 64, 64) forState:UIControlStateNormal];
            [button setBackgroundImage:normalImg forState:UIControlStateNormal];
            [button setBackgroundImage:highlightedImg forState:UIControlStateHighlighted];
            [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
            
            if (action.style == JQAlertActionStyleDestructive)
                [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            
            [_actionSheetView addSubview:button];
            actionSheetHeight += kRowHeight;
        }
    }
    
    
    // 设置frame
    if (self.style == JQAlertViewStyleActionSheet)
    {
        _actionSheetView.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, actionSheetHeight);
        
    } else{
        
        CGFloat x = ([UIScreen mainScreen].bounds.size.width - actionSheetViewWidth) * 0.5;
        CGFloat y = ([UIScreen mainScreen].bounds.size.height - actionSheetHeight) * 0.5;
        _actionSheetView.frame = CGRectMake(x, y, actionSheetViewWidth, actionSheetHeight);
        _actionSheetView.alpha = 0.0f;
    }
}


#pragma mark - 按钮点击
- (void)buttonClicked:(UIButton *)button
{
    [UIView animateWithDuration:kDismissAnimateDuration
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{

         self.backgroundView.alpha = 0.0f;
         if (self.style == JQAlertViewStyleActionSheet)
         {
             self.actionSheetView.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, self.actionSheetView.frame.size.height);
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

