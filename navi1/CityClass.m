//
//  CityClass.m
//  navi1
//
//  Created by admin on 09.03.15.
//  Copyright (c) 2015 admin. All rights reserved.
//

#import "CityClass.h"
#import "DataManager.h"

@implementation CityClass


- (void)encodeWithCoder:(NSCoder *)encoder {
    //encode properties,variables, etc...
    [encoder encodeObject:self.nameCity forKey:@"nameCity"];
    [encoder encodeObject:self.idCity forKey:@"idCity"];
    [encoder encodeObject:self.tempCity forKey:@"tempCity"];
    [encoder encodeObject:self.dateTemp forKey:@"dateTemp"];
    [encoder encodeObject:self.weather forKey:@"weather"];
    [encoder encodeObject:self.imageWeather forKey:@"imageWeather"];
    [encoder encodeObject:self.image forKey:@"image"];
    [encoder encodeObject:self.icon forKey:@"icon"];
    
}

- (id)initWithCoder:(NSCoder *)decoder {
    if((self = [super init])) {
        //decode properties,variables,etc....
        self.nameCity = [decoder decodeObjectForKey:@"nameCity"];
        self.idCity = [decoder decodeObjectForKey:@"idCity"];
        self.tempCity = [decoder decodeObjectForKey:@"tempCity"];
        self.dateTemp = [decoder decodeObjectForKey:@"dateTemp"];
        self.weather = [decoder decodeObjectForKey:@"weather"];
        self.imageWeather = [decoder decodeObjectForKey:@"imageWeather"];
        self.image = [decoder decodeObjectForKey:@"image"];
    }
    return self;
}

- (BOOL)getWeather {
    
    NSString *sURL = [NSString stringWithFormat:@"http://api.openweathermap.org/data/2.5/weather?id=%@&units=metric&lang=ru",self.idCity];
    
    NSData *allCoursesData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:sURL]];
    
    
    if (allCoursesData==nil) {
        NSLog(@"data=nil");
        
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
            self.tempCity = [mainDetails objectForKey:@"temp"] ;
            
            NSArray *Weather = [dict objectForKey:@"weather"];
            NSDictionary *weather = Weather.lastObject;
            self.weather = weather[@"description"];
            self.icon = weather[@"icon"];
            
            NSLog(@"description:%@",self.weather);
            NSLog(@"icon:%@",self.icon);
            
            NSDate *date = [NSDate date];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init] ;
            [dateFormatter setDateStyle:NSDateFormatterLongStyle];
            [dateFormatter setDateFormat:@"dd MMM YYYY, hh:mm"];
            self.dateTemp = [dateFormatter stringFromDate:date];
            
            NSLog(@"%@  %@", self.nameCity,self.tempCity);
            
            
            
            NSString *ImageUrl = [NSString stringWithFormat:@"http://openweathermap.org/img/w/%@.png",self.icon];
            NSURL* url = [NSURL URLWithString:ImageUrl];
            self.imageWeather = [NSData dataWithContentsOfURL:url];
            
            //        NSLog(@"temp: %@",[mainDetails objectForKey:@"temp"]);
            //        NSLog(@"humidity: %@",[mainDetails objectForKey:@"humidity"]);
            //        NSLog(@"------");
            //        NSLog(@"city: %@",[dict objectForKey:@"name"]);
            //        NSLog(@"%@",[dict objectForKey:@"main"]);
            
        }
        
        
    } //if
    
    return NO;
}



@end
