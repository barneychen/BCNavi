//
//  BCAddLocationViewController.m
//  BCBrowser
//
//  Created by Barney Chen on 2014/12/8.
//  Copyright (c) 2014年 CWH. All rights reserved.
//

#import "BCAddLocationViewController.h"
#import "BCNaviViewController.h"
#import <ReactiveCocoa.h>

@implementation BCAddLocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.locations = [[NSMutableArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Locations" ofType:@"plist"]];
    self.name.delegate = self;
    self.location.delegate = self;
    
    [self.navigationItem setTitle:@"ADD"];
    
    UIBarButtonItem *close = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"close"] style:UIBarButtonItemStyleDone target:nil action:nil];
    close.tintColor = [UIColor blackColor];
    close.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        [self dismissViewControllerAnimated:YES completion:nil];
        return [RACSignal empty];
    }];
    self.navigationItem.rightBarButtonItem = close;
    
    self.addButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        
        NSDictionary *newLocation = @{@"Name" : self.name.text, @"Location" : self.location.text};
        [self.locations addObject:newLocation];
        
        NSString *path = [[NSBundle mainBundle] pathForResource:@"Locations" ofType:@"plist"];
        [self.locations writeToFile:path atomically:YES];
        
        BCNaviViewController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"BCNaviViewController"];
        
        [self.navigationController pushViewController:vc animated:YES];
        
        return [RACSignal empty];
    }];
}


@end
