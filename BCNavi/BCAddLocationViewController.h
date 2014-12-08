//
//  BCAddLocationViewController.h
//  BCBrowser
//
//  Created by Barney Chen on 2014/12/8.
//  Copyright (c) 2014年 CWH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BCAddLocationViewController : UIViewController <UITextFieldDelegate>

@property (nonatomic, weak) IBOutlet UIButton *addButton;
@property (nonatomic, weak) IBOutlet UITextField *name;
@property (nonatomic, weak) IBOutlet UITextField *location;

@property (nonatomic, strong) NSMutableArray *locations;

@end
