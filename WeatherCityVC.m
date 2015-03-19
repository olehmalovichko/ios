//
//  WeatherCityVC.m
//  navi1
//
//  Created by admin on 11.03.15.
//  Copyright (c) 2015 admin. All rights reserved.
//

#import "WeatherCityVC.h"

@interface WeatherCityVC ()



@end

@implementation WeatherCityVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]];
    
    self.labelCityName.text = self.city.nameCity;
    self.labelTempCity.text = [NSString stringWithFormat:@"%@%@C", self.city.tempCity,@"\u00B0"];
    self.labelData.text = [NSString stringWithFormat:NSLocalizedString(@"updated: %@", nil),self.city.dateTemp];
    self.labelWeather.text = self.city.weather;
    self.imageWeather.image  = self.city.image;
    
    NSLog(@"city2: %@",self.city.nameCity);
    NSLog(@"temp2: %@",self.city.tempCity);
    NSLog(NSLocalizedString(@"weather", nil));
    
    // Do any additional setup after loading the view.
}


@end
