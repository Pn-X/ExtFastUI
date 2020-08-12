//
//  UIStackView+ExtFastUI.m
//  Pods-Example
//
//  Created by hang_pan on 2020/6/23.
//

#import "UIStackView+ExtFastUI.h"
#import "UIView+ExtFastUI.h"

@implementation UIStackView (ExtFastUI)

- (instancetype (^)(id subviews))ext_addArrangedSubviews {
    return ^id(id subviews) {
        return [self ext_addArrangedSubviews:subviews];
    };
}

- (instancetype)ext_addArrangedSubviews:(NSArray *)views {
    for (UIView *view in views) {
        if ([view isKindOfClass:[NSArray class]]) {
            [self ext_addArrangedSubviews:(NSArray *)view];
        } else if ([view isKindOfClass:[UIView class]]) {
            [self addSubview:view];
        }
    }
    return self;
}

@end
