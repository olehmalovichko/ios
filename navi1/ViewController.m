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
#import "CityClass.h"

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
  
  
 
    //add button
//    UIButton *deletebtn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
//    [deletebtn setFrame:CGRectMake(0,9, 25, 25)];
//    deletebtn.tag=indexPath.row;
//    
//    UIImage *buttonImage = [UIImage imageNamed:@"delete.png"];
//    [deletebtn setBackgroundImage:buttonImage forState:UIControlStateNormal];
//    
    cell.imageView.image = tclass.image;
 //   cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
//[deletebtn setImage:[UIImage imageNamed:@"delete.png"] forState:UIControlStateNormal];
//    [deletebtn addTarget:self action:@selector(deleteRow:) forControlEvents:UIControlEventTouchUpInside];
//    [cell addSubview:deletebtn];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tableData.count;
}

- (IBAction)deleteRow:(id)sender
{
    NSLog(@"deleteRow---.");
//    // Remove the row from data model
//    //[self.tableData removeObjectAtIndex:indexPath.row];
//    //[self.tableData objectAtIndex:indexPath.row]
// //   CityClass *delCity [self.tableData objectAtIndex:indexPath.row];
//    NSArray *tempData = [DataManager arrayByRemovingObject:self.tableData];
//    // Request table view to reload
//    [self.tableCity reloadData];
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

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //remove the deleted object from your data source.
        NSLog(@"remove row %li",(long)indexPath.row);
//        NSArray *tempData = [DataManager arrayByRemovingObject:self.tableData val2:indexPath.row];
//        self.tableData = tempData;
        
        [DataManager deleteCity:self.tableData[indexPath.row]];
        self.tableData = [DataManager allCities];
        [tableView reloadData]; // tell table to refresh now
    }
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
