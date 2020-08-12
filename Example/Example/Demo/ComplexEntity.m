//
//  ComplexEntity.m
//  Example
//
//  Created by hang_pan on 2020/8/11.
//  Copyright © 2020 hang_pan. All rights reserved.
//

#import "ComplexEntity.h"
#import "Defines.h"

@implementation ComplexEntity

+ (instancetype)randomInstance {
    ComplexEntity *entity = [ComplexEntity new];
    entity.image = ExtImageWithColor(RandomColor);
    entity.name = [NSString stringWithFormat:@"name-%@", [NSUUID UUID].UUIDString];
    entity.detail = [NSString stringWithFormat:@"detail-%u", arc4random()%999999];
    entity.isOn = NO;
    return entity;
}

@end
