//
//  ViewController.m
//  navi1
//
//  Created by admin on 06.03.15.
//  Copyright (c) 2015 admin. All rights reserved.
//

#import "ViewController.h"
#import "WeatherCityVC.h"
#import "DataManager.h"

@interface ViewController ()


@property (weak, nonatomic) IBOutlet UITableView *tableCity;
@property (strong, nonatomic) NSArray *tableData;


@end

@implementation ViewController {
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"---start---");
    
    self.tableData = [DataManager allCities];
    
    self.tableCity.dataSource = self;
    self.tableCity.delegate = self;
    
    
    //    [DataManager  saveCustomObject:newCityClass1 key:@"city1"];
    //    CityClass *test =  [DataManager loadcustomObjectWithKey:@"city1"];
    
    
    
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    //    cell.textLabel.text = [self.tableData objectAtIndex:indexPath.row];
    CityClass *tclass = [self.tableData objectAtIndex:indexPath.row];
    
    //   [tclass getWeather];
    
    cell.textLabel.text =  [NSString stringWithFormat:@"%@  %@%@C",tclass.nameCity,tclass.tempCity,@"\u00B0" ];
    
    //http://openweathermap.org/img/w/10d.png
    //    NSString *ImageUrl = [NSString stringWithFormat:@"http://openweathermap.org/img/w/%@.png",tclass.icon];
    //    NSURL* url = [NSURL URLWithString:ImageUrl];
    //    NSData* data = [NSData dataWithContentsOfURL:url];
    //cell.imageView.image = [ UIImage imageNamed:@"weather.jpg"];
    //cell.imageView.image = [UIImage imageWithData:data];
    
    //cell.imageView.image = [UIImage imageWithData:tclass.imageWeather];
    cell.imageView.image = tclass.image;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tableData.count;
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // self.selectedIndexPath = indexPath;
    //  [tableView reloadData];
    
    //    for (UITableViewCell *cell in [tableView visibleCells]) {
    //        cell.accessoryType = UITableViewCellAccessoryNone;
    //    }
    //
    //    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    //    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    CityClass *tclass = [self.tableData objectAtIndex:indexPath.row];
    //[ tclass getWeather:0]; //get weather
    //    self.labelTemperature.text = [NSString stringWithFormat:@"%@%@C",tclass.tempCity,@"\u00B0"];
    //    self.labelDate.text = tclass.dateTemp;
    //    self.labelWeather.text  = tclass.weather;
    //
    //        [self performSegueWithIdentifier:@"showDetails" sender:self];
    
    UIStoryboard *storyBoard = [self storyboard];
    WeatherCityVC *weatherCityVC = [storyBoard instantiateViewControllerWithIdentifier:@"WeatherCityVC"];
    //
    //weatherCityVC.labelCityName.text  = @"7777";
    //    weatherCityVC.CityName = tclass.nameCity;
    //    weatherCityVC.labelCityName.text = tclass.nameCity;
    weatherCityVC.city = tclass;
    
    NSLog(@"city: %@",tclass.nameCity);
    [self showViewController:weatherCityVC sender:self];
    
    //    [self.navigationController pushViewController:WeatherCityVC animated:YES];
    
}

- (IBAction)updateWeather:(id)sender {
    NSLog(@"update weather");
    
    //self.tableData
    
//    for(int i=0; i<self.tableData.count; i++){
//        [self.tableData[i] getWeather] ;
//    }
    
    for (CityClass *city in self.tableData) {
        [city getWeather];
    }
    
//    self.tableCity.reloadData;
    [self.tableCity reloadData];
}

@end
