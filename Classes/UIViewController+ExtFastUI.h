//
//  UIViewController+ExtFastUI.h
//  Pods-Example
//
//  Created by hang_pan on 2020/6/23.
//


#import <UIKit/UIKit.h>
#import "ExtViewCache.h"
#import "ExtViewNode.h"
#import "ExtFastUIDefines.h"

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (ExtFastUI)

@property (nonatomic, strong, readonly) ExtViewCache *ext_viewCache;
@property (nonatomic, strong, readonly) NSMutableArray *ext_renderingTemplate;

// manipulate subviews
- (UIView *(^)(NSString *NodeId))ext_getViewById;
- (NSArray<UIView *>*(^)(NSString *NodeClass))ext_getViewByClass;
- (ExtViewNode *(^)(NSString *NodeId))ext_getViewNodeById;
- (NSArray<ExtViewNode *>*(^)(NSString *NodeClass))ext_getViewNodeByClass;

- (void)ext_remountTemplate;
- (void)ext_unmountTemplate;
- (void)ext_rerenderTemplate;

- (void)ext_remountTemplateWithParams:(nullable id)params;
- (void)ext_rerenderTemplateWithParams:(nullable id)params;

- (void)ext_rerenderWithNodeId:(NSString *)nodeId;
- (void)ext_rerenderWithNodeIds:(NSArray<NSString *> *)nodeIds;
- (void)ext_rerenderWithNodeClass:(NSString *)nodeClass;
- (void)ext_rerenderWithNodeClasses:(NSArray<NSString *> *)nodeClasses;

- (void)ext_rerenderWithNodeId:(NSString *)nodeId params:(nullable id)params;
- (void)ext_rerenderWithNodeIds:(NSArray<NSString *> *)nodeIds params:(nullable id)params;
- (void)ext_rerenderWithNodeClass:(NSString *)nodeClass params:(nullable id)params;
- (void)ext_rerenderWithNodeClasses:(NSArray<NSString *> *)nodeClasses params:(nullable id)params;

// manipulate subviews, override by subclass
- (NSArray *)ext_template:(nullable id)params;
- (void)ext_renderer:(UIView *)view withNodeId:(NSString *)selector params:(nullable id)params;
- (void)ext_renderer:(UIView *)view withNodeClass:(NSString *)selector params:(nullable id)params;
- (UIView *)ext_viewForNode:(ExtViewNode *)node;
- (UIView *)ext_mountOnView;

@end

NS_ASSUME_NONNULL_END
