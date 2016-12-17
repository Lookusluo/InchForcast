//
//  DailyTableController.m
//  JSONForcast
//
//  Created by Yazhong Luo on 12/12/16.
//  Copyright © 2016 Yazhong Luo. All rights reserved.
//

#import "DailyTableController.h"
#import "DailyTableCell.h"
@interface DailyTableController ()

@end

@implementation DailyTableController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    else
    return self.dailyDataAry.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
    DailyTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"summaryCell" forIndexPath:indexPath];
        NSDictionary *temp = [self.dailyDataAry objectAtIndex:0];
        cell.summary.text = [temp objectForKey:@"weekSummary"];
        return cell;
    }
    else{
    DailyTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DailyCell" forIndexPath:indexPath];
    NSDictionary *dailyDic = [self.dailyDataAry objectAtIndex:indexPath.row];
    
    NSString *tempMin = [NSString stringWithFormat:@"MIN  %ld˚",[[dailyDic objectForKey:@"temperatureMin"] integerValue] ];
    NSString *tempMax = [NSString stringWithFormat:@"MAX %ld˚",[[dailyDic objectForKey:@"temperatureMax"] integerValue] ];
    NSString *summary = [dailyDic objectForKey:@"summary"];
    NSString *icon = [dailyDic objectForKey:@"icon"];
    NSNumber *rawtime = [dailyDic objectForKey:@"time"];
    
    
    
    cell.timeValue.text = [self dateConverter:rawtime.doubleValue];
    cell.tempMax.text = tempMax;
    cell.tempMin.text = tempMin;
    cell.summary.text = summary;
    cell.dailyView.image = [UIImage imageNamed:icon];
        return cell;
    }

}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 28.0f;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 25)];
    [headerView setBackgroundColor:[UIColor lightGrayColor]];
    UILabel*textLabel = [[UILabel alloc]initWithFrame:CGRectMake(40, 5, 150, 25)];
    if(section==0){
        textLabel.text = @"Week Summary";
    }
    else{
        textLabel.text = @"Daily Detail";
    }
    [headerView addSubview:textLabel];
    return headerView;
}

-(NSString *)dateConverter:(double)rawtime{
    //Convert time and rewrite data
    NSDate* hourlydate = [NSDate dateWithTimeIntervalSince1970:rawtime];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar setTimeZone:[NSTimeZone timeZoneWithName:self.timezone]];
    NSDateComponents *timeComponents = [calendar components:(NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:hourlydate];
    NSString *timeStr = [NSString stringWithFormat:@"Date:%ld/%ld",(long)timeComponents.month,(long)timeComponents.day];
    return timeStr;
}

@end
