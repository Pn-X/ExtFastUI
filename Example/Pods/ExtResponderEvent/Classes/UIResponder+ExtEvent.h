//
//  UIResponder+ExtEvent.h
//  Pods-Example
//
//  Created by hang_pan on 2020/8/11.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIResponder (ExtEvent)

- (void)ext_triggerEvent:(NSString *)event withParams:(nullable id)params;

//return YES to block event, default NO
- (BOOL)ext_captureEvent:(NSString *)event withParams:(nullable id)params;

@end

NS_ASSUME_NONNULL_END
