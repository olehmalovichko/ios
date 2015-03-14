//
//  DataManager.h
//  Weather
//
//  Created by admin on 12.03.15.
//  Copyright (c) 2015 admin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CityClass.h"

@interface DataManager : NSObject

+ (NSArray *)allCities;
+ (void)addCity:(CityClass *)city;
+ (CityClass *)requestCityWithId:(NSString *)identifier;
+ (void)saveCustomObject:(CityClass *)object key:(NSString *)key;
+ (CityClass *)loadcustomObjectWithKey:(NSString*)key;

@end
