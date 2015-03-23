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


// check city
+ (BOOL)citiesExist { // FIXME: метод не нужен
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
+ (void)deleteCity:(CityClass *)city { // FIXME: нужно пофиксить удаление города
    
    NSMutableArray *mutableArray = [NSMutableArray arrayWithArray:[self allCities]];
    [mutableArray removeObject:city];
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSData *myEncodedObject = [NSKeyedArchiver archivedDataWithRootObject:[NSArray arrayWithArray:mutableArray]];
    [prefs setObject:myEncodedObject forKey:@"allCities"];
    [prefs synchronize];
    
}


#pragma mark requestCityWithId
//
//// get city with id
//+ (CityClass *)requestCityWithId:(NSString *)identifier {
//    
//    //http://api.openweathermap.org/data/2.5/weather?id=696050&units=metric&lang=ru
//    //NSString *url = [NSString stringWithFormat:@"http://api.openweathermap.org/data/2.5/weather?id=%@&units=metric&lang=ru", identifier];
//   // NSData *data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:url]];
//   NSData  *data = [[NSData alloc] initWithContentsOfURL:[CityClass weatherBaseURL:identifier] ];
//    
//    
//    if (!data) {
//        return nil;
//    } else {
//        NSError *error;
//        NSMutableDictionary *dict = [NSJSONSerialization
//                                     JSONObjectWithData:data
//                                     options:NSJSONReadingMutableContainers
//                                     error:&error];
//        if (error) {
//            NSLog(@"Error: %@", [error localizedDescription]);
//            return nil;
//        } else {
//            NSLog(@"%@", dict);
//            // FIXME: распарсить
//            return [CityClass new];
//        }
//    }
//}

#pragma mark getWeather

+ (void)requestWeatherForCityWithId:(NSString *)identifier completion:(void (^)(CityClass *city , NSError *error))completion {
    
    //NSString *baseURL = [NSString stringWithFormat:@"http://api.openweathermap.org/data/2.5/weather?id=%@&units=metric&lang=ru",identifier];
    //NSURL *url = [NSURL URLWithString:baseURL];
  
    //NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLRequest *request = [NSURLRequest requestWithURL: [CityClass weatherBaseURL:identifier]];

    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];

    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        CityClass *city = [CityClass cityWithDictionary:responseObject];
        completion(city, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(nil, error);
    }];
    
    [operation start];
}

+ (BOOL)getWeather:(CityClass *)city {
    
    
    //----------------------------------
//    
//    NSString *baseURL = [NSString stringWithFormat:@"http://api.openweathermap.org/data/2.5/weather?id=%@&units=metric&lang=ru",city.idCity];
//    //NSString *string = [NSString stringWithFormat:@"%@weather.php?format=json", baseURL];
//    NSURL *url = [NSURL URLWithString:baseURL];
//    NSURLRequest *request = [NSURLRequest requestWithURL:url];
//    
//    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
//    operation.responseSerializer = [AFJSONResponseSerializer serializer];
//    
//    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSDictionary *mainDic = (NSDictionary *)responseObject;
//        NSDictionary *mainDetails = [mainDic objectForKey:@"main"];
//        city.tempCity = [mainDetails objectForKey:@"temp"] ;
//        
//        NSArray *Weather = [mainDic objectForKey:@"weather"];
//        NSDictionary *weather = Weather.lastObject;
//        city.weather = weather[@"description"];
//        city.icon = weather[@"icon"];
//      
//        NSDate *date = [NSDate date];
//        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init] ;
//        [dateFormatter setDateStyle:NSDateFormatterLongStyle];
//        [dateFormatter setDateFormat:@"dd MMM YYYY, hh:mm"];
//        city.dateTemp = [dateFormatter stringFromDate:date];
//        
//        NSLog(@"-------------------");
//        NSLog(@"city:%@", city.nameCity);
//        NSLog(@"temp:%@", city.tempCity);
//        NSLog(@"description:%@",city.weather);
//        NSLog(@"icon:%@",city.icon);
//        NSLog(@"-------------------");
//        //get icon
//        NSString *ImageUrl = [NSString stringWithFormat:@"http://openweathermap.org/img/w/%@.png",city.icon];
//        NSURL* url = [NSURL URLWithString:ImageUrl];
//        //          self.imageWeather = [NSData dataWithContentsOfURL:url];
//        NSData *imageData = [NSData dataWithContentsOfURL:url];
//        city.image = [UIImage imageWithData:imageData];
//
//        
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error Retrieving Weather"
//                                                            message:[error localizedDescription]
//                                                           delegate:nil
//                                                  cancelButtonTitle:@"Ok"
//                                                  otherButtonTitles:nil];
//        [alertView show];
//        
//    }];
//    
//    [operation start];
    
    
    
    //----------------------------------
    
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
//                NSString *ImageUrl = [NSString stringWithFormat:@"http://openweathermap.org/img/w/%@.png",city.icon];
//                NSURL* url = [NSURL URLWithString:ImageUrl];
//                //          self.imageWeather = [NSData dataWithContentsOfURL:url];
//                NSData *imageData = [NSData dataWithContentsOfURL:url];
//                city.image = [UIImage imageWithData:imageData];
                
            }
            
            
        } //if
    
    return NO;
}


@end
