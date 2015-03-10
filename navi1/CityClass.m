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
    
    //http://api.openweathermap.org/data/2.5/weather?id=696050&units=metric&lang=ru
    
    NSString *sURL = [NSString stringWithFormat:@"http://api.openweathermap.org/data/2.5/weather?id=%@&units=metric&lang=en",self.idCity];
    
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
       
            NSArray *arweather = [dict objectForKey:@"weather"];
            self.weather = [NSString stringWithFormat:@"%@",[arweather valueForKey:@"description"]];
            NSLog(@"description:%@",self.weather);
            
            
            NSDate *date = [NSDate date];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init] ;
            [dateFormatter setDateStyle:NSDateFormatterLongStyle];
            [dateFormatter setDateFormat:@"dd MMM YYYY, hh:mm"];
            self.dateTemp = [dateFormatter stringFromDate:date];
            
            NSLog(@"%@  %@", self.nameCity,self.tempCity);
            
            //        NSLog(@"temp: %@",[mainDetails objectForKey:@"temp"]);
            //        NSLog(@"humidity: %@",[mainDetails objectForKey:@"humidity"]);
            //        NSLog(@"------");
            //        NSLog(@"city: %@",[dict objectForKey:@"name"]);
            //        NSLog(@"%@",[dict objectForKey:@"main"]);
            
        }
        
        
    } //if 
    
    return (0);
}



@end
