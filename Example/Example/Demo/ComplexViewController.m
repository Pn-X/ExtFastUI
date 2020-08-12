//
//  ComplexViewController.m
//  Example
//
//  Created by hang_pan on 2020/8/7.
//  Copyright © 2020 hang_pan. All rights reserved.
//

#import "ComplexViewController.h"
#import <ExtFastUI/ExtFastUI.h>
#import "Defines.h"
#import "ComplexView.h"
#import "ComplexCell.h"
#import <Masonry/Masonry.h>

@interface ComplexViewController()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) NSInteger secondType;
@property (nonatomic, strong) NSArray *textArray;
@property (nonatomic, strong) NSString *editText;

@end

@implementation ComplexViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hanleDirectionChange:) name:UIDeviceOrientationDidChangeNotification object:nil];
    self.view.backgroundColor = [UIColor whiteColor];
    self.textArray = [self textArrayWithSwitchOn:NO];
    self.dataArray = [NSMutableArray array];
    [self ext_remountTemplate];
    [self setUpViewConstraints];
}

- (NSArray *)ext_template:(nullable id)params {
    return @[
        ExtDirectiveForIn(self.textArray, ^id(id item, NSString *key, NSInteger index) {
            return
            UIView.extViewNode(this.nodeClass = @"bg"; this.index = index; this.event.onTap = @selector(handleTap:)).append(@[
                UILabel.extViewNode(this.nodeClass = @"text"; this.index = index),
            ]);
        }),
        ExtDirective(^id{
            if (self.secondType == 0) {
                return UILabel.extViewNode(this.nodeId = @"type-0");
            } else if (self.secondType == 1) {
                return UIImageView.extViewNode(this.nodeId = @"type-1");
            }
            return UITextField.extViewNode(this.nodeId = @"type-2"; this.event.editingChanged = @selector(changeEditingText:));
        }),
        UITableView.extViewNode(this.nodeId = @"table"),
        ComplexView.extViewNode(this.nodeId = @"control").append(@[
            UIImageView.extViewNode(this.nodeId = @"line"),
        ]),
    ];
}

- (UIView *)ext_viewForNode:(ExtViewNode *)node {
    if ([node.nodeId isEqualToString:@"table"]) {
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.backgroundColor = [UIColor whiteColor];
        [tableView registerClass:[ComplexCell class] forCellReuseIdentifier:@"ComplexCell"];
        return tableView;
    }
    return [super ext_viewForNode:node];
}

- (void)ext_renderer:(UIView *)view withNodeClass:(nonnull NSString *)selector params:(nullable id)params {
    ExtRenderer(@"bg", UIView, {
        this.backgroundColor = RandomColor;
        this.layer.cornerRadius = 10;
        this.layer.masksToBounds = YES;
    });
    ExtRenderer(@"text", UILabel, {
        this.textColor = [UIColor whiteColor];
        this.textAlignment = NSTextAlignmentCenter;
        this.font = [UIFont systemFontOfSize:12];
        this.text = self.textArray[this.ext_viewNode.index];
    });
}

- (void)ext_renderer:(UIView *)view withNodeId:(NSString *)selector params:(nullable id)params{
    ExtRenderer(@"line", UIImageView, {
        this.backgroundColor = RandomColor;
    });
    ExtRenderer(@"type-0", UILabel, {
        this.text = self.editText;
        this.textColor = RandomColor;
        this.textAlignment = NSTextAlignmentCenter;
        this.font = [UIFont systemFontOfSize:12];
    });
    ExtRenderer(@"type-1", UIImageView, {
        this.image = ExtImageWithColor(RandomColor);
    });
    ExtRenderer(@"type-2", UITextField, {
        this.textColor = RandomColor;
        this.placeholder = @"input text here";
        this.font = [UIFont systemFontOfSize:12];
        this.layer.borderColor = [UIColor lightGrayColor].CGColor;
        this.layer.borderWidth = 0.5f;
        this.text = @"";
        this.returnKeyType = UIReturnKeyDone;
        this.delegate = self;
    });
}

