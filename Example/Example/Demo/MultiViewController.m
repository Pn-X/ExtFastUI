//
//  MultiViewController.m
//  Example
//
//  Created by hang_pan on 2020/8/7.
//  Copyright © 2020 hang_pan. All rights reserved.
//

#import "MultiViewController.h"
#import <ExtFastUI/ExtFastUI.h>
#import "Defines.h"

@interface MultiViewController ()

@property (nonatomic, assign) NSInteger tapCount;
@property (nonatomic, assign) NSInteger swipeCount;
@property (nonatomic, assign) NSInteger pinchCount;
@property (nonatomic, assign) NSInteger longPressCount;
@property (nonatomic, assign) NSInteger rotationCount;
@property (nonatomic, assign) NSInteger panCount;

@property (nonatomic, assign) BOOL flag;

@end

@implementation MultiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.flag = NO;
    [self ext_remountTemplate];
    self.ext_getViewById(@"swipe").ext_event.onSwipe.direction = UISwipeGestureRecognizerDirectionRight | UISwipeGestureRecognizerDirectionLeft;
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    CGFloat bottom = 0;
    if (@available(iOS 11.0, *)) {
        bottom = self.view.safeAreaInsets.bottom;
    }
    self.ext_getViewById(@"title").frame = CGRectMake(0, CGRectGetMaxY(self.navigationController.navigationBar.frame), self.view.bounds.size.width, 20);
    self.ext_getViewById(@"done").frame = CGRectMake(10, CGRectGetMaxY(self.view.frame) - 50 - bottom, CGRectGetWidth(self.view.frame) - 20, 50);
    self.ext_getViewById(@"swipe").frame = CGRectMake(10, CGRectGetMaxY(self.ext_getViewById(@"title").frame), self.view.bounds.size.width - 20, 50);
    NSArray *array = self.ext_getViewNodeByClass(@"content");
    self.flag = NO;
    for (ExtViewNode *node in array) {
        if (node.index == 4) {
            continue;
        }
        node.view.frame = CGRectMake(0, 0, 150, 150);
        node.view.center = self.view.center;
    }
}

- (NSArray *)ext_template:(nullable id)params {
    return @[
        UILabel.extViewNode(this.nodeId = @"title"),
        UILabel.extViewNode(this.nodeClass = @"content"; this.index = 0; this.event.onPan = @selector(handlePan:); this.event.onLongPress = @selector(handleLongPress:)),
        UILabel.extViewNode(this.nodeClass = @"content"; this.index = 1; this.event.onPan = @selector(handlePan:); this.event.onPinch = @selector(handlePinch:)),
        UILabel.extViewNode(this.nodeClass = @"content"; this.index = 2; this.event.onPan = @selector(handlePan:); this.event.onRotation = @selector(handleRotation:)),
        UILabel.extViewNode(this.nodeClass = @"content"; this.index = 3; this.event.onPan = @selector(handlePan:)),
        UILabel.extViewNode(this.nodeId = @"swipe"; this.nodeClass = @"content"; this.index = 4; this.event.onSwipe = @selector(handleSwipe:)),
        UIButton.extViewNode(this.nodeId = @"done"; this.event.onTap = @selector(handleTap:); this.event.gestureDelegate = self)
    ];
}

- (void)ext_renderer:(UIView *)view withNodeClass:(nonnull NSString *)selector params:(nullable id)params {
    ExtRenderer(@"content", UILabel, {
        this.backgroundColor = RandomColor;
        if (this.ext_viewNode.index == 0) {
            this.text = @"long press";
        } else if (this.ext_viewNode.index == 1) {
            this.text = @"pinch";
        } else if (this.ext_viewNode.index == 2) {
            this.text = @"rotation";
        } else if (this.ext_viewNode.index == 3) {
            this.text = @"pan";
        }
        this.textAlignment = NSTextAlignmentCenter;
        this.font = [UIFont systemFontOfSize:12];
        this.textColor = [UIColor whiteColor];
        this.layer.cornerRadius = 10;
        this.layer.masksToBounds = YES;
    });
}

