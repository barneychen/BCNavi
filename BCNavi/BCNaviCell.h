//
//  BCNaviCell.h
//  BCBrowser
//
//  Created by Barney Chen on 2014/12/8.
//  Copyright (c) 2014年 CWH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <SWTableViewCell.h>

@interface BCNaviCell : SWTableViewCell

@property (nonatomic, weak) IBOutlet UIButton *button;
@property (nonatomic, weak) IBOutlet UILabel *title;

@end
