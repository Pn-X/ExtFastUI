//
//  ExtViewNode.h
//  ExtFastUI
//
//  Created by hang_pan on 2020/7/27.
//

#import <Foundation/Foundation.h>
#import "ExtFastUIDefines.h"

NS_ASSUME_NONNULL_BEGIN

@interface ExtViewNodeEvent : NSObject

@property (nonatomic, assign, nullable) SEL onTap;
@property (nonatomic, assign, nullable) SEL onPinch;
@property (nonatomic, assign, nullable) SEL onLongPress;
@property (nonatomic, assign, nullable) SEL onPan;
@property (nonatomic, assign, nullable) SEL onSwipe;
@property (nonatomic, assign, nullable) SEL onRotation;
@property (nonatomic, weak, nullable) id gestureDelegate;

//use for UIControl, else ignore
@property (nonatomic, assign, nullable) SEL touchDown;
@property (nonatomic, assign, nullable) SEL touchDownRepeat;
@property (nonatomic, assign, nullable) SEL touchDragInside;
@property (nonatomic, assign, nullable) SEL touchDragOutside;
@property (nonatomic, assign, nullable) SEL touchDragEnter;
@property (nonatomic, assign, nullable) SEL touchDragExit;
@property (nonatomic, assign, nullable) SEL touchUpInside;
@property (nonatomic, assign, nullable) SEL touchUpOutside;
@property (nonatomic, assign, nullable) SEL touchCancel;
    
    
@property (nonatomic, assign, nullable) SEL valueChanged;
@property (nonatomic, assign, nullable) SEL primaryActionTriggered;

@property (nonatomic, assign, nullable) SEL editingDidBegin;
@property (nonatomic, assign, nullable) SEL editingChanged;
@property (nonatomic, assign, nullable) SEL editingDidEnd;
@property (nonatomic, assign, nullable) SEL editingDidEndOnExit;

@property (nonatomic, assign, nullable) SEL allTouchEvents;
@property (nonatomic, assign, nullable) SEL allEditingEvents;
@property (nonatomic, assign, nullable) SEL applicationReserved;
@property (nonatomic, assign, nullable) SEL systemReserved;
@property (nonatomic, assign, nullable) SEL allEvents;

@end

@interface ExtViewNode : NSObject

@property (nonatomic, strong) Class viewClass;
@property (nonatomic, strong, nullable) NSString *nodeId;
@property (nonatomic, strong, nullable) NSString *nodeClass;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong, nullable) NSString *key;
@property (nonatomic, strong, nullable) id data;
@property (nonatomic, strong) NSMutableArray *childNodes;
@property (nonatomic, weak, nullable) ExtViewNode *parentNode;
@property (nonatomic, strong, nullable) UIView *view;

//if set YES, view will not cache after unmount, default NO
@property (nonatomic, assign) BOOL disableCache;

@property (nonatomic, strong, nullable) ExtViewNodeEvent *event;

- (ExtViewNode *(^)(id childNodes))append;

- (BOOL)isEqual:(ExtViewNode *)object;
@end
NS_ASSUME_NONNULL_END