- (BOOL)ext_captureEvent:(NSString *)event withParams:(id)params {
    UITableView *tableView = (UITableView *)self.ext_getViewById(@"table");
    if ([event isEqualToString:@"addEvent"]) {
        [self ext_rerenderWithNodeId:@"line"];
        [self.dataArray addObject:[ComplexEntity randomInstance]];
        NSIndexPath *path = [NSIndexPath indexPathForRow:self.dataArray.count-1 inSection:0];
        [tableView insertRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationRight];
        [tableView scrollToRowAtIndexPath:path atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
        return YES;
    }
    if ([event isEqualToString:@"deleteEvent"]) {
        [self ext_rerenderWithNodeId:@"line"];
        if (self.dataArray.count == 0) {
            return YES;
        }
        [self.dataArray removeLastObject];
        [tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.dataArray.count inSection:0]] withRowAnimation:UITableViewRowAnimationLeft];
        return YES;
    }
    if ([event isEqualToString:@"switchEvent"]) {
        self.textArray = [self textArrayWithSwitchOn:[params boolValue]];
        [self ext_remountTemplate];
        [self setUpViewConstraints];
        return YES;
    }
    if ([event isEqualToString:@"segmentEvent"]) {
        self.secondType = [params integerValue];
        [self ext_remountTemplate];
        [self setUpViewConstraints];
        return YES;
    }
    return NO;
}

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    [theTextField resignFirstResponder];
    return YES;

}
#pragma mark - tableview delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 88;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ComplexCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ComplexCell"];
    ComplexEntity *entity = self.dataArray[indexPath.row];
    [cell setEntity:entity];
    return cell;
}

#pragma mark - private method
- (void)hanleDirectionChange:(NSNotification *)noti {
    [self setUpViewConstraints];
}

- (void)changeEditingText:(UITextField *)sender {
    self.editText = sender.text;
}

- (void)handleTap:(UITapGestureRecognizer *)recognizer {
    recognizer.view.backgroundColor = RandomColor;
}

- (NSArray *)textArrayWithSwitchOn:(BOOL)switchOn {
    if (switchOn) {
        return @[@"a",@"b",@"c"];
    }
    return @[@"d",@"f"];
}

- (void)setUpViewConstraints {
    UIView *preview = nil;
    CGFloat top = CGRectGetMaxY(self.navigationController.navigationBar.frame);
    
    NSArray *nodeArray = self.ext_getViewNodeByClass(@"bg");
    for (ExtViewNode *node in nodeArray) {
        [node.view mas_remakeConstraints:^(MASConstraintMaker *make) {
            if (preview) {
                make.top.equalTo(preview.mas_bottom).offset(10);
            } else {
                make.top.equalTo(self.view).offset(top + 10);
            }
            make.left.equalTo(self.view.mas_left).offset(10);
            make.right.equalTo(self.view.mas_right).offset(-10);
            make.height.equalTo(@30);
        }];
        ExtViewNode *childNode = node.childNodes.firstObject;
        [childNode.view mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(node.view);
        }];
        preview = node.view;
    }
    if (self.secondType == 0) {
        [ExtGetViewByID(@"type-0") mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(preview.mas_bottom).offset(10);
            make.left.equalTo(self.view.mas_left).offset(10);
            make.right.equalTo(self.view.mas_right).offset(-10);
            make.height.equalTo(@30);
        }];
        preview = ExtGetViewByID(@"type-0");
    } else if (self.secondType == 1) {
        [ExtGetViewByID(@"type-1") mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(preview.mas_bottom).offset(10);
            make.left.equalTo(self.view.mas_left).offset(10);
            make.right.equalTo(self.view.mas_right).offset(-10);
            make.height.equalTo(@40);
        }];
        preview = ExtGetViewByID(@"type-1");
    } else {
        [ExtGetViewByID(@"type-2") mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(preview.mas_bottom).offset(10);
            make.left.equalTo(self.view.mas_left).offset(10);
            make.right.equalTo(self.view.mas_right).offset(-10);
            make.height.equalTo(@50);
        }];
        preview = ExtGetViewByID(@"type-2");
    }
    if (preview) {
        [ExtGetViewByID(@"table") mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(ExtGetViewByID(@"control").mas_top).offset(-10);
            make.left.right.equalTo(self.view);
            make.top.equalTo(preview.mas_bottom);
        }];
    }
    [ExtGetViewByID(@"control") mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.equalTo(@100);
    }];
    [ExtGetViewByID(@"line") mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(ExtGetViewByID(@"control"));
        make.height.equalTo(@0.5f);
    }];
}
@end
