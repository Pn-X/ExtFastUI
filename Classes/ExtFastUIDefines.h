//
//  ExtFastUIDefines.h
//  Pods
//
//  Created by hang_pan on 2020/6/23.
//

#ifndef ExtFastUIDefines_h
#define ExtFastUIDefines_h

@class ExtViewNode, UIView;

#define ExtRenderer(sel, cls, ...)      if ([sel isEqualToString:selector]) {\
                                            cls *this = (cls *)view;\
                                            __VA_ARGS__;\
                                            return;\
                                        }\

#define extViewNode(settings)   ext_createViewNode(({\
                                    ExtViewNode *this = [ExtViewNode new];\
                                    settings;\
                                    this;\
                                }))


#define ExtGetViewByID(id) self.ext_getViewById(id)
#define ExtGetViewByClass(class) self.ext_getViewByClass(class)


inline static id ExtDirective(id(^block)(void)) {
    id obj = block();
    if (obj == nil) {
        return @0;
    }
    return obj;
}
    
inline static id ExtDirectiveForIn(id object, id(^block)(id item, NSString *key, NSInteger index)) {
    NSMutableArray *targetArray = [NSMutableArray array];
    if ([object isKindOfClass:[NSArray class]]) {
        for (NSInteger i = 0; i < ((NSArray *)object).count; i++) {
            id obj = block(object[i], nil, i);
            if (obj == nil) {
                continue;
            }
            [targetArray addObject:obj];
        }
    } else if ([object isKindOfClass:[NSDictionary class]]) {
        for (NSString *key in object) {
            id obj = block(object[key], key, 0);
            if (obj == nil) {
                continue;
            }
            [targetArray addObject:obj];
        }
    }
    return targetArray;
}

inline static id ExtDirectiveIf(BOOL condition, id(^block)(void)) {
    NSMutableArray *targetArray = [NSMutableArray array];
    if (condition) {
        [targetArray addObject:block()];
    }
    return targetArray;
}

#endif /* ExtFastUIDefines_h */
