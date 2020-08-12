//
//  ViewController.m
//  Example
//
//  Created by hang_pan on 2020/6/23.
//  Copyright © 2020 hang_pan. All rights reserved.
//

#import "ViewController.h"
#import <ExtFastUI/ExtFastUI.h>

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSArray *demoVCArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"ExtFastUI";
    self.navigationController.navigationBar.translucent = YES;
    self.demoVCArray = [self createDemoVCArray];
    [self ext_remountTemplate];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.ext_getViewById(@"tableView").frame = self.view.bounds;
}

- (NSArray *)ext_template:(id)params {
    return @[
        UITableView.extViewNode(this.nodeId = @"tableView"),
    ];
}

- (void)ext_renderer:(UIView *)view withNodeId:(nonnull NSString *)selector params:(nullable id)params {
    ExtRenderer(@"tableView", UITableView, {
        this.delegate = self;
        this.dataSource = self;
        [this reloadData];
    });
}

#pragma mark - delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *name = [NSString stringWithFormat:@"%@ViewController", self.demoVCArray[indexPath.row][@"name"]];
    id vc = [NSClassFromString(name) new];
    if (!vc) {
        return;
    }
    [self.navigationController pushViewController:vc animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.demoVCArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = self.demoVCArray[indexPath.row][@"name"];
    cell.detailTextLabel.text = self.demoVCArray[indexPath.row][@"desc"];
    return cell;
}

- (NSArray *)createDemoVCArray {
    return @[
        @{
            @"name":@"Single",
            @"desc":@"start with simple api",
        },
        @{
            @"name":@"Multi",
            @"desc":@"learn how to use advanced api",
        },
        @{
            @"name":@"Complex",
            @"desc":@"a complex demo",
        }
    ];
}

@end

