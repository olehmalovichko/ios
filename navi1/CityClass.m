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

+ (CityClass *)cityWithId:(NSString *)identifier name:(NSString *)name {
    CityClass *city = [CityClass new];
    city.idCity = identifier;
    city.nameCity = name;
    return city;
}

- (BOOL)isEqual:(CityClass *)other {
    if ([self.idCity isEqualToString:other.idCity]) {
        return YES;
    } else {
        return NO;
    }
}



- (void)encodeWithCoder:(NSCoder *)encoder {
    //encode properties,variables, etc...
    [encoder encodeObject:self.nameCity forKey:@"nameCity"];
    [encoder encodeObject:self.idCity forKey:@"idCity"];
    [encoder encodeObject:self.tempCity forKey:@"tempCity"];
    [encoder encodeObject:self.dateTemp forKey:@"dateTemp"];
    [encoder encodeObject:self.weather forKey:@"weather"];
//    [encoder encodeObject:self.imageWeather forKey:@"imageWeather"];
    [encoder encodeObject:self.image forKey:@"image"];
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
//        self.imageWeather = [decoder decodeObjectForKey:@"imageWeather"];
        self.image = [decoder decodeObjectForKey:@"image"];
    }
    return self;
}



@end
