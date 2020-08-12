//
//  ComplexCell.m
//  Example
//
//  Created by hang_pan on 2020/8/10.
//  Copyright © 2020 hang_pan. All rights reserved.
//

#import "ComplexCell.h"
#import <ExtFastUI/ExtFastUI.h>
#import "Defines.h"
#import <Masonry/Masonry.h>

@interface ComplexCell ()

@property (nonatomic, strong) ComplexEntity *entity;

@end

@implementation ComplexCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self ext_remountTemplate];
        [self setNeedsUpdateConstraints];
    }
    return self;
}

- (void)updateConstraints {
    [ExtGetViewByID(@"img") mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.left.equalTo(self.contentView.mas_left).offset(10);
        make.top.equalTo(self.contentView.mas_top).offset(10);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-10);
        make.width.equalTo(ExtGetViewByID(@"img").mas_height);
    }];
    if (self.entity.isOn) {
        [ExtGetViewByID(@"name") mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(ExtGetViewByID(@"img").mas_top);
            make.left.equalTo(ExtGetViewByID(@"img").mas_right).offset(10);
            make.right.lessThanOrEqualTo(ExtGetViewByID(@"switcher").mas_left);
        }];
    } else {
        [ExtGetViewByID(@"name") mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.left.equalTo(ExtGetViewByID(@"img").mas_right).offset(10);
            make.right.lessThanOrEqualTo(ExtGetViewByID(@"switcher").mas_left);
        }];
    }
    [ExtGetViewByID(@"detail") mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(ExtGetViewByID(@"name").mas_left);
        make.bottom.equalTo(ExtGetViewByID(@"img").mas_bottom);
        make.right.lessThanOrEqualTo(ExtGetViewByID(@"switcher").mas_left);
    }];
    [ExtGetViewByID(@"switcher") mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-10);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.width.equalTo(@([ExtGetViewByID(@"switcher") intrinsicContentSize].width));
    }];
    [super updateConstraints];
}

- (NSArray *)ext_template:(nullable id)params {
    return @[
        UIImageView.extViewNode(this.nodeId = @"img"),
        UILabel.extViewNode(this.nodeId = @"name"),
        UILabel.extViewNode(this.nodeId = @"detail"),
        UISwitch.extViewNode(this.nodeId = @"switcher"; this.event.valueChanged = @selector(changeValue:)),
    ];
}

- (void)ext_renderer:(UIView *)view withNodeId:(NSString *)selector params:(ComplexEntity *)params {
    ExtRenderer(@"img", UIImageView, {
        this.image = self.entity.image;
    });
    ExtRenderer(@"name", UILabel, {
        this.text = self.entity.name;
        this.textColor = [UIColor darkGrayColor];
        this.font = [UIFont systemFontOfSize:14 weight:UIFontWeightBold];
    });
    ExtRenderer(@"detail", UILabel, {
        this.text = self.entity.detail;
        this.textColor = [UIColor lightGrayColor];
        this.font = [UIFont systemFontOfSize:12];
        this.hidden = !self.entity.isOn;
    });
    ExtRenderer(@"switcher", UISwitch, {
        [this setOn:self.entity.isOn];
    });
}

- (void)setEntity:(ComplexEntity *)entity {
    _entity = entity;
    self.contentView.backgroundColor = entity.isOn?[UIColor colorWithWhite:0.98 alpha:1.0]:[UIColor whiteColor];
    [self ext_remountTemplate];
    [self setNeedsUpdateConstraints];
}

- (void)changeValue:(UISwitch *)sender {
    self.entity.isOn = sender.isOn;
    self.contentView.backgroundColor = sender.isOn?[UIColor colorWithWhite:0.98 alpha:1.0]:[UIColor whiteColor];
    [self ext_rerenderWithNodeId:@"detail"];
    [self setNeedsUpdateConstraints];
}

@end
