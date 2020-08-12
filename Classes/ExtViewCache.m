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
        self.nodeIdStorage = [NSMutableDictionary dictionary];
        self.nodeClassStorage = [NSMutableDictionary dictionary];
        self.viewIdStorage = [NSMutableDictionary dictionary];
        self.viewClassStorage = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)storeViewNode:(ExtViewNode *)viewNode {
    if (viewNode.nodeId) {
        self.nodeIdStorage[viewNode.nodeId] = viewNode;
    }
    if (viewNode.nodeClass) {
        NSMutableArray *array = self.nodeClassStorage[viewNode.nodeClass];
        if (!array) {
            array = [NSMutableArray array];
            self.nodeClassStorage[viewNode.nodeClass] = array;
        }
        [array addObject:viewNode];
    }
}

- (void)deleteViewNode:(ExtViewNode *)viewNode {
    if (viewNode.nodeId) {
        self.nodeIdStorage[viewNode.nodeId] = nil;
    }
    if (viewNode.nodeClass) {
        NSMutableArray *array = self.nodeClassStorage[viewNode.nodeClass];
        if (!array) {
            return;
        }
        [array removeObject:viewNode];
    }
}

- (ExtViewNode *)getViewNodeById:(NSString *)nodeId {
    return self.nodeIdStorage[nodeId];
}
                                                     
- (NSMutableArray<ExtViewNode *> *)getViewNodeByClass:(NSString *)nodeClass {
    return self.nodeClassStorage[nodeClass];
}

- (nullable UIView *)fetchViewWithViewClass:(Class)viewClass nodeId:(NSString *)nodeId nodeClass:(NSString *)nodeClass {
    if (nodeId) {
        id view = self.viewIdStorage[nodeId];
        if ([view class] != viewClass) {
            return nil;
        }
        return view;
    }
    if (nodeClass) {
        NSMutableArray *array = self.viewClassStorage[nodeClass][NSStringFromClass(viewClass)];
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
        self.viewIdStorage[nodeId] = view;
        return;
    }
    if (nodeClass) {
        NSMutableDictionary *dic = self.viewClassStorage[nodeClass];
        if (!dic) {
            dic = [NSMutableDictionary dictionary];
            self.viewClassStorage[nodeClass] = dic;
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
        self.viewIdStorage[nodeId] = view;
        return;
    }
    if (nodeClass) {
        NSMutableDictionary *dic = self.viewClassStorage[nodeClass];
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
