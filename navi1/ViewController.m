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
@property (weak, nonatomic) IBOutlet UILabel *labelDate;
@property (strong, nonatomic) NSArray *tableData;
@property (weak, nonatomic) IBOutlet UITableView *tableCity;


@end

@implementation ViewController {
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"start");
    
    
    
    CityClass *newCityClass = [[CityClass alloc]init];
    newCityClass.nameCity = @"Киев";
    newCityClass.idCity=@"696050";
    [ newCityClass getWeather:0];
    
    CityClass *newCityClass2 = [[CityClass alloc]init];
    newCityClass2.nameCity = @"Харьков";
    newCityClass2.idCity=@"706483";
    [ newCityClass2 getWeather:0];
    
    CityClass *newCityClass3 = [[CityClass alloc]init];
    newCityClass3.nameCity = @"Днепропетровск";
    newCityClass3.idCity=@"709930";
    [ newCityClass3 getWeather:0];
    
    CityClass *newCityClass4 = [[CityClass alloc]init];
    newCityClass4.nameCity = @"Кременчуг";
    newCityClass4.idCity=@"704147";
    [ newCityClass4 getWeather:0];

  
 
    
    // Initialize table data
    //    self.tableData = [NSArray arrayWithObjects:@"Киев", @"Харьков", @"Днепропетровск", @"Кременчуг",nil];
    self.tableData = @[newCityClass,newCityClass2,newCityClass3,newCityClass4];
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
    
    //    cell.textLabel.text = [self.tableData objectAtIndex:indexPath.row];
    CityClass *tclass = [self.tableData objectAtIndex:indexPath.row];
    [ tclass getWeather:0];
    cell.textLabel.text =  [NSString stringWithFormat:@"%@  %@%@C",tclass.nameCity,tclass.tempCity,@"\u00B0" ];
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
    
    CityClass *tclass = [self.tableData objectAtIndex:indexPath.row];
    //[ tclass getWeather:0]; //get weather
    self.labelTemperature.text = [NSString stringWithFormat:@"%@%@C",tclass.tempCity,@"\u00B0"];
    self.labelDate.text = tclass.dateTemp;
    
}

@end
