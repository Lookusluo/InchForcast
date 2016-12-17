//
//  DailyTableController.h
//  JSONForcast
//
//  Created by Yazhong Luo on 12/12/16.
//  Copyright © 2016 Yazhong Luo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DailyTableController : UITableViewController

@property(nonatomic,strong)NSMutableArray *dailyDataAry;
@property(nonatomic,strong)NSString *timezone;

@end
