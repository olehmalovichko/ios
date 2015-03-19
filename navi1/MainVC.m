//
//  MainVC.m
//  navi1
//
//  Created by admin on 06.03.15.
//  Copyright (c) 2015 admin. All rights reserved.
//

#import "MainVC.h"
#import "WeatherCityVC.h"
#import "DataManager.h"
#import "CityClass.h"
#import "AppDelegate.h"
#import "DetailVC.h"
#import <SDWebImage/UIImageView+WebCache.h>


@interface MainVC () 


@property (weak, nonatomic) IBOutlet UITableView *tableCity;
@property (strong, nonatomic) NSArray *tableData;
//@property (nonatomic, strong) NSURLSessionDownloadTask *downloadTask;
- (IBAction)UpdateWeather:(id)sender;


@end

@implementation MainVC


- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"---start---");
    NSLog(NSLocalizedString(@"weather", nil));
    
    self.tableData = [DataManager allCities];
    self.tableCity.dataSource = self;
    self.tableCity.delegate = self;
    //DataManager.delegate = self;
    
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showAddCity"]) {
        DetailVC *detailVC = segue.destinationViewController;
        detailVC.delegate = self;
    }
}


#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    CityClass *tclass = [self.tableData objectAtIndex:indexPath.row];
                     
    
    cell.textLabel.text =  [NSString stringWithFormat:@"%@  %@%@C",tclass.nameCity,tclass.tempCity,@"\u00B0" ];
    
    //http://openweathermap.org/img/w/10d.png
    
    //cell.imageView.image = tclass.image;
    cell.imageView.contentMode = UIViewContentModeScaleAspectFill;
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://openweathermap.org/img/w/%@.png",tclass.icon]];
      NSLog(@"icon---:%@",tclass.icon);
    
    [cell.imageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"placeholder"] options:indexPath.row == 0 ? SDWebImageRefreshCached : 0];
    

    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tableData.count;
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    CityClass *cellCity = [self.tableData objectAtIndex:indexPath.row];
    
    WeatherCityVC *weatherCityVC = [self.storyboard instantiateViewControllerWithIdentifier:@"WeatherCityVC"];
    
    weatherCityVC.city = cellCity;
    
    NSLog(@"city: %@",cellCity.nameCity);
    [self showViewController:weatherCityVC sender:self];
    
    //[self.navigationController pushViewController:WeatherCityVC animated:YES];
    
    
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        //remove the deleted object from your data source.
        NSLog(@"remove row %li",(long)indexPath.row);
        
        [DataManager deleteCity:self.tableData[indexPath.row]];
        self.tableData = [DataManager allCities];
        [tableView  reloadData]; // tell table to refresh now
    }
}



#pragma mark reloadTable Data

-(void)reloadTableData {
  //  [self.table reloadData];
    NSLog(@"---reload delegat---");
    self.tableData = [DataManager allCities];
    [self.tableCity reloadData];
}


#pragma mark - updateWeather

- (IBAction)UpdateWeather:(id)sender {
    NSLog(@"--update weather--");
    
    for (CityClass *city in self.tableData) {
        CityClass *cityUpdate = city;
        [DataManager deleteCity:city];
        [DataManager getWeather:cityUpdate];
        [DataManager addCity:cityUpdate];
    }
    
    //self.tableData = [DataManager allCities];
    [self.tableCity reloadData];
}
@end
