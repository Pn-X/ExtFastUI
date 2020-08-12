//
//  ExtViewEvent.h
//  ExtFastUI
//
//  Created by hang_pan on 2020/8/11.
//

#import <Foundation/Foundation.h>

@interface ExtViewEvent : NSObject

@property (nonatomic, strong) UITapGestureRecognizer *onTap;

@property (nonatomic, strong) UISwipeGestureRecognizer *onSwipe;

@property (nonatomic, strong) UIPanGestureRecognizer *onPan;

@property (nonatomic, strong) UIPinchGestureRecognizer *onPinch;

@property (nonatomic, strong) UIRotationGestureRecognizer *onRotation;

@property (nonatomic, strong) UILongPressGestureRecognizer *onLongPress;

@end
