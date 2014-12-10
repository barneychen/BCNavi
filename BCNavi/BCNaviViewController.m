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
#import <SWTableViewCell.h>

@interface BCNaviViewController()

@property (nonatomic, strong) NSMutableArray *locations;

@end


@implementation BCNaviViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 80)];

    UIButton *add = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width-50, 40, 30, 30)];
    [add setBackgroundImage:[UIImage imageNamed:@"plus"] forState:UIControlStateNormal];
    add.imageView.contentMode = UIViewContentModeScaleAspectFit;
    add.tintColor = [UIColor whiteColor];
    add.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        BCAddLocationViewController *addVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"BCAddLocationViewController"];
        addVC.locations = [[NSMutableArray alloc] initWithArray:self.locations];
        [self presentViewController:addVC animated:YES completion:nil];
        return [RACSignal empty];
    }];
    [self.tableView.tableHeaderView addSubview:add];
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"myLocations.plist"];
    self.locations = [[NSMutableArray alloc] initWithContentsOfFile:filePath];
    if (!self.locations) {
        self.locations = [[NSMutableArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Locations" ofType:@"plist"]];
    }
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.locations.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BCNaviCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BCNaviCell"];
    cell.title.text = self.locations[indexPath.row][@"Name"];
//    cell.title.textColor = [UIColor whiteColor];
    
//    UIImage *btnImage = [UIImage imageNamed:@"Image1"];
//    [cell.button setBackgroundImage:btnImage forState:UIControlStateNormal];
    cell.button.backgroundColor = [UIColor whiteColor];
    cell.button.layer.cornerRadius = 2.0;
//    cell.button.imageView.contentMode = UIViewContentModeCenter;
    
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
    
    cell.rightUtilityButtons = [self rightButtons];
    cell.delegate = self;
    return cell;
}

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index {
    switch (index) {
        case 0: {
            NSIndexPath *cellIndexPath = [self.tableView indexPathForCell:cell];
            [self.locations removeObjectAtIndex:index];
            
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documentsDirectory = [paths objectAtIndex:0];
            NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"myLocations.plist"];
            
            BOOL b = [self.locations writeToFile:filePath atomically:YES];
            [self.tableView deleteRowsAtIndexPaths:@[cellIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        }
        default:
            break;
    }
}

- (NSArray *)rightButtons
{
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    [rightUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:1.0f green:0.231f blue:0.188 alpha:1.0f] title:@"Delete"];
    
    return rightUtilityButtons;
}

@end
