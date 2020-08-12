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
        self.childNodes = [NSMutableArray array];
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
            [self.childNodes addObject:node];
        }
    }
    return self;
}

- (BOOL)isEqual:(ExtViewNode *)object {
    if (self.viewClass == object.viewClass
        && self.nodeId == object.nodeId
        && self.nodeClass == object.nodeClass
        && self.key == object.key
        && self.index == object.index
        && self.data == object.data
        ) {
        return YES;
    }
    return NO;
}

@end
