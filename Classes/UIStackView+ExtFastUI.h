//
//  UIStackView+ExtFastUI.h
//  Pods-Example
//
//  Created by hang_pan on 2020/6/23.
//

#import <UIKit/UIKit.h>
#import "ExtFastUIDefines.h"

NS_ASSUME_NONNULL_BEGIN

@interface UIStackView (ExtFastUI)

- (instancetype (^)(id subviews))ext_addArrangedSubviews;

- (instancetype)ext_addArrangedSubviews:(NSArray *)views;

@end

NS_ASSUME_NONNULL_END
