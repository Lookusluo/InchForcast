//
//  ViewController.m
//  JSONForcast
//
//  Created by Yazhong Luo on 12/12/16.
//  Copyright © 2016 Yazhong Luo. All rights reserved.
//

#import "ViewController.h"
#import "ForcastData.h"
#import "DailyTableController.h"
#import "HourlyTableController.h"
#import "UIImageView+GIF.h"

#define API @"62eae471d3f344f1abe66ffb25d6295d"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *startImageView;
@property (weak, nonatomic) IBOutlet UILabel *timezone;
@property (weak, nonatomic) IBOutlet UILabel *summary;
@property (weak, nonatomic) IBOutlet UILabel *updateDate;


@property (weak, nonatomic) IBOutlet UILabel *temperature;
@property (weak, nonatomic) IBOutlet UILabel *windSpeed;
@property (weak, nonatomic) IBOutlet UILabel *humidity;
@property (weak, nonatomic) IBOutlet UIProgressView *humidityBar;
@property (weak, nonatomic) IBOutlet UILabel *sunriseTime;
@property (weak, nonatomic) IBOutlet UILabel *sunsetTime;
@property (weak, nonatomic) IBOutlet UILabel *minTemp;//set CGRect
@property (weak, nonatomic) IBOutlet UILabel *maxTemp;//set CGRect
@property (weak, nonatomic) IBOutlet UILabel *minValue;
@property (weak, nonatomic) IBOutlet UILabel *maxValue;
@property (weak, nonatomic) IBOutlet UIImageView *iconGifView;
@property (weak, nonatomic) IBOutlet UIImageView *windMillGifView;

@property(nonatomic,readwrite)double longitude;
@property(nonatomic,readwrite)double latitude;
@property(nonatomic,strong)NSMutableDictionary *currentDataDic;
@property(nonatomic,strong)NSMutableArray *dailyDataArray;
@property(nonatomic,strong)NSMutableArray *hourlyDataArray;
@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];

}



- (IBAction)SearchByGPS:(UIBarButtonItem *)sender {
    UIAlertController *alarm = [UIAlertController alertControllerWithTitle:@"Location"
                                                                   message:@"Set Latitude and Longitude."
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {
                                                              NSString *inputLat = [alarm.textFields objectAtIndex:0].text;
                                                              NSString *inputLon = [alarm.textFields objectAtIndex:1].text;
                                                              self.latitude = [inputLat doubleValue];
                                                              self.longitude = [inputLon doubleValue];
                                                              
                                                              [UIView animateWithDuration:1.25 animations:^{
                                                                  self.startImageView.frame = CGRectMake(self.view.frame.size.width/2, 0, 0, 0);
                                                              }];
//                                                              self.startImageView.hidden = YES;

                                                              [self jsonDataImport];
                                                          }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * action) {
                                                             //Do nothing
                                                         }];
    [alarm addTextFieldWithConfigurationHandler:^(UITextField *_Nonnull textField){(
                                                                                    textField.placeholder = @"Latitude"),
                                                                                    ([textField setKeyboardType:UIKeyboardTypeNumbersAndPunctuation]
                                                                                    );
    }];
    [alarm addTextFieldWithConfigurationHandler:^(UITextField *_Nonnull textField){(
                                                                                    textField.placeholder = @"Longitude"),
                                                                                    ([textField setKeyboardType:UIKeyboardTypeNumbersAndPunctuation]
                                                                                    );
    }];
    
    [alarm addAction:defaultAction];
    [alarm addAction:cancelAction];
    [self presentViewController:alarm animated:YES completion:nil];
}

