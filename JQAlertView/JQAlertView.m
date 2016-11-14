//
//  JQAlertController.m
//  JQAlertControllerDemo
//
//  Created by JiaQi on 2016/11/14.
//  Copyright © 2016年 任玉祥. All rights reserved.
//

#import "JQAlertView.h"

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
    return _actionTitle;
}

- (JQAlertActionStyle)style
{
    return _actionStyle;
}
@end

#pragma mark - JQAlertView

static const CGFloat kRowHeight = 48.0f;
static const CGFloat kRowLineHeight = 1.0f;
static const CGFloat kSeparatorHeight = 6.0f;
static const CGFloat kTitleFontSize = 14.0f;
static const CGFloat kMsgFontSize = 12.0f;
static const CGFloat kButtonTitleFontSize = 18.0f;
static const NSTimeInterval kAnimateDuration = 0.4f;

@interface JQAlertView()
@property (nonatomic, assign) JQAlertViewStyle style;
@property (nonatomic, strong) NSMutableArray <JQAlertAction *> *alertActions;

/** 背景图片 */
@property (strong, nonatomic) UIView *backgroundView;
/** 弹出视图 */
@property (strong, nonatomic) UIView *actionSheetView;
/** 点击的按钮 */
@property (nonatomic, weak) UIButton *clickBtn;

@end

@implementation JQAlertView

- (NSMutableArray<JQAlertAction *> *)alertActions
{
    if (!_alertActions) {
        _alertActions = [NSMutableArray array];
    }
    
    return _alertActions;
}
- (JQAlertViewStyle)preferredStyle
{
    return _style;
}

- (NSArray<JQAlertAction *> *)actions
{
    return self.alertActions;
}

+ (instancetype)alertViewWithTitle:(nullable NSString *)title message:(nullable NSString *)message preferredStyle:(JQAlertViewStyle)preferredStyle
{
    return [[self alloc] initWithTitle:title message:message preferredStyle:preferredStyle];
}


- (instancetype)initWithTitle:(nullable NSString *)title message:(nullable NSString *)message preferredStyle:(JQAlertViewStyle)preferredStyle
{
    self = [super initWithFrame:CGRectZero];
    if (self)
    {
        self.title = title;
        self.message = message;
        self.style = preferredStyle;
        
        self.frame = CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height);
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        
        _backgroundView = [[UIView alloc] initWithFrame:self.frame];
        _backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _backgroundView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4f];
        _backgroundView.alpha = 0;
        [self addSubview:_backgroundView];
        
        _actionSheetView = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height, self.frame.size.width, 0)];
        _actionSheetView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
        _actionSheetView.backgroundColor = [UIColor colorWithRed:238.0f/255.0f green:238.0f/255.0f blue:238.0f/255.0f alpha:1.0f];
        [self addSubview:_actionSheetView];
        
        
        _actionSheetView.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, 0);
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
        
        if (count > 1) {
            [[NSException exceptionWithName:@"JQAlertView Error" reason:@"JQAlertView can only have one action with a style of JQAlertActionStyleCancel" userInfo:nil] raise];
        }
    }
    
    if (cancelAction) {
        [self.alertActions addObject:cancelAction];
    }

}

