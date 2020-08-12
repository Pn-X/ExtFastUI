//
//  ComplexView.m
//  Example
//
//  Created by hang_pan on 2020/8/10.
//  Copyright © 2020 hang_pan. All rights reserved.
//

#import "ComplexView.h"
#import <ExtFastUI/ExtFastUI.h>
#import "Defines.h"
#import <ExtResponderEvent/UIResponder+ExtEvent.h>

@implementation ComplexView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self ext_remountTemplate];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    ExtGetViewByID(@"stack").frame = CGRectMake(10, 0, self.bounds.size.width - 20, 70);
}

- (NSArray *)ext_template:(nullable id)params {
    return @[
        UIStackView.extViewNode(this.nodeId = @"stack").append(@[
            UIButton.extViewNode(this.nodeId = @"add"; this.event.touchUpInside = @selector(handleAdd:)),
            UIButton.extViewNode(this.nodeId = @"delete"; this.event.touchUpInside = @selector(handleDelete:)),
            UISwitch.extViewNode(this.nodeId = @"switch"; this.event.valueChanged = @selector(handleSwitch:)),
            UISegmentedControl.extViewNode(this.nodeId = @"segment"; this.event.valueChanged = @selector(handleSegment:)),
        ]),
    ];
}

- (void)ext_renderer:(UIView *)view withNodeId:(NSString *)selector params:(id)params {
    ExtRenderer(@"add", UIButton, {
        [this setTitle:@"add" forState:UIControlStateNormal];
        [this setTitleColor:RandomColor forState:UIControlStateNormal];
    });
    ExtRenderer(@"delete", UIButton, {
        [this setTitle:@"delete" forState:UIControlStateNormal];
        [this setTitleColor:RandomColor forState:UIControlStateNormal];
    });
}

- (UIView *)ext_viewForNode:(ExtViewNode *)node {
    if ([node.nodeId isEqualToString:@"stack"]) {
        UIStackView *stack = [UIStackView new];
        stack.axis = UILayoutConstraintAxisHorizontal;
        stack.distribution = UIStackViewDistributionFillEqually;
        stack.alignment = UIStackViewAlignmentCenter;
        stack.spacing = 0;
        return stack;
    }
    if ([node.nodeId isEqualToString:@"segment"]) {
        UISegmentedControl *segment = [[UISegmentedControl alloc] initWithItems:@[@"0",@"1",@"2"]];
        segment.selectedSegmentIndex = 0;
        return segment;
    }
    return [super ext_viewForNode:node];
}

- (void)handleAdd:(UITapGestureRecognizer *)recognizer {
    [self ext_triggerEvent:@"addEvent" withParams:nil];
    [self ext_rerenderTemplate];
}

- (void)handleDelete:(UITapGestureRecognizer *)recognizer {
    [self ext_triggerEvent:@"deleteEvent" withParams:nil];
    [self ext_rerenderTemplate];
}

- (void)handleSwitch:(UISwitch *)sender {
    [self ext_triggerEvent:@"switchEvent" withParams:@(sender.on)];
}

- (void)handleSegment:(UISegmentedControl *)sender {
    [self ext_triggerEvent:@"segmentEvent" withParams:@(sender.selectedSegmentIndex)];
}

@end
