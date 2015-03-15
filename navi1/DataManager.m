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
        
        [city1 getWeather];
        [city2 getWeather];
        [city3 getWeather];
        [city4 getWeather];
        
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

@end
