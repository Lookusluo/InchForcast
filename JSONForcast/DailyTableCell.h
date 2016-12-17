//
//  DailyTableCell.h
//  JSONForcast
//
//  Created by Yazhong Luo on 12/12/16.
//  Copyright © 2016 Yazhong Luo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DailyTableCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *summary;
@property (weak, nonatomic) IBOutlet UILabel *timeValue;
@property (weak, nonatomic) IBOutlet UILabel *tempMin;
@property (weak, nonatomic) IBOutlet UILabel *tempMax;
@property (weak, nonatomic) IBOutlet UIImageView *dailyView;

@end