-(void)jsonDataImport{
    ForcastData *forecast = [[ForcastData alloc] initWithAPIKey:API];
    [forecast getCurrentConditionsForLatitude:self.latitude longitude:self.longitude success:^(NSMutableDictionary *responseDict) {
        //                                                                  NSLog(@"Main Controller %@",responseDict);
        self.currentDataDic = responseDict;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self updateUI];
            [self pickGifForICON];
        });
    } failure:^(NSError *error) {
        NSLog(@"Current %@",error.description);
    }];
    ForcastData *dailyforecast = [[ForcastData alloc] initWithAPIKey:API];
    [dailyforecast getDailyForcastForLatitude:self.latitude longitude:self.longitude success:^(NSMutableArray *responseDict) {
        NSLog(@"Main Controller daily are %@",responseDict);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self updateUI];
        });
        self.dailyDataArray = responseDict;
    } failure:^(NSError *error) {
        NSLog(@"Current %@",error.description);
    }];
    ForcastData *hourforecast = [[ForcastData alloc] initWithAPIKey:API];
    [hourforecast getHourlyForcastForLatitude:self.latitude longitude:self.longitude success:^(NSMutableArray *responseDict) {
        //                                                                  NSLog(@"Main controller horly are %@",responseDict);
        self.hourlyDataArray = responseDict;
    } failure:^(NSError *error) {
        NSLog(@"Current %@",error.description);
    }];
}

- (void)pickGifForICON
{
    // clear-day, clear-night, rain, snow, sleet, wind, fog, cloudy, partly-cloudy-day, or partly-cloudy-night.
    double windSpeed = [[self.currentDataDic objectForKey:@"windSpeed"]doubleValue];
    NSString *path1 = [[NSBundle mainBundle] pathForResource:@"windMill" ofType:@"gif"];
    [self.windMillGifView showGifImageWithData:[NSData dataWithContentsOfFile:path1] WithDuration:10/windSpeed];
    NSString *path2 = [[NSBundle mainBundle] pathForResource:[self.currentDataDic objectForKey:@"icon"] ofType:@"gif"];
    [self.iconGifView showGifImageWithData:[NSData dataWithContentsOfFile:path2]];
}

-(void)updateUI{
    
    self.timezone.text = [NSString stringWithFormat:@"%@",[self.currentDataDic objectForKey:@"timezone"]];
    self.temperature.text = [NSString stringWithFormat:@"%ld ˚F",[[self.currentDataDic objectForKey:@"temperature"] integerValue]];
    self.summary.text = [self.currentDataDic objectForKey:@"summary"];
    self.humidity.text = [NSString stringWithFormat:@"%.2f",[[self.currentDataDic objectForKey:@"humidity"] floatValue]];
    self.humidityBar.frame = CGRectMake(46, 389, 108, 20);
    [self.humidityBar setProgress:[[self.currentDataDic objectForKey:@"humidity"] floatValue] animated:YES];
    self.windSpeed.text = [NSString stringWithFormat:@"%@ mph",[self.currentDataDic objectForKey:@"windSpeed"]];
    NSDictionary *detailDic = [self.dailyDataArray objectAtIndex:0 ];
    self.sunriseTime.text = [detailDic objectForKey:@"sunriseTime"];
    self.sunsetTime.text = [detailDic objectForKey:@"sunsetTime"];
    float minTempValue = [[detailDic objectForKey:@"temperatureMin"] floatValue];
    float maxTempValue = [[detailDic objectForKey:@"temperatureMax"] floatValue];
    self.minValue.text = [NSString stringWithFormat:@"%.0f F",minTempValue];
    self.maxValue.text = [NSString stringWithFormat:@"%.0f F",maxTempValue];
    
    [UIView animateWithDuration:1 animations:^{
        self.minValue.frame = CGRectMake(7, 572 - minTempValue, 50, 15);
        self.minTemp.frame = CGRectMake(39, 595 - minTempValue, 40, minTempValue);
        self.maxValue.frame = CGRectMake(147, 572 - maxTempValue, 50, 15);
        self.maxTemp.frame = CGRectMake(109, 595 - maxTempValue, 40, maxTempValue);
    }];
    //updating timestamp with local current time
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"HH:mm a"];
    [formatter setTimeZone:[NSTimeZone timeZoneWithName:self.timezone.text]];
    NSDate * now = [NSDate date];
    self.updateDate.text = [NSString stringWithFormat:@"Local current time %@",[formatter stringFromDate:now]];
}



-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"toDailyForcast"]){
        DailyTableController *destinationVC = [segue destinationViewController];
        destinationVC.dailyDataAry = self.dailyDataArray;
        destinationVC.timezone = self.timezone.text;
    }
    else if ([segue.identifier isEqualToString:@"toHourlyForcast"]){
        HourlyTableController *destinationVC = [segue destinationViewController];
        destinationVC.gethourlyDataAry = self.hourlyDataArray;
        destinationVC.timezone = self.timezone.text;
    }
}

@end
