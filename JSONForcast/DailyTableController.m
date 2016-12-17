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

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dailyDataAry.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DailyTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DailyCell" forIndexPath:indexPath];
    
    NSDictionary *dailyDic = [self.dailyDataAry objectAtIndex:indexPath.row];
    
    NSString *tempMin = [NSString stringWithFormat:@"MIN %ld˚",[[dailyDic objectForKey:@"temperatureMin"] integerValue] ];
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

-(NSString *)dateConverter:(double)rawtime{
    //Convert time and rewrite data
    NSDate* hourlydate = [NSDate dateWithTimeIntervalSince1970:rawtime];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar setTimeZone:[NSTimeZone timeZoneWithName:self.timezone]];
    NSDateComponents *timeComponents = [calendar components:(NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:hourlydate];
    NSString *timeStr = [NSString stringWithFormat:@"Date:%ld/%ld",(long)timeComponents.month,(long)timeComponents.day];
    return timeStr;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