- (void)show
{
    
    CGFloat actionSheetHeight = 0.0f;
    
    if (self.title && self.title.length)
    {
        actionSheetHeight += kRowLineHeight;
        
        CGFloat titleHeight = ceil([self.title boundingRectWithSize:CGSizeMake(self.frame.size.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:kTitleFontSize]} context:nil].size.height) + 10;
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, actionSheetHeight, self.frame.size.width, titleHeight)];
        titleLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        titleLabel.text = self.title;
        titleLabel.backgroundColor = [UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:1.0f];
        titleLabel.textColor = [UIColor colorWithRed:100.0f/255.0f green:100.0f/255.0f blue:100.0f/255.0f alpha:1.0f];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.font = [UIFont systemFontOfSize:kTitleFontSize];
        titleLabel.numberOfLines = 0;
        [_actionSheetView addSubview:titleLabel];
        
        actionSheetHeight += titleHeight;
    }
    
    if (self.message && self.message.length)
    {
        
        CGFloat msgHeight = ceil([self.message boundingRectWithSize:CGSizeMake(self.frame.size.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:kMsgFontSize]} context:nil].size.height) + 10;
        
        UILabel *msgLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, actionSheetHeight, self.frame.size.width, msgHeight)];
        msgLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        msgLabel.text = self.message;
        msgLabel.backgroundColor = [UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:1.0f];
        msgLabel.textColor = [UIColor colorWithRed:150.0f/255.0f green:150.0f/255.0f blue:150.0f/255.0f alpha:1.0f];
        msgLabel.textAlignment = NSTextAlignmentCenter;
        msgLabel.font = [UIFont systemFontOfSize:kMsgFontSize];
        msgLabel.numberOfLines = 0;
        [_actionSheetView addSubview:msgLabel];
        
        actionSheetHeight += msgHeight;
    }

    
    UIImage *normalImage = [self imageWithColor:[UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:1.0f]];
    UIImage *highlightedImage = [self imageWithColor:[UIColor colorWithRed:242.0f/255.0f green:242.0f/255.0f blue:242.0f/255.0f alpha:1.0f]];
    
    for (NSInteger i = 0; i < self.alertActions.count; i++)
    {
        JQAlertAction *action = self.alertActions[i];
        
        actionSheetHeight += action.style == JQAlertActionStyleCancel ? kSeparatorHeight : kRowLineHeight;
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, actionSheetHeight, self.frame.size.width, kRowHeight);
        button.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        button.tag = i;
        button.titleLabel.font = [UIFont systemFontOfSize:kButtonTitleFontSize];
        [button setTitle:action.title forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithRed:64.0f/255.0f green:64.0f/255.0f blue:64.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
        [button setBackgroundImage:normalImage forState:UIControlStateNormal];
        [button setBackgroundImage:highlightedImage forState:UIControlStateHighlighted];
        [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        if (action.style == JQAlertActionStyleDestructive) {
            [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        }
        
        [_actionSheetView addSubview:button];
        actionSheetHeight += kRowHeight;
        
        
    }
    
    _actionSheetView.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, actionSheetHeight);
    
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        
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
        
        [UIView animateWithDuration:kAnimateDuration
                              delay:0
             usingSpringWithDamping:0.7f
              initialSpringVelocity:0.7f
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
            self.backgroundView.alpha = 1.0f;
            self.actionSheetView.frame = CGRectMake(0, self.frame.size.height-self.actionSheetView.frame.size.height, self.frame.size.width, self.actionSheetView.frame.size.height);
        } completion:nil];
    }];
}


- (void)buttonClicked:(UIButton *)button
{
    self.clickBtn = button;
    [self dismiss];
}

- (void)dismiss
{
    [UIView animateWithDuration:kAnimateDuration delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.backgroundView.alpha = 0.0f;
        self.actionSheetView.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, self.actionSheetView.frame.size.height);
    } completion:^(BOOL finished) {

        JQAlertAction *action = self.alertActions[self.clickBtn.tag];
        if (action.action) {
            action.action(action);
        }
        [self removeFromSuperview];
    }];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint point = [[touches anyObject] locationInView:self.backgroundView];
    if (CGRectContainsPoint(self.actionSheetView.frame, point)) return;
    [UIView animateWithDuration:kAnimateDuration animations:^{
        self.backgroundView.alpha = 0.0f;
        self.actionSheetView.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, self.actionSheetView.frame.size.height);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}



- (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (void)dealloc
{
#ifdef DEBUG
    NSLog(@"JQAlertView dealloc");
#endif
}
@end
