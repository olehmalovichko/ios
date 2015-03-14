//
//  CityClass.h
//  navi1
//
//  Created by admin on 09.03.15.
//  Copyright (c) 2015 admin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CityClass : NSObject

@property (nonatomic, strong) NSString *nameCity;
@property (nonatomic, strong) NSString *idCity;
@property (nonatomic, strong) NSString *tempCity;
@property (nonatomic, strong) NSString *dateTemp;
@property (nonatomic, strong) NSString *weather;
@property (nonatomic, strong) NSString *icon;
//@property (nonatomic, strong) NSData   *imageWeather;
@property (nonatomic, strong) UIImage *image; // FIXME пофиксить - fixed

- (BOOL)getWeather;

+ (CityClass *)cityWithId:(NSString *)identifier name:(NSString *)name;

@end
