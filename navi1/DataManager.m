//
//  DataManager.m
//  Weather
//
//  Created by admin on 12.03.15.
//  Copyright (c) 2015 admin. All rights reserved.
//

#import "DataManager.h"

@implementation DataManager

+ (NSArray *)allCities {
    
//    NSUserDefaults - почитать про него, должен хранить в нем все города
    /*
     1 проверяешь лежит ли в NSUSerDefault массив городов
     2 если не лежит, то добавляешь наши стандартные 4 города в него
     3 если что-то лежит в массиве, то просто возвращаем этот массив городов
     */
    
    CityClass *newCityClass = [[CityClass alloc]init];
    newCityClass.nameCity = @"Киев";
    newCityClass.idCity=@"696050";
    [newCityClass getWeather];
    
    CityClass *newCityClass2 = [[CityClass alloc]init];
    newCityClass2.nameCity = @"Харьков";
    newCityClass2.idCity=@"706483";
    [newCityClass2 getWeather];
    
    CityClass *newCityClass3 = [[CityClass alloc]init];
    newCityClass3.nameCity = @"Днепропетровск";
    newCityClass3.idCity=@"709930";
    [newCityClass3 getWeather];
    
    CityClass *newCityClass4 = [CityClass new];
    newCityClass4.nameCity = @"Кременчуг";
    newCityClass4.idCity=@"704147";
    [newCityClass4 getWeather];
    
    return @[newCityClass,newCityClass2,newCityClass3,newCityClass4];
}

+ (void)addCity:(CityClass *)city {
    /*
     1 добавляем город в массив с помощью NSUserDefaults
     */
}

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
