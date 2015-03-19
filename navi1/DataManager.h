//
//  DataManager.h
//  Weather
//
//  Created by admin on 12.03.15.
//  Copyright (c) 2015 admin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CityClass.h"


@protocol DataManagerVCDelegate <NSObject>
- (void)reloadTableData;
@end

@interface DataManager : NSObject
@property (nonatomic,weak) id <DataManagerVCDelegate> delegate;

+ (NSArray *)allCities;
+ (void)addCity:(CityClass *)city;
+ (void)deleteCity:(CityClass *)city;
+ (CityClass *)requestCityWithId:(NSString *)identifier;
+ (BOOL)getWeather:(CityClass *)city;


@end
