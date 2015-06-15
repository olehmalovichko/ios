//
//  DataManager.m
//
//  Created by admin on 12.03.15.
//  Copyright (c) 2015 admin. All rights reserved.
//

#import "DataManager.h"
#import "CityClass.h"
#import "MainVC.h"
#import  "AFNetworking.h"

@implementation DataManager


#pragma mark allCities

//return array of cities
+ (NSArray *)allCities {
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSData *myEncodeObject = [prefs objectForKey:@"allCities"];
    NSArray *cities = (NSArray *)[NSKeyedUnarchiver unarchiveObjectWithData:myEncodeObject];
    
    if (cities && cities.count) {
        return cities;
    } else {
        CityClass *city1 = [CityClass cityWithId:@696050 name:@"Киев"] ;
        CityClass *city2 = [CityClass cityWithId:@706483 name:@"Харьков"];
        CityClass *city3 = [CityClass cityWithId:@709930 name:@"Днепропетровск"];
        CityClass *city4 = [CityClass cityWithId:@704147 name:@"Кременчуг"];
        
        [DataManager getWeather:city1];
        [DataManager getWeather:city2];
        [DataManager getWeather:city3];
        [DataManager getWeather:city4];
        
//        [DataManager requestWeatherForCityWithId:city1.idCity completion:^(CityClass *city, NSError *error) {
//            NSLog(@"загрузка завершена");  }];
//        [DataManager requestWeatherForCityWithId:city2.idCity completion:^(CityClass *city, NSError *error) {
//            NSLog(@"загрузка завершена");  }];
//        [DataManager requestWeatherForCityWithId:city3.idCity completion:^(CityClass *city, NSError *error) {
//            NSLog(@"загрузка завершена");  }];
//        [DataManager requestWeatherForCityWithId:city4.idCity completion:^(CityClass *city, NSError *error) {
//            NSLog(@"загрузка завершена");  }];
        
        [self addCity:city1];
        [self addCity:city2];
        [self addCity:city3];
        [self addCity:city4];
        
        return @[city1, city2, city3, city4];
    }
}

#pragma mark addCity

//add City and save into NSUserDefaults
+ (void)addCity:(CityClass *)city {
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSData *myEncodeObject = [prefs objectForKey:@"allCities"];
    NSArray *cities = (NSArray *)[NSKeyedUnarchiver unarchiveObjectWithData:myEncodeObject];
    
    NSMutableArray *citiesm = [NSMutableArray arrayWithArray:cities];
    
    [citiesm addObject:city];
    //[DataManager getWeather:city];
    [DataManager requestWeatherForCityWithId:city.idCity completion:^(CityClass *city, NSError *error) {
        NSLog(@"загрузка завершена");  }];
    
    
    NSData *myEncodedObject = [NSKeyedArchiver archivedDataWithRootObject:[NSArray arrayWithArray:citiesm]];
    [prefs setObject:myEncodedObject forKey:@"allCities"];
    [prefs synchronize];
    
    [DataManager cityUpdate:city];
}

#pragma mark deleteCity

//delete city
+ (void)deleteCity:(CityClass *)city { 
    
    NSMutableArray *mutableArray = [NSMutableArray arrayWithArray:[self allCities]];
    [mutableArray removeObject:city];
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    NSData *myEncodedObject = [NSKeyedArchiver archivedDataWithRootObject:[NSArray arrayWithArray:mutableArray]];
    [prefs setObject:myEncodedObject forKey:@"allCities"];
    [prefs synchronize];
    
}



#pragma mark getWeather

+ (void)requestWeatherForCityWithId:(NSString *)identifier completion:(void (^)(CityClass *city , NSError *error))completion {
    
    NSURLRequest *request = [NSURLRequest requestWithURL: [CityClass weatherBaseURL:identifier]];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        CityClass *city = [CityClass cityWithDictionary:responseObject];
        // FIXME мы забыли сохранить новый город в NSUSerDefault
        completion(city, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(nil, error);
    }];
    
    [operation start];
}

+ (BOOL)getWeather:(CityClass *)city {
    
    NSString *sURL = [NSString stringWithFormat:@"http://api.openweathermap.org/data/2.5/weather?id=%@&units=metric&lang=ru",city.idCity];
    
    NSData *allCoursesData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:sURL]];
    
    if (allCoursesData==nil) {
        NSLog(@"data=nil");
        city.tempCity = @0;
        
    } else {
        
        NSError *error;
        NSMutableDictionary *dict = [NSJSONSerialization
                                     JSONObjectWithData:allCoursesData
                                     options:NSJSONReadingMutableContainers
                                     error:&error];
        
        if((error )) {
            NSLog(@"Error: %@", [error localizedDescription]);
        } else {
            NSLog(@"%@", dict);
            //NSArray *keys = [dict allKeys];
            
            NSDictionary *mainDetails = [dict objectForKey:@"main"];
            city.tempCity = [mainDetails objectForKey:@"temp"] ;
            
            NSArray *Weather = [dict objectForKey:@"weather"];
            NSDictionary *weather = Weather.lastObject;
            city.weather = weather[@"description"];
            city.icon = weather[@"icon"];
            
            NSLog(@"description:%@",city.weather);
            NSLog(@"icon:%@",city.icon);
            
            NSDate *date = [NSDate date];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init] ;
            [dateFormatter setDateStyle:NSDateFormatterLongStyle];
            [dateFormatter setDateFormat:@"dd MMM YYYY, hh:mm"];
            city.dateTemp = [dateFormatter stringFromDate:date];
            
            NSLog(@"%@  %@", city.nameCity,city.tempCity);

            
        }
        
        
    } //if
    
    return NO;
}

#pragma mark cityUpdate

+ (void)cityUpdate:(CityClass *)city {
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSData *myEncodeObject = [prefs objectForKey:@"allCities"];
    NSArray *cities = (NSArray *)[NSKeyedUnarchiver unarchiveObjectWithData:myEncodeObject];

    NSMutableArray *mutableArray = [NSMutableArray arrayWithArray:cities];
    
    NSUInteger indexCity = [mutableArray indexOfObject:city];
    [mutableArray replaceObjectAtIndex:indexCity withObject:city];
    
    NSData *myDecodeObject = [NSKeyedArchiver archivedDataWithRootObject:[NSArray arrayWithArray:mutableArray]];
    [prefs setObject:myDecodeObject forKey:@"allCities"];
    [prefs synchronize];
    
}
@end
