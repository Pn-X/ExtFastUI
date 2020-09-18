//
//  ExtViewCache.m
//  ExtFastUI
//
//  Created by hang_pan on 2020/7/27.
//

#import "ExtViewCache.h"
#import "ExtViewNode.h"
#import "ExtFastUIDefines.h"
#import "UIView+ExtFastUI.h"

static NSMutableSet *ExtViewCacheViewNodePool;

@interface ExtViewCache()

@property (nonatomic, strong) NSMutableDictionary *nodeIdStorage;
@property (nonatomic, strong) NSMutableDictionary <NSString *, NSMutableArray *>*nodeClassStorage;

@property (nonatomic, strong) NSMutableDictionary *viewIdStorage;
@property (nonatomic, strong) NSMutableDictionary <NSString *, NSMutableDictionary <NSString *, NSMutableArray *>*> *viewClassStorage;

@end

@implementation ExtViewCache

- (instancetype)init {
    self = [super init];
    if (self) {
        _nodeIdStorage = [NSMutableDictionary dictionary];
        _nodeClassStorage = [NSMutableDictionary dictionary];
        _viewIdStorage = [NSMutableDictionary dictionary];
        _viewClassStorage = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)storeViewNode:(ExtViewNode *)viewNode {
    if (viewNode.nodeId) {
        _nodeIdStorage[viewNode.nodeId] = viewNode;
    }
    if (viewNode.nodeClass) {
        NSMutableArray *array = _nodeClassStorage[viewNode.nodeClass];
        if (!array) {
            array = [NSMutableArray array];
            _nodeClassStorage[viewNode.nodeClass] = array;
        }
        [array addObject:viewNode];
    }
}

- (void)deleteViewNode:(ExtViewNode *)viewNode {
    if (viewNode.nodeId) {
        _nodeIdStorage[viewNode.nodeId] = nil;
    }
    if (viewNode.nodeClass) {
        NSMutableArray *array = _nodeClassStorage[viewNode.nodeClass];
        if (!array) {
            return;
        }
        [array removeObject:viewNode];
    }
}

- (ExtViewNode *)getViewNodeById:(NSString *)nodeId {
    return _nodeIdStorage[nodeId];
}
                                                     
- (NSMutableArray<ExtViewNode *> *)getViewNodeByClass:(NSString *)nodeClass {
    return _nodeClassStorage[nodeClass];
}

- (nullable UIView *)fetchViewWithViewClass:(Class)viewClass nodeId:(NSString *)nodeId nodeClass:(NSString *)nodeClass {
    if (nodeId) {
        id view = _viewIdStorage[nodeId];
        if ([view class] != viewClass) {
            return nil;
        }
        return view;
    }
    if (nodeClass) {
        NSMutableArray *array = _viewClassStorage[nodeClass][NSStringFromClass(viewClass)];
        UIView *view = array.firstObject;
        if (view) {
            [array removeObjectAtIndex:0];
        }
        return view;
    }
    return nil;
}

- (void)storeView:(UIView *)view withNodeId:(NSString *)nodeId nodeClass:(NSString *)nodeClass {
    if (nodeId) {
        _viewIdStorage[nodeId] = view;
        return;
    }
    if (nodeClass) {
        NSMutableDictionary *dic = _viewClassStorage[nodeClass];
        if (!dic) {
            dic = [NSMutableDictionary dictionary];
            _viewClassStorage[nodeClass] = dic;
        }
        NSMutableArray *array = dic[NSStringFromClass([view class])];
        if (!array) {
            array = [NSMutableArray array];
            dic[NSStringFromClass([view class])] = array;
        }
        [array addObject:view];
        return;
    }
}

- (void)deleteView:(UIView *)view withNodeId:(NSString *)nodeId nodeClass:(NSString *)nodeClass {
    if (nodeId) {
        _viewIdStorage[nodeId] = view;
        return;
    }
    if (nodeClass) {
        NSMutableDictionary *dic = _viewClassStorage[nodeClass];
        if (!dic) {
            return;
        }
        NSMutableArray *array = dic[NSStringFromClass([view class])];
        if (!array) {
            return;
        }
        [array removeObject:view];
        return;
    }
}

@end
