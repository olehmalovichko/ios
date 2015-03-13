//
//  DataManager.m
//  Weather
//
//  Created by admin on 12.03.15.
//  Copyright (c) 2015 admin. All rights reserved.
//

#import "DataManager.h"
#import "CityClass.h"


@implementation DataManager

//save my class
+(void)saveCustomObject:(CityClass *)object key:(NSString *)key {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSData *myEncodedObject = [NSKeyedArchiver archivedDataWithRootObject:object];
    [prefs setObject:myEncodedObject forKey:key];
    [prefs synchronize];   
}

//restore my class
+(CityClass *)loadcustomObjectWithKey:(NSString*)key {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSData *myEncodeObject = [prefs objectForKey:key];
    CityClass *obj = (CityClass *)[NSKeyedUnarchiver unarchiveObjectWithData:myEncodeObject];
    return obj;
}

+ (NSArray *)allCities {
    
    //    NSUserDefaults - почитать про него, должен хранить в нем все города
    /*
     1 проверяешь лежит ли в NSUSerDefault массив городов
     2 если не лежит, то добавляешь наши стандартные 4 города в него
     3 если что-то лежит в массиве, то просто возвращаем этот массив городов
     */
    CityClass *newCityClass1 = [CityClass new];
    CityClass *newCityClass2 = [CityClass new];
    CityClass *newCityClass3 = [CityClass new];
    CityClass *newCityClass4 = [CityClass new];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *result = [userDefaults objectForKey:@"city1"];
    if ([result length]) {
        NSLog(@"---second start---");
        newCityClass1 =  [DataManager loadcustomObjectWithKey:@"city1"];
        newCityClass2 =  [DataManager loadcustomObjectWithKey:@"city2"];
        newCityClass3 =  [DataManager loadcustomObjectWithKey:@"city3"];
        newCityClass4 =  [DataManager loadcustomObjectWithKey:@"city4"];
    } else {
        //add to UserDefaults
        NSLog(@"---first start---");
        //[userDefaults setObject:@"gorod" forKey:@"name"];
        
        newCityClass1.nameCity = @"Киев";
        newCityClass1.idCity=@"696050";
        [newCityClass1 getWeather];
        
        newCityClass2.nameCity = @"Харьков";
        newCityClass2.idCity=@"706483";
        [newCityClass2 getWeather];
   
        newCityClass3.nameCity = @"Днепропетровск";
        newCityClass3.idCity=@"709930";
        [newCityClass3 getWeather];
        
        newCityClass4.nameCity = @"Кременчуг";
        newCityClass4.idCity=@"704147";
        [newCityClass4 getWeather];
        
        [DataManager saveCustomObject:newCityClass1 key:@"city1"];
        [DataManager saveCustomObject:newCityClass2 key:@"city2"];
        [DataManager saveCustomObject:newCityClass3 key:@"city3"];
        [DataManager saveCustomObject:newCityClass4 key:@"city4"];
        
        //        NSLog(@"test name = %@",test.nameCity);
        //        NSLog(@"test idCity = %@",test.idCity);
        
    }
    
    
    
    return @[newCityClass1,newCityClass2,newCityClass3,newCityClass4];
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
