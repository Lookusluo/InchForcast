//
//  HourlyTableCell.h
//  JSONForcast
//
//  Created by Yazhong Luo on 12/12/16.
//  Copyright © 2016 Yazhong Luo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HourlyTableCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *timeValue;
@property (weak, nonatomic) IBOutlet UILabel *tempValue;
@property (weak, nonatomic) IBOutlet UILabel *icon;
@property (weak, nonatomic) IBOutlet UILabel *cloudCover;
@property (weak, nonatomic) IBOutlet UIImageView *hourlyView;

@end
