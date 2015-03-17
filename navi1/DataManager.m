//
//  DataManager.m
//  Weather
//
//  Created by admin on 12.03.15.
//  Copyright (c) 2015 admin. All rights reserved.
//

#import "DataManager.h"
#import "CityClass.h"
#import "MainVC.h"


@implementation DataManager



// check city
+ (BOOL)citiesExist {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSData *myEncodeObject = [prefs objectForKey:@"allCities"];
    NSArray *cities = (NSArray *)[NSKeyedUnarchiver unarchiveObjectWithData:myEncodeObject];
    return cities;
}

#pragma mark allCities

//return array of cities
+ (NSArray *)allCities {
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSData *myEncodeObject = [prefs objectForKey:@"allCities"];
    NSArray *cities = (NSArray *)[NSKeyedUnarchiver unarchiveObjectWithData:myEncodeObject];
    
    if (cities && cities.count) {
        return cities;
    } else {
        CityClass *city1 = [CityClass cityWithId:@"696050" name:@"Киев"] ;
        CityClass *city2 = [CityClass cityWithId:@"706483" name:@"Харьков"];
        CityClass *city3 = [CityClass cityWithId:@"709930" name:@"Днепропетровск"];
        CityClass *city4 = [CityClass cityWithId:@"704147" name:@"Кременчуг"];
        
        [DataManager getWeather:city1];
        [DataManager getWeather:city2];
        [DataManager getWeather:city3];
        [DataManager getWeather:city4];
        
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
    
    NSData *myEncodedObject = [NSKeyedArchiver archivedDataWithRootObject:[NSArray arrayWithArray:citiesm]];
    [prefs setObject:myEncodedObject forKey:@"allCities"];
    [prefs synchronize];
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


#pragma mark requestCityWithId

// get city with id
+ (CityClass *)requestCityWithId:(NSString *)identifier {
    //http://api.openweathermap.org/data/2.5/weather?id=696050&units=metric&lang=ru
    
    NSString *url = [NSString stringWithFormat:@"http://api.openweathermap.org/data/2.5/weather?id=%@&units=metric&lang=ru", identifier];
    
    NSData *data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:url]];
    
    if (!data) {
        return nil;
    } else {
        NSError *error;
        NSMutableDictionary *dict = [NSJSONSerialization
                                     JSONObjectWithData:data
                                     options:NSJSONReadingMutableContainers
                                     error:&error];
        if (error) {
            NSLog(@"Error: %@", [error localizedDescription]);
            return nil;
        } else {
            NSLog(@"%@", dict);
            // FIXME: распарсить
            return [CityClass new];
        }
    }
}

#pragma mark getWeather

+ (BOOL)getWeather:(CityClass *)city {
    
    NSString *sURL = [NSString stringWithFormat:@"http://api.openweathermap.org/data/2.5/weather?id=%@&units=metric&lang=ru",city.idCity];
    
    NSData *allCoursesData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:sURL]];
    
    
    if (allCoursesData==nil) {
        NSLog(@"data=nil");
        city.tempCity = @"нет данных";
        
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
            
            
            //get icon
            NSString *ImageUrl = [NSString stringWithFormat:@"http://openweathermap.org/img/w/%@.png",city.icon];
            NSURL* url = [NSURL URLWithString:ImageUrl];
            //          self.imageWeather = [NSData dataWithContentsOfURL:url];
            NSData *imageData = [NSData dataWithContentsOfURL:url];
            city.image = [UIImage imageWithData:imageData];
            
        }
        
        
    } //if
    
    return NO;
}


@end
