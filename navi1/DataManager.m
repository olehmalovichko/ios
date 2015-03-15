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


+ (NSArray *)arrayByRemovingObject:(id)obj val2:(NSUInteger)row {
  //  if (!obj) return [self copy]; // copy because all array* methods return new arrays
    NSMutableArray *mutableArray = [NSMutableArray arrayWithArray:obj];
    [mutableArray removeObjectAtIndex:row];
    return [NSArray arrayWithArray:mutableArray];
}

+ (BOOL)citiesExist {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSData *myEncodeObject = [prefs objectForKey:@"allCities"];
    NSArray *cities = (NSArray *)[NSKeyedUnarchiver unarchiveObjectWithData:myEncodeObject];
    return cities;
}

+ (NSArray *)allCities {
    
    //    NSUserDefaults - почитать про него, должен хранить в нем все города
    /*
     1 проверяешь лежит ли в NSUSerDefault массив городов
     2 если не лежит, то добавляешь наши стандартные 4 города в него
     3 если что-то лежит в массиве, то просто возвращаем этот массив городов
     */
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSData *myEncodeObject = [prefs objectForKey:@"allCities"];
    NSArray *cities = (NSArray *)[NSKeyedUnarchiver unarchiveObjectWithData:myEncodeObject];
   
    if (cities && cities.count) {
        return cities;
    } else {
        CityClass *newCityClass1 = [CityClass cityWithId:@"696050" name:@"Киев"] ;
        CityClass *newCityClass2 = [CityClass cityWithId:@"706483" name:@"Харьков"];
        CityClass *newCityClass3 = [CityClass cityWithId:@"709930" name:@"Днепропетровск"];
        CityClass *newCityClass4 = [CityClass cityWithId:@"704147" name:@"Кременчуг"];
        
        [newCityClass1 getWeather];
        [newCityClass2 getWeather];
        [newCityClass3 getWeather];
        [newCityClass4 getWeather];
        
        [self addCity:newCityClass1];
        [self addCity:newCityClass2];
        [self addCity:newCityClass3];
        [self addCity:newCityClass4];
        
        return @[newCityClass1, newCityClass2, newCityClass3, newCityClass4];
    }
}

//add City and save into NSUserDefaults
+ (void)addCity:(CityClass *)city {
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSData *myEncodeObject = [prefs objectForKey:@"allCities"];
    NSArray *cities = (NSArray *)[NSKeyedUnarchiver unarchiveObjectWithData:myEncodeObject];
    
    
    NSMutableArray *citiesm = [NSMutableArray arrayWithArray:cities];

    
//    if ([self citiesExist]) {
//        cities = [NSMutableArray arrayWithArray:[self allCities]];
//    } else {
//        cities = [NSMutableArray array];
//    }
    [citiesm addObject:city];

    NSData *myEncodedObject = [NSKeyedArchiver archivedDataWithRootObject:[NSArray arrayWithArray:citiesm]];
    [prefs setObject:myEncodedObject forKey:@"allCities"];
    [prefs synchronize];
}

+ (void)deleteCity:(CityClass *)city {
    // FIXME: удаление города реализовать!
    
    NSMutableArray *mutableArray = [NSMutableArray arrayWithArray:[self allCities]];
    [mutableArray removeObject:city];
     NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSData *myEncodedObject = [NSKeyedArchiver archivedDataWithRootObject:[NSArray arrayWithArray:mutableArray]];
    [prefs setObject:myEncodedObject forKey:@"allCities"];
    [prefs synchronize];

}

// get JSON data
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
