//
//  ExtStackView.m
//  ExtFastUI
//
//  Created by hang_pan on 2020/9/18.
//

#import "ExtStackView.h"

@implementation ExtVStackView

@synthesize axis;

- (instancetype)init {
    self = [super init];
    if (self) {
        self.axis = UILayoutConstraintAxisVertical;
    }
    return self;
}

- (void)setAxis:(UILayoutConstraintAxis)axis {
    [super setAxis:UILayoutConstraintAxisVertical];
}

@end

@implementation ExtHStackView
- (instancetype)init {
    self = [super init];
    if (self) {
        self.axis = UILayoutConstraintAxisHorizontal;
    }
    return self;
}

- (void)setAxis:(UILayoutConstraintAxis)axis {
    [super setAxis:UILayoutConstraintAxisHorizontal];
}

@end
