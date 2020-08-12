//
//  ComplexEntity.h
//  Example
//
//  Created by hang_pan on 2020/8/11.
//  Copyright © 2020 hang_pan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ComplexEntity : NSObject

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *detail;
@property (nonatomic, assign) BOOL isOn;

+ (instancetype)randomInstance;

@end

NS_ASSUME_NONNULL_END
