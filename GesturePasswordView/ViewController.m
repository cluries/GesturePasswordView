//
//  ViewController.m
//  GesturePasswordView
//
//  Created by cluries on 3/14/15.
//  Copyright (c) 2015 cluries. All rights reserved.
//

#import "ViewController.h"
#import "GesturePasswordView.h"


static inline UIColor*
UIColorRGB(float r, float g, float b)
{
    return [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0];
}

static NSString* const kInputTip     = @"请输入解锁密码";
static NSString* const kErrorMessage = @"密码输入错误";

@interface ViewController () <GesturePasswordViewDelegate>

@property (nonatomic,strong) GesturePasswordView* guesturePasswordView;

@end

@implementation ViewController
{
    UILabel* messageLabel_;
}


- (void) loadView
{
    [super loadView];
    
    self.view.backgroundColor = UIColorRGB(41, 43, 56);
    
    float top = (self.view.bounds.size.height - self.view.bounds.size.width)/2.0 * 1.5;
    
    _guesturePasswordView                 = [[GesturePasswordView alloc] initWithFrame:CGRectMake(0, top, self.view.bounds.size.width, self.view.bounds.size.width)];
    _guesturePasswordView.backgroundColor = self.view.backgroundColor;
    _guesturePasswordView.delegate        = self;
    [self.view addSubview:_guesturePasswordView];
    
    messageLabel_               = [[UILabel alloc] initWithFrame:CGRectMake(0, top/2.2, self.view.bounds.size.width, top/3.0)];
    messageLabel_.textAlignment = NSTextAlignmentCenter;
    messageLabel_.font          = [UIFont systemFontOfSize:16];
    messageLabel_.textColor     = [_guesturePasswordView selectedColor];
    messageLabel_.text          = kInputTip;
    
    [self.view addSubview:messageLabel_];
}



- (void) gesturePasswordView:(GesturePasswordView *)passwordView didEndInputWithPassword:(NSString *)password sequence:(NSUInteger)sequence
{
    messageLabel_.text      = kErrorMessage;
    passwordView.error      = YES;
    messageLabel_.textColor = [passwordView selectedColor];
    
    __weak typeof(passwordView) weakpv = passwordView;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (weakpv.sequence == sequence) {
            [weakpv reset];
            messageLabel_.textColor = [weakpv selectedColor];
            messageLabel_.text      = kInputTip;
        }
    });
}

- (void) gesturePasswordView:(GesturePasswordView *)passwordView didStartedWithSequence:(NSUInteger)sequence
{
    messageLabel_.textColor = [_guesturePasswordView selectedColor];
    messageLabel_.text      = kInputTip;
}


@end
