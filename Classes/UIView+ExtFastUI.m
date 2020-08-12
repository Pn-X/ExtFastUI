//
//  UIView+ExtFastUI.m
//  Pods-Example
//
//  Created by hang_pan on 2020/6/23.
//

#import "UIView+ExtFastUI.h"
#import <objc/runtime.h>

@implementation UIView (ExtFastUI)
- (ExtViewEvent *)ext_event {
    ExtViewEvent *event = objc_getAssociatedObject(self, "ext_event");
    if (event == nil) {
        event = [[ExtViewEvent alloc] init];
        [self addGestureRecognizer:event.onTap];
        [self addGestureRecognizer:event.onSwipe];
        [self addGestureRecognizer:event.onPan];
        [self addGestureRecognizer:event.onPinch];
        [self addGestureRecognizer:event.onRotation];
        [self addGestureRecognizer:event.onLongPress];
        objc_setAssociatedObject(self, "ext_event", event, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return event;
}

- (NSMutableArray *)ext_renderingTemplate {
    NSMutableArray *nodes = objc_getAssociatedObject(self, "ext_renderingTemplate");
    if (nodes == nil) {
        nodes = [NSMutableArray array];
        objc_setAssociatedObject(self, "ext_renderingTemplate", nodes, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return nodes;
}

- (void)ext_setRenderingTemplate:(NSMutableArray *)template {
    objc_setAssociatedObject(self, "ext_renderingTemplate", template, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (ExtViewCache *)ext_viewCache {
    ExtViewCache *cache = objc_getAssociatedObject(self, "ext_viewCache");
    if (!cache) {
        cache = [ExtViewCache new];
        objc_setAssociatedObject(self, "ext_viewCache", cache, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return cache;
}

- (ExtViewNode *)ext_viewNode {
    return objc_getAssociatedObject(self, "ext_viewNode");
}

- (void)ext_setViewNode:(ExtViewNode *)viewNode {
    objc_setAssociatedObject(self, "ext_viewNode", viewNode, OBJC_ASSOCIATION_ASSIGN);
}

+ (ExtViewNode *(^)(ExtViewNode *node))ext_createViewNode {
    return ^ExtViewNode *(ExtViewNode *node) {
        node.viewClass = self;
        return node;
    };
}

- (instancetype (^)(id subviews))ext_addSubviews {
    return ^id(id subviews) {
        return [self ext_addSubviews:subviews];
    };
}

- (instancetype)ext_addSubviews:(id)subviews {
    for (UIView *v in subviews) {
        if ([v isKindOfClass:[NSArray class]]) {
            [self ext_addSubviews:(NSArray *)v];
        } else if ([v isKindOfClass:[UIView class]]) {
            [self addSubview:v];
        }
    }
    return self;
}
- (UIView *(^)(NSString *nodeId))ext_getViewById {
    return ^UIView *(NSString *nodeId) {
        ExtViewNode *targetNode = [self.ext_viewCache getViewNodeById:nodeId];
        return targetNode.view;
    };
}

- (NSArray<UIView *>*(^)(NSString *nodeClass))ext_getViewByClass {
    return ^NSArray *(NSString *nodeClass) {
        NSMutableArray *array = [NSMutableArray array];
        NSArray *targetNodes = [self.ext_viewCache getViewNodeByClass:nodeClass];
        for (ExtViewNode *node in targetNodes) {
            if (node.view) {
                [array addObject:node.view];
            }
        }
        return array;
    };
}

- (ExtViewNode *(^)(NSString *NodeId))ext_getViewNodeById {
    return ^ExtViewNode *(NSString *nodeId) {
        return [self.ext_viewCache getViewNodeById:nodeId];
    };
}

- (NSArray<ExtViewNode *>*(^)(NSString *NodeClass))ext_getViewNodeByClass {
    return ^NSArray *(NSString *nodeClass) {
        return [self.ext_viewCache getViewNodeByClass:nodeClass];
    };
}

- (void)ext_remountTemplate {
    [self ext_remountTemplateWithParams:nil];
}

- (void)ext_rerenderTemplate {
    [self ext_rerenderTemplateWithParams:nil];
}

- (void)ext_remountTemplateWithParams:(id)params {
    [self patch:self.ext_renderingTemplate with:[self flat:[self ext_template:params]] superview:self.ext_mountOnView params:params];
}

- (void)ext_rerenderTemplateWithParams:(id)params {
    NSArray *nodeArray = [self ext_renderingTemplate];
    for (ExtViewNode *node in nodeArray) {
        [self ext_rerenderViewNode:node params:params];
    }
}

- (void)ext_unmountTemplate {
    while (self.ext_renderingTemplate.count > 0) {
        [self ext_unmountViewNode:self.ext_renderingTemplate.firstObject containerArray:self.ext_renderingTemplate];
    }
}

- (void)ext_rerenderWithNodeId:(NSString *)nodeId {
    [self ext_rerenderWithNodeIds:@[nodeId] params:nil];
}

- (void)ext_rerenderWithNodeIds:(NSArray<NSString *> *)nodeIds {
    [self ext_rerenderWithNodeIds:nodeIds params:nil];
}

- (void)ext_rerenderWithNodeClass:(NSString *)nodeClass {
    [self ext_rerenderWithNodeClasses:@[nodeClass] params:nil];
}

- (void)ext_rerenderWithNodeClasses:(NSArray<NSString *> *)nodeClasses {
    [self ext_rerenderWithNodeClasses:nodeClasses params:nil];
}

- (void)ext_rerenderWithNodeId:(NSString *)nodeId params:(id)params {
    [self ext_rerenderWithNodeIds:@[nodeId] params:params];
}

- (void)ext_rerenderWithNodeIds:(NSArray<NSString *> *)nodeIds params:(id)params {
    for (NSString *nodeId in nodeIds) {
        ExtViewNode *node = [self.ext_viewCache getViewNodeById:nodeId];
        [self ext_rerenderViewNode:node params:params];
    }
}

- (void)ext_rerenderWithNodeClass:(NSString *)nodeClass params:(id)params {
    [self ext_rerenderWithNodeClasses:@[nodeClass]];
}

- (void)ext_rerenderWithNodeClasses:(NSArray<NSString *> *)nodeClasses params:(id)params {
    for (NSString *nodeClass in nodeClasses) {
        NSArray *set = [self.ext_viewCache getViewNodeByClass:nodeClass];
        for (ExtViewNode *node in set) {
            [self ext_rerenderViewNode:node params:params];
        }
    }
}

#pragma mark - private method
- (void)patch:(NSMutableArray<ExtViewNode *> *)oldNodeArray with:(NSMutableArray<ExtViewNode *> *)newNodeArray superview:(UIView *)superview params:(id)params {
#define EXT_SET_NODE(prop)  if (node.event.prop != newNodeArray.firstObject.event.prop) {\
                                node.event.prop = newNodeArray.firstObject.event.prop;\
                                [node.view.ext_event.prop removeTarget:nil action:nil];\
                                node.view.ext_event.prop.enabled = NO;\
                                if (node.event.prop != nil) {\
                                    node.view.userInteractionEnabled = YES;\
                                    node.view.ext_event.prop.enabled = YES;\
                                    [node.view.ext_event.prop addTarget:self action:node.event.prop];\
                                }\
                            }
    
#define EXT_SET_UICONTROL_NODE(prop, enum)      if (node.event.prop != newNodeArray.firstObject.event.prop) {\
                                                    node.event.prop = newNodeArray.firstObject.event.prop;\
                                                    if (node.event.prop != nil) {\
                                                        [(UIControl *)node.view addTarget:self action:node.event.prop forControlEvents:enum];\
                                                    }\
                                                }
    NSMutableArray *orderNodeArray = [NSMutableArray array];
    while (newNodeArray.count > 0 && oldNodeArray.count > 0) {
        NSInteger index = [self findNode:newNodeArray.firstObject inArray:oldNodeArray withRange:NSMakeRange(0, oldNodeArray.count)];
        if (index > -1) {
            ExtViewNode *node = oldNodeArray[index];
            [orderNodeArray addObject:node];
            if ([superview isKindOfClass:[UIStackView class]]) {
                [(UIStackView *)superview addArrangedSubview:node.view];
            } else {
                [superview addSubview:oldNodeArray.firstObject.view];
            }
            EXT_SET_NODE(onTap);
            EXT_SET_NODE(onSwipe);
            EXT_SET_NODE(onPinch);
            EXT_SET_NODE(onPan);
            EXT_SET_NODE(onRotation);
            EXT_SET_NODE(onLongPress);
            if ([node.view isKindOfClass:[UIControl class]]) {
                [(UIControl *)node.view removeTarget:self action:nil forControlEvents:UIControlEventAllEvents];
                
                EXT_SET_UICONTROL_NODE(touchDown, UIControlEventTouchUpInside);
                EXT_SET_UICONTROL_NODE(touchDownRepeat, UIControlEventTouchDownRepeat);
                EXT_SET_UICONTROL_NODE(touchDragInside, UIControlEventTouchDragInside);
                EXT_SET_UICONTROL_NODE(touchDragOutside, UIControlEventTouchDragOutside);
                EXT_SET_UICONTROL_NODE(touchDragEnter, UIControlEventTouchDragEnter);
                EXT_SET_UICONTROL_NODE(touchDragExit, UIControlEventTouchDragExit);
                EXT_SET_UICONTROL_NODE(touchUpInside, UIControlEventTouchUpInside);
                EXT_SET_UICONTROL_NODE(touchUpOutside, UIControlEventTouchUpOutside);
                EXT_SET_UICONTROL_NODE(touchCancel, UIControlEventTouchCancel);
                
                EXT_SET_UICONTROL_NODE(valueChanged, UIControlEventValueChanged);
                EXT_SET_UICONTROL_NODE(primaryActionTriggered, UIControlEventPrimaryActionTriggered);
                
                EXT_SET_UICONTROL_NODE(editingDidBegin, UIControlEventEditingDidBegin);
                EXT_SET_UICONTROL_NODE(editingChanged, UIControlEventEditingChanged);
                EXT_SET_UICONTROL_NODE(editingDidEnd, UIControlEventEditingDidEnd);
                EXT_SET_UICONTROL_NODE(editingDidEndOnExit, UIControlEventEditingDidEndOnExit);
                
                EXT_SET_UICONTROL_NODE(allTouchEvents, UIControlEventAllTouchEvents);
                EXT_SET_UICONTROL_NODE(allEditingEvents, UIControlEventAllEditingEvents);
                EXT_SET_UICONTROL_NODE(applicationReserved, UIControlEventApplicationReserved);
                EXT_SET_UICONTROL_NODE(systemReserved, UIControlEventSystemReserved);
                EXT_SET_UICONTROL_NODE(allEvents, UIControlEventAllEvents);
            }
            if (node.nodeClass != nil) {
                [self ext_renderer:node.view withNodeClass:node.nodeClass params:params];
            }
            if (node.nodeId != nil) {
                [self ext_renderer:node.view withNodeId:node.nodeId params:params];
            }
            [self patch:node.childNodes with:newNodeArray.firstObject.childNodes superview:node.view params:params];
            [newNodeArray removeObjectAtIndex:0];
            [oldNodeArray removeObjectAtIndex:index];
            
        } else {
            [orderNodeArray addObject:newNodeArray.firstObject];
            [self ext_mountViewNode:newNodeArray.firstObject superview:superview params:params];
            [newNodeArray removeObjectAtIndex:0];
        }
    }
    while (oldNodeArray.count > 0) {
        [self ext_unmountViewNode:oldNodeArray.firstObject containerArray:oldNodeArray];
    }
    while (newNodeArray.count > 0) {
        [orderNodeArray addObject:newNodeArray.firstObject];
        [self ext_mountViewNode:newNodeArray.firstObject superview:superview params:params];
        [newNodeArray removeObjectAtIndex:0];
    }
    [oldNodeArray addObjectsFromArray:orderNodeArray];
}

- (NSInteger)findNode:(ExtViewNode *)node inArray:(NSArray *)array withRange:(NSRange)range {
    for (NSInteger i = range.location; i < range.location + range.length; i++) {
        ExtViewNode *temp = array[i];
        if ([temp isEqual:node]) {
            return i;
        }
    }
    return -1;
}

- (NSMutableArray *)flat:(NSArray *)array {
    NSMutableArray *ret = [NSMutableArray array];
    [self emurateArray:array withBlock:^(ExtViewNode *node) {
        [ret addObject:node];
    }];
    return ret;
}

- (void)emurateArray:(NSArray *)array withBlock:(void(^)(ExtViewNode *node))block {
    if ([array isKindOfClass:[NSArray class]]) {
        if (array.count <= 0) {
            return;
        }
        for (ExtViewNode *node in array) {
            [self emurateArray:(NSArray *)node withBlock:block];
        }
    } else if ([array isKindOfClass:[ExtViewNode class]]) {
        block((ExtViewNode *)array);
    }
}

- (void)ext_mountViewNode:(ExtViewNode *)node superview:(UIView *)superview params:(id)params {
#define EXT_SET(prop)   view.ext_event.prop.enabled = NO;\
                        [view.ext_event.prop removeTarget:nil action:nil];\
                        if (node.event.prop != nil) {\
                            view.userInteractionEnabled = YES;\
                            [view.ext_event.prop addTarget:self action:node.event.prop];\
                            view.ext_event.prop.enabled = YES;\
                        }
    
#define EXT_SET_UICONTROL(prop, enum)   if (node.event.prop != nil) {\
                                            [(UIControl *)node.view addTarget:self action:node.event.prop forControlEvents:enum];\
                                        }\

    UIView *view = [self ext_fetchUsableViewForNode:node];
    if ([superview isKindOfClass:[UIStackView class]]) {
        [(UIStackView *)superview addArrangedSubview:view];
    } else {
        [superview addSubview:view];
    }
    node.view = view;
    view.ext_viewNode = node;
    EXT_SET(onTap);
    EXT_SET(onSwipe);
    EXT_SET(onPinch);
    EXT_SET(onPan);
    EXT_SET(onRotation);
    EXT_SET(onLongPress);
    if ([node.view isKindOfClass:[UIControl class]]) {
        [(UIControl *)node.view removeTarget:self action:nil forControlEvents:UIControlEventAllEvents];
        EXT_SET_UICONTROL(touchDown, UIControlEventTouchUpInside);
        EXT_SET_UICONTROL(touchDownRepeat, UIControlEventTouchDownRepeat);
        EXT_SET_UICONTROL(touchDragInside, UIControlEventTouchDragInside);
        EXT_SET_UICONTROL(touchDragOutside, UIControlEventTouchDragOutside);
        EXT_SET_UICONTROL(touchDragEnter, UIControlEventTouchDragEnter);
        EXT_SET_UICONTROL(touchDragExit, UIControlEventTouchDragExit);
        EXT_SET_UICONTROL(touchUpInside, UIControlEventTouchUpInside);
        EXT_SET_UICONTROL(touchUpOutside, UIControlEventTouchUpOutside);
        EXT_SET_UICONTROL(touchCancel, UIControlEventTouchCancel);
        
        EXT_SET_UICONTROL(valueChanged, UIControlEventValueChanged);
        EXT_SET_UICONTROL(primaryActionTriggered, UIControlEventPrimaryActionTriggered);
        
        EXT_SET_UICONTROL(editingDidBegin, UIControlEventEditingDidBegin);
        EXT_SET_UICONTROL(editingChanged, UIControlEventEditingChanged);
        EXT_SET_UICONTROL(editingDidEnd, UIControlEventEditingDidEnd);
        EXT_SET_UICONTROL(editingDidEndOnExit, UIControlEventEditingDidEndOnExit);
        
        EXT_SET_UICONTROL(allTouchEvents, UIControlEventAllTouchEvents);
        EXT_SET_UICONTROL(allEditingEvents, UIControlEventAllEditingEvents);
        EXT_SET_UICONTROL(applicationReserved, UIControlEventApplicationReserved);
        EXT_SET_UICONTROL(systemReserved, UIControlEventSystemReserved);
        EXT_SET_UICONTROL(allEvents, UIControlEventAllEvents);
    }
    [self.ext_viewCache storeViewNode:node];
    [self ext_rerenderViewNode:node params:params];
    for (ExtViewNode *childNode in node.childNodes) {
        [self ext_mountViewNode:childNode superview:view params:params];
    }
}

- (void)ext_rerenderViewNode:(ExtViewNode *)node params:(id)params {
    UIView *view = node.view;
    if (node.nodeClass != nil) {
        [self ext_renderer:view withNodeClass:node.nodeClass params:params];
    }
    if (node.nodeId != nil) {
        [self ext_renderer:view withNodeId:node.nodeId params:params];
    }
    for (ExtViewNode *childNode in node.childNodes) {
        [self ext_rerenderViewNode:childNode params:params];
    }
}

- (void)ext_unmountViewNode:(ExtViewNode *)node containerArray:(NSMutableArray *)containerArray {
#define EXT_SET_NIL(prop)   [view.ext_event.prop removeTarget:nil action:nil];\
                            view.ext_event.prop.enabled = NO;
    
    for (ExtViewNode *childNode in node.childNodes) {
        [self ext_unmountViewNode:childNode containerArray:node.childNodes];
    }
    [containerArray removeObject:node];
    UIView *view = node.view;
    EXT_SET_NIL(onTap);
    EXT_SET_NIL(onSwipe);
    EXT_SET_NIL(onPinch);
    EXT_SET_NIL(onPan);
    EXT_SET_NIL(onRotation);
    EXT_SET_NIL(onLongPress);
    if ([node.view isKindOfClass:[UIControl class]]) {
        [(UIControl *)node.view removeTarget:self action:nil forControlEvents:UIControlEventAllEvents];
    }
    [view removeFromSuperview];
    [self.ext_viewCache deleteViewNode:node];
    if (!node.disableCache) {
        [self.ext_viewCache storeView:view withNodeId:node.nodeId nodeClass:node.nodeClass];
    }
}

- (UIView *)ext_fetchUsableViewForNode:(ExtViewNode *)node {
    UIView *view = [self.ext_viewCache fetchViewWithViewClass:node.viewClass nodeId:node.nodeId nodeClass:node.nodeClass];
    if (!view) {
        view = [self ext_viewForNode:node];
        if (!view) {
            view = [[node.viewClass alloc] initWithFrame:CGRectZero];
        }
        if (!view) {
            view = [[node.viewClass alloc] init];
        }
    }
    return view;
}
#pragma mark override by subclass
- (NSArray *)ext_template:(id)params {
    return @[];
}

- (void)ext_renderer:(UIView *)view withNodeId:(NSString *)selector params:(nullable id)params {
    
}

- (void)ext_renderer:(UIView *)view withNodeClass:(NSString *)selector params:(nullable id)params {
    
}

- (UIView *)ext_viewForNode:(ExtViewNode *)node {
    if ([node.viewClass isKindOfClass:[UICollectionView class]]) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        return [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    }
    return [[node.viewClass alloc] initWithFrame:CGRectZero];
}

- (UIView *)ext_mountOnView {
    if ([self isKindOfClass:[UITableViewCell class]]) {
        return ((UITableViewCell *)self).contentView;
    }
    if ([self isKindOfClass:[UICollectionViewCell class]]) {
        return ((UICollectionViewCell *)self).contentView;
    }
    return self;
}

@end
