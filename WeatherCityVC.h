//
//  WeatherCityVC.h
//  navi1
//
//  Created by admin on 11.03.15.
//  Copyright (c) 2015 admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CityClass.h"

@interface WeatherCityVC : UIViewController

@property (strong, nonatomic) CityClass *city;

@property (weak, nonatomic) IBOutlet UILabel *labelCityName;
@property (weak, nonatomic) IBOutlet UILabel *labelTempCity;
@property (weak, nonatomic) IBOutlet UILabel *labelData;

@property (weak, nonatomic) IBOutlet UIImageView *imageWeather;
@property (weak, nonatomic) IBOutlet UILabel *labelWeather;


@end