- (void)ext_renderer:(UIView *)view withNodeId:(NSString *)selector params:(nullable id)params {
    ExtRenderer(@"done", UIButton, {
        [this setTitle:@"tap" forState:UIControlStateNormal];
        this.layer.cornerRadius = 10;
        this.backgroundColor = RandomColor;
    });
    ExtRenderer(@"swipe", UILabel, {
        this.text = @"swipe";
    });
    ExtRenderer(@"title", UILabel, {
        this.textColor = [UIColor lightGrayColor];
        this.textAlignment = NSTextAlignmentCenter;
        this.font = [UIFont systemFontOfSize:12];
        this.text = params;
    });
}

- (void)doAnimation {
    if (self.flag) {
        self.flag = NO;
        [UIView animateWithDuration:0.25 animations:^{
            NSArray *array = self.ext_getViewNodeByClass(@"content");
            for (ExtViewNode *node in array) {
                if (node.index == 4) {
                    continue;
                }
                node.view.center = self.view.center;
            }
        }];
    } else {
        self.flag = YES;
        [UIView animateWithDuration:0.25 animations:^{
            NSArray *array = self.ext_getViewNodeByClass(@"content");
            for (ExtViewNode *node in array) {
                if (node.index == 0) {
                    node.view.frame = CGRectMake(10, CGRectGetMaxY(self.ext_getViewById(@"swipe").frame) + 10, 150, 150);
                } else if (node.index == 1) {
                    node.view.frame = CGRectMake(self.view.bounds.size.width - 160, CGRectGetMaxY(self.ext_getViewById(@"swipe").frame) + 10, 150, 150);
                } else if (node.index == 2) {
                    node.view.frame = CGRectMake(10, CGRectGetMinY(self.ext_getViewById(@"done").frame) - 160, 150, 150);
                } else if (node.index == 3) {
                    node.view.frame = CGRectMake(self.view.bounds.size.width - 160, CGRectGetMinY(self.ext_getViewById(@"done").frame) - 160, 150, 150);
                }
            }
        }];
    }
}

- (void)handlePan:(UIPanGestureRecognizer *)sender {
    CGPoint pt = [sender translationInView:sender.view];
    sender.view.center = CGPointMake(sender.view.center.x + pt.x , sender.view.center.y + pt.y);
    [sender setTranslation:CGPointMake(0, 0) inView:self.view];
    [self ext_rerenderWithNodeId:@"title" params:[NSString stringWithFormat:@"pan count : %ld", self.panCount++]];
}

- (void)handleLongPress:(UIPanGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateEnded || sender.state == UIGestureRecognizerStateCancelled) {
        return;
    }
    [self ext_rerenderWithNodeId:@"title" params:[NSString stringWithFormat:@"long press count : %ld", self.longPressCount++]];
}

- (void)handleRotation:(UIRotationGestureRecognizer *)sender {
    [self ext_rerenderWithNodeId:@"title" params:[NSString stringWithFormat:@"rotation count : %ld", self.rotationCount++]];
}

- (void)handlePinch:(UIPinchGestureRecognizer *)sender {
    [self ext_rerenderWithNodeId:@"title" params:[NSString stringWithFormat:@"pinch count : %ld", self.pinchCount++]];
}

- (void)handleSwipe:(UISwipeGestureRecognizer *)sender {
    [self ext_rerenderWithNodeIds:@[@"swipe", @"title"] params:[NSString stringWithFormat:@"swipe count : %ld", self.swipeCount++]];
}

- (void)handleTap:(UITapGestureRecognizer *)sender {
    [self ext_rerenderTemplateWithParams:[NSString stringWithFormat:@"tap count : %ld", self.tapCount++]];
    [self doAnimation];
}

@end
