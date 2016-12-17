//
//  HourlyTableController.m
//  JSONForcast
//
//  Created by Yazhong Luo on 12/12/16.
//  Copyright © 2016 Yazhong Luo. All rights reserved.
//

#import "HourlyTableController.h"
#import "HourlyTableCell.h"
@interface HourlyTableController ()
@property(nonatomic,strong)NSDate* time;
@end

@implementation HourlyTableController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    NSLog(@"hourly data is here %@",self.gethourlyDataAry);

}

- (void)viewDidLoad {
    [super viewDidLoad];

}


#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.gethourlyDataAry.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HourlyTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HourlyCell" forIndexPath:indexPath];
    NSDictionary *hourlyDic = [self.gethourlyDataAry objectAtIndex:indexPath.row];
    
    NSString *temp = [NSString stringWithFormat:@"%ld ˚F",[[hourlyDic objectForKey:@"temperature"] integerValue] ];
    NSString *cloudCover = [NSString stringWithFormat:@"Cloud Cover %.2f",[[hourlyDic objectForKey:@"cloudCover"]floatValue]];
    NSNumber *rawtime = [hourlyDic objectForKey:@"time"];
    
    cell.icon.text = [hourlyDic objectForKey:@"icon"];
    cell.tempValue.text = temp;
    cell.timeValue.text =  [self dateConverter:rawtime.doubleValue];
    cell.cloudCover.text = cloudCover;
    cell.hourlyView.image = [UIImage imageNamed:cell.icon.text];
    
    return cell;
}

-(NSString *)dateConverter:(double)rawtime{
    //Convert time and rewrite data
    NSDate* hourlydate = [NSDate dateWithTimeIntervalSince1970:rawtime];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar setTimeZone:[NSTimeZone timeZoneWithName:self.timezone]];
    NSDateComponents *timeComponents = [calendar components:(NSCalendarUnitHour) fromDate:hourlydate];
    NSString *timeStr = [NSString stringWithFormat:@"Time:%ld:00",(long)timeComponents.hour];
    return timeStr;
}

@end
