//
//  ExtViewNode.m
//  ExtFastUI
//
//  Created by hang_pan on 2020/7/27.
//

#import "ExtViewNode.h"

@implementation ExtViewNodeEvent

@end

@implementation ExtViewNode

- (instancetype)init {
    self = [super init];
    if (self) {
        _childNodes = [NSMutableArray array];
    }
    return self;
}

- (ExtViewNodeEvent *)event {
    if (!_event) {
        _event = [ExtViewNodeEvent new];
    }
    return _event;
}

- (ExtViewNode *(^)(id childNodes))append {
    return ^ExtViewNode *(id childNodes) {
        return [self append:childNodes];
    };
}

- (instancetype)append:(id)childNodes {
    for (ExtViewNode *node in childNodes) {
        if ([node isKindOfClass:[NSArray class]]) {
            [self append:(ExtViewNode *)node];
        } else if ([node isKindOfClass:[ExtViewNode class]]) {
            [_childNodes addObject:node];
        }
    }
    return self;
}

- (BOOL)isEqual:(ExtViewNode *)object {
    if (_viewClass == object.viewClass
        && ((_nodeId == nil && object.nodeId == nil) || (_nodeId != nil && object.nodeId != nil && [_nodeId isEqualToString:object.nodeId]))
        && ((_nodeClass == nil && object.nodeClass == nil) || (_nodeClass != nil && object.nodeClass != nil && [_nodeClass isEqualToString:object.nodeClass]))
        && _key == object.key
        && _index == object.index
        && _data == object.data
        ) {
        return YES;
    }
    return NO;
}

@end
