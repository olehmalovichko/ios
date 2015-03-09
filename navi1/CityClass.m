//
//  CityClass.m
//  navi1
//
//  Created by admin on 09.03.15.
//  Copyright (c) 2015 admin. All rights reserved.
//

#import "CityClass.h"

@implementation CityClass



- (BOOL)getWeather: (int)idcity{
    
    
    NSString *sURL = [NSString stringWithFormat:@"http://api.openweathermap.org/data/2.5/weather?id=%@&units=metric&lang=ru",self.idCity];
    NSData *allCoursesData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:sURL]];
    
    NSError *error;
    
    
    NSMutableDictionary *dict = [NSJSONSerialization
                                 JSONObjectWithData:allCoursesData
                                 options:NSJSONReadingMutableContainers
                                 error:&error];
    if( error ) {
        NSLog(@"%@", [error localizedDescription]);
    } else {
        //NSLog(@"%@", dict);
        //NSArray *keys = [dict allKeys];
        
        //        NSLog(@"city: %@",[dict objectForKey:@"name"]);
        //        NSLog(@"%@",[dict objectForKey:@"main"]);
        NSDictionary *mainDetails = [dict objectForKey:@"main"];
        //        NSLog(@"temp: %@",[mainDetails objectForKey:@"temp"]);
        //        NSLog(@"humidity: %@",[mainDetails objectForKey:@"humidity"]);
        //        NSLog(@"------");
        
        self.tempCity = [mainDetails objectForKey:@"temp"] ;
        NSLog(@"%@  %@", self.nameCity,self.tempCity);
    }
    
    
    
    return (0);
}



@end
