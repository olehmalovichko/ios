//
//  CityClass.m
//
//  Created by admin on 09.03.15.
//  Copyright (c) 2015 admin. All rights reserved.
//

#import "CityClass.h"
#import "DataManager.h"

@implementation CityClass

+ (CityClass *)cityWithId:(NSNumber *)identifier name:(NSString *)name {
    CityClass *city = [CityClass new];
    city.idCity = identifier;
    city.nameCity = name;
    return city;
}

- (BOOL)isEqual:(CityClass *)other {
    if ([self.idCity isEqual:other.idCity]) {
        return YES;
    } else {
        return NO;
    }
}

+ (CityClass *)cityWithDictionary:(NSDictionary *)dict {
    CityClass *city = [CityClass new];
    
    city.nameCity = dict[@"name"];
    city.idCity = dict[@"id"];
    
    NSDictionary *mainDetails = [dict objectForKey:@"main"];
    city.tempCity = [mainDetails objectForKey:@"temp"] ;
    
    NSArray *Weather = [dict objectForKey:@"weather"];
    NSDictionary *weather = Weather.lastObject;
    city.weather = weather[@"description"];
    city.icon = weather[@"icon"];
    
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterLongStyle];
    [dateFormatter setDateFormat:@"dd MMM YYYY, hh:mm"];
    city.dateTemp = [dateFormatter stringFromDate:date];
    
    NSLog(@"---city:%@  t=%@", city.nameCity,city.tempCity);
    NSLog(@"---description:%@",city.weather);
    NSLog(@"---icon:%@",city.icon);
    
    return city;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    //encode properties,variables, etc...
    [encoder encodeObject:self.nameCity forKey:@"nameCity"];
    [encoder encodeObject:self.idCity forKey:@"idCity"];
    [encoder encodeObject:self.tempCity forKey:@"tempCity"];
    [encoder encodeObject:self.dateTemp forKey:@"dateTemp"];
    [encoder encodeObject:self.weather forKey:@"weather"];
    [encoder encodeObject:self.icon forKey:@"icon"];
    
}

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    if (self) {
        //decode properties,variables,etc....
        self.nameCity = [decoder decodeObjectForKey:@"nameCity"];
        self.idCity = [decoder decodeObjectForKey:@"idCity"];
        self.tempCity = [decoder decodeObjectForKey:@"tempCity"];
        self.dateTemp = [decoder decodeObjectForKey:@"dateTemp"];
        self.weather = [decoder decodeObjectForKey:@"weather"];
        self.icon = [decoder decodeObjectForKey:@"icon"];
    }
    return self;
}

- (NSURL *)weatherIconURL {
    return [NSURL URLWithString:[NSString stringWithFormat:@"http://openweathermap.org/img/w/%@.png", self.icon]];
}

+ (NSURL *)weatherBaseURL:(NSString *)idCity {
    NSLog(@"%@",[NSString stringWithFormat:@"http://api.openweathermap.org/data/2.5/weather?id=%@&units=metric&lang=ru", idCity]);
    
    return [NSURL URLWithString:[NSString stringWithFormat:@"http://api.openweathermap.org/data/2.5/weather?id=%@&units=metric&lang=ru",idCity]];
}

@end
