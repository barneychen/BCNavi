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

    self.name.delegate = self;
    self.location.delegate = self;
    
    UIButton *close = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width-50, 40, 30, 30)];
    [close setBackgroundImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
    close.imageView.contentMode = UIViewContentModeScaleAspectFit;
    close.tintColor = [UIColor whiteColor];
    close.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        [self dismissViewControllerAnimated:YES completion:nil];
        return [RACSignal empty];
    }];
    [self.view addSubview:close];
    
//    [self.navigationItem setTitle:@"ADD"];
//    
//    UIBarButtonItem *close = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"close"] style:UIBarButtonItemStyleDone target:nil action:nil];
//    close.tintColor = [UIColor blackColor];
//    close.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
//        [self dismissViewControllerAnimated:YES completion:nil];
//        return [RACSignal empty];
//    }];
//    self.navigationItem.rightBarButtonItem = close;
    
    self.addButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        
        NSDictionary *newLocation = @{@"Name" : self.name.text, @"Location" : self.location.text};
        [self.locations addObject:newLocation];
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"myLocations.plist"];
        
        BOOL b = [self.locations writeToFile:filePath atomically:YES];
        
        [self dismissViewControllerAnimated:YES completion:nil];
        
        return [RACSignal empty];
    }];
    
}


@end
