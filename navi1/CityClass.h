//
//  CityClass.h
//  navi1
//
//  Created by admin on 09.03.15.
//  Copyright (c) 2015 admin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CityClass : NSObject

@property (nonatomic, strong) NSString *nameCity;
@property (nonatomic, strong) NSString *idCity;
@property (nonatomic, strong) NSString *tempCity;
@property (nonatomic, strong) NSString *dateTemp;
@property (nonatomic, strong) NSString *weather;

- (BOOL)getWeather: (int)idcity;

@end
