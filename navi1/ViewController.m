//
//  ViewController.m
//  navi1
//
//  Created by admin on 06.03.15.
//  Copyright (c) 2015 admin. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UILabel *labelTemperature;
@property (strong, nonatomic) NSArray *tableData;
@property (weak, nonatomic) IBOutlet UITableView *tableCity;

@end

@implementation ViewController {
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"start");
    
    CityClass *newCityClass = [[CityClass alloc]init];
 //   BOOL total = [newCityClass ExaminationCount:85];
    newCityClass.nameCity = @"Кременчуг!!!";
    
    NSLog(@"%@", newCityClass.nameCity);
    
    // Initialize table data
    // @["2", "3"];
    self.tableData = [NSArray arrayWithObjects:@"Киев", @"Харьков", @"Днепропетровск", @"Кременчуг",nil];
    self.tableCity.dataSource = self;
    self.tableCity.delegate = self;
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    cell.textLabel.text = [self.tableData objectAtIndex:indexPath.row];
    cell.imageView.image = [ UIImage imageNamed:@"weather.jpg"];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tableData.count;
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // self.selectedIndexPath = indexPath;
    //  [tableView reloadData];
    
    for (UITableViewCell *cell in [tableView visibleCells]) {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    //http://api.openweathermap.org/data/2.5/weather?id=704147
    NSData *allCoursesData = [[NSData alloc] initWithContentsOfURL:
                              [NSURL URLWithString:@"http://api.openweathermap.org/data/2.5/weather?id=704147&units=metric&lang=ru"]];
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
        
        NSLog(@"city: %@",[dict objectForKey:@"name"]);
        NSLog(@"%@",[dict objectForKey:@"main"]);
        
        
        NSDictionary *mainDetails = [dict objectForKey:@"main"];
        NSLog(@"temp: %@",[mainDetails objectForKey:@"temp"]);
        NSLog(@"humidity: %@",[mainDetails objectForKey:@"humidity"]);
        NSLog(@"------");
        self.labelTemperature.text = [NSString stringWithFormat:@"%@%@", mainDetails[@"temp"],@"\u00B0"];
    }
    
}

@end
