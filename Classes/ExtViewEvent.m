//
//  ExtViewEvent.m
//  ExtFastUI
//
//  Created by hang_pan on 2020/8/11.
//

#import "ExtViewEvent.h"

@implementation ExtViewEvent

- (instancetype)init {
    self = [super init];
    if (self) {
        self.onTap = [[UITapGestureRecognizer alloc] init];
        self.onTap.enabled = NO;
        
        self.onSwipe = [[UISwipeGestureRecognizer alloc] init];
        self.onSwipe.enabled = NO;
        
        self.onPan = [[UIPanGestureRecognizer alloc] init];
        self.onPan.enabled = NO;
        
        self.onPinch = [[UIPinchGestureRecognizer alloc] init];
        self.onPinch.enabled = NO;
        
        self.onRotation = [[UIRotationGestureRecognizer alloc] init];
        self.onRotation.enabled = NO;
        
        self.onLongPress = [[UILongPressGestureRecognizer alloc] init];
        self.onLongPress.enabled = NO;
    }
    return self;
}

@end
