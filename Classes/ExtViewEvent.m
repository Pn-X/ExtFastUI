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
        _onTap = [[UITapGestureRecognizer alloc] init];
        _onTap.enabled = NO;
        
        _onSwipe = [[UISwipeGestureRecognizer alloc] init];
        _onSwipe.enabled = NO;
        
        _onPan = [[UIPanGestureRecognizer alloc] init];
        _onPan.enabled = NO;
        
        _onPinch = [[UIPinchGestureRecognizer alloc] init];
        _onPinch.enabled = NO;
        
        _onRotation = [[UIRotationGestureRecognizer alloc] init];
        _onRotation.enabled = NO;
        
        _onLongPress = [[UILongPressGestureRecognizer alloc] init];
        _onLongPress.enabled = NO;
    }
    return self;
}

@end
