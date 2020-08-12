//
//  UIResponder+ExtEvent.m
//  Pods-Example
//
//  Created by hang_pan on 2020/8/11.
//

#import "UIResponder+ExtEvent.h"

@implementation UIResponder (ExtEvent)

- (void)ext_triggerEvent:(NSString *)event withParams:(id)params {
    assert([event isKindOfClass:[NSString class]]);
    UIResponder *responder = self;
    do {
        BOOL blocked = [responder ext_captureEvent:event withParams:params];
        if (blocked) {
            break;
        }
        responder = responder.nextResponder;
    } while (responder);
}

- (BOOL)ext_captureEvent:(NSString *)event withParams:(id)params {
    return NO;
}

@end
