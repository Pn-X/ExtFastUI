//
//  SingleViewController.m
//  Example
//
//  Created by hang_pan on 2020/8/7.
//  Copyright © 2020 hang_pan. All rights reserved.
//

#import "SingleViewController.h"
#import <ExtFastUI/ExtFastUI.h>
#import "Defines.h"

@interface SingleViewController ()

@end

@implementation SingleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self ext_remountTemplate];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.ext_getViewById(@"v1").frame = self.view.bounds;
}

- (NSArray *)ext_template:(nullable id)params {
    return @[
        UIView.extViewNode(this.nodeId = @"v1";this.event.onTap = @selector(sayHello);)
    ];
}

- (void)ext_renderer:(UIView *)view withNodeId:(NSString *)selector params:(nullable id)params {
    ExtRenderer(@"v1", UIView, {
        this.backgroundColor = RandomColor;
    });
}

- (void)sayHello {
    NSLog(@"hello");
    [self ext_rerenderTemplate];
}

@end
