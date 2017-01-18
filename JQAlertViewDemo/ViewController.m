//
//  ViewController.m
//  JQAlertViewDemo
//
//  Created by JiaQi on 2016/11/14.
//  Copyright © 2016年 任玉祥. All rights reserved.
//

#import "ViewController.h"
#import "JQAlertView.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UISwitch *isTwo;

@end

@implementation ViewController

- (IBAction)show
{
    [self showWithStyle:JQAlertViewStyleActionSheet twoAction:false];

}

/**
 pod spec lint
 pod trunk push JQAlertView.podspec --allow-warnings
 
 */

- (IBAction)onelint
{
    
    [JQAlertView showActionSheetWithTitle:@"showAlert"
                                  message:@"alertView style"
                                   titles:@[@"JQAlertViewStyleActionSheet", @"JQAlertViewStyleAlert"]
                         destructiveTitle:nil
                              cancelTitle:@"cancel"
                                  handler:^(JQAlertView * _Nonnull alertView, NSInteger index) {
        if (index > 1) return;
        
        [JQAlertView showAlertViewWithTitle:alertView.message
                                    message:[NSString stringWithFormat:@"%zd",index]
                             preferredStyle:index
                                     titles:@[@"action1", @"action2"]
                           destructiveTitle:@"delete"
                                cancelTitle:@"cancel"
                                    handler:^(JQAlertView * _Nonnull alertView, NSInteger index) {
                                        
                                        NSLog(@"index == %zd, title: %@", index, alertView.title);
        }];
   }];
   
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
//    [JQAlertView showSystemAlertWithTitle:@"系统样式"
//                                  message:@"显示系统样式的alert"
//                              cancelTitle:@"取消"
//                         destructiveTitle:@"删除"
//                              otherTitles:@[@"按钮1", @"按钮2"]
//                                  handler:^(NSInteger index) {
//        NSLog(@"系统样式 ==  %zd", index);
//    }];
    
    [JQAlertView showSystemAlertWithTitle:@"title" message:@"message" cancelTitle:@"取消" otherTitle:@"确定" handler:^(NSInteger index) {
        NSLog(@"系统样式 ==  %zd", index);
    }];
}

- (IBAction)showAlert
{
    [self showWithStyle:JQAlertViewStyleAlert twoAction:self.isTwo.isOn];
}

- (void)showWithStyle:(JQAlertViewStyle)style twoAction:(BOOL)isTwo
{
    JQAlertView *alertView = [JQAlertView alertViewWithTitle:@"JQAlertViewDemo Title" message:@"This is JQAlertViewDemo message \nIs like wechat alert" preferredStyle:style];
    
    JQAlertAction *action1 = [JQAlertAction actionWithTitle:@"default" style:JQAlertActionStyleDefault handler:^(JQAlertAction * _Nonnull action) {
        NSLog(@"default action");
    }];
    
    JQAlertAction *action2 = [JQAlertAction actionWithTitle:@"cancel" style:JQAlertActionStyleCancel handler:^(JQAlertAction * _Nonnull action) {
        NSLog(@"cancel action");
    }];
    
    JQAlertAction *action3 = [JQAlertAction actionWithTitle:@"destructive" style:JQAlertActionStyleDestructive handler:^(JQAlertAction * _Nonnull action) {
        NSLog(@"destructive action");
    }];
    
    JQAlertAction *action4 = [JQAlertAction actionWithTitle:@"default" style:JQAlertActionStyleDefault handler:^(JQAlertAction * _Nonnull action) {
        NSLog(@"default action");
    }];
    
    
    if (!isTwo)
    {
        [alertView addActions:@[action1, action2, action3, action4]];
    }else{
        [alertView addActions:@[action1, action2]];
    }
    
    [alertView show];
}

@end
