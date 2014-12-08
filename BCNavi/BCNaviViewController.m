//
//  BCNaviViewController.m
//  BCBrowser
//
//  Created by Barney Chen on 2014/12/8.
//  Copyright (c) 2014年 CWH. All rights reserved.
//

#import "BCNaviViewController.h"
#import "BCNaviCell.h"
#import "BCAddLocationViewController.h"
#import <ReactiveCocoa.h>

@interface BCNaviViewController()

@property (nonatomic, strong) NSArray *locations;

@end


@implementation BCNaviViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.locations = [[NSArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Locations" ofType:@"plist"]];
    
    [self.navigationItem setTitle:@"NAVI"];
    
    UIBarButtonItem *add = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"plus"] style:UIBarButtonItemStyleDone target:nil action:nil];
    add.tintColor = [UIColor blackColor];
    add.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        BCAddLocationViewController *addVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"BCAddLocationViewController"];
        UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:addVC];
        [self presentViewController:navi animated:YES completion:nil];
        return [RACSignal empty];
    }];
    self.navigationItem.rightBarButtonItem = add;
    
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 10)];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.locations.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BCNaviCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BCNaviCell"];
    cell.title.text = self.locations[indexPath.row][@"Name"];
    cell.title.textColor = [UIColor whiteColor];
    
    UIImage *btnImage = [UIImage imageNamed:@"Image1"];
    [cell.button setBackgroundImage:btnImage forState:UIControlStateNormal];
    cell.button.imageView.contentMode = UIViewContentModeCenter;
    
    cell.button.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        NSString *url;
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"comgooglemaps://"]]) {
            // open google map app
            url = [NSString stringWithFormat:@"comgooglemaps://?daddr=%@", self.locations[indexPath.row][@"Location"]];
        } else {
            // open google map website
            url = [NSString stringWithFormat:@"http://maps.google.com/maps?daddr=%@", self.locations[indexPath.row][@"Location"]];
        }
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
        return [RACSignal empty];
    }];
    return cell;
}

@end
