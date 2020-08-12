//
//  ExtViewCache.h
//  ExtFastUI
//
//  Created by hang_pan on 2020/7/27.
//

#import <Foundation/Foundation.h>
#import "ExtFastUIDefines.h"

NS_ASSUME_NONNULL_BEGIN

@class ExtViewNode;
@interface ExtViewCache : NSObject

- (void)storeViewNode:(ExtViewNode *)viewNode;
- (void)deleteViewNode:(ExtViewNode *)viewNode;
- (ExtViewNode *)getViewNodeById:(NSString *)nodeId;
- (NSMutableArray<ExtViewNode *> *)getViewNodeByClass:(NSString *)nodeClass;

- (nullable UIView *)fetchViewWithViewClass:(Class)viewClass nodeId:(NSString *)nodeId nodeClass:(NSString *)nodeClass;
- (void)storeView:(UIView *)view withNodeId:(NSString *)nodeId nodeClass:(NSString *)nodeClass;
- (void)deleteView:(UIView *)view withNodeId:(NSString *)nodeId nodeClass:(NSString *)nodeClass;

@end

NS_ASSUME_NONNULL_END
