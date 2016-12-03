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
    
    [JQAlertView showAlertViewWithTitle:@"showAlert"
                                message:@"alertView style"
                         preferredStyle:JQAlertViewStyleActionSheet
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
