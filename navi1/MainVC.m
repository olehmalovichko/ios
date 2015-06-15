//
//  MainVC.m
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
#import "CityCell.h"

@interface MainVC ()

@property (weak, nonatomic) IBOutlet UITableView *tableCity;
@property (strong, nonatomic) NSArray *tableData;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;

// FIXME : должна быть strong. Разобраться что такое weak и strong
@property (weak, nonatomic) CityClass *citySelectClass; // FIXME правильно было бы назвать city или selectedCity

- (IBAction)UpdateWeather:(id)sender;

@end

@implementation MainVC


- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"---start---");
    NSLog(NSLocalizedString(@"weather", nil));
    
    //delete !!!
    self.tableData = [DataManager allCities];
    self.tableCity.dataSource = self;
    self.tableCity.delegate = self;
    
    
    // FIXME почему тестовый код не заремен?
    [DataManager requestWeatherForCityWithId:[NSNumber numberWithInt:704147] completion:^(CityClass *city, NSError *error) {
        NSLog(@"загрузка завершена");
        if (city) {
            //[DataManager addCity:city];
            [self.tableCity reloadData];
        }
    }];
    
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"showAddCity"]) {
        DetailVC *detailVC = segue.destinationViewController;
        detailVC.delegate = self;
    }
    
    if ([segue.identifier isEqualToString:@"showWeather"]) {
        WeatherCityVC *weatherCityVC = segue.destinationViewController;
        weatherCityVC.city = self.citySelectClass;
    }
    
    
}


#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"idCell";
    CityCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    CityClass *tclass = [self.tableData objectAtIndex:indexPath.row];
    cell.nameCity.text = [NSString stringWithFormat:@"%@",tclass.nameCity];
    cell.tempCity.text = [NSString stringWithFormat:@"%1.1f%@C",tclass.tempCity.floatValue ,@"\u00B0" ];
    
    NSLog(@"%@",cell.tempCity.text);
    
    [cell.imageCity sd_setImageWithURL:tclass.weatherIconURL completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [cell setNeedsLayout];
    }];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.35];
    
    return cell;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tableData.count;
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.citySelectClass = [self.tableData objectAtIndex:indexPath.row];
    
    [self performSegueWithIdentifier:@"showWeather" sender:self];
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

// FIXME функция должна быть с маленькой буквы
- (IBAction)UpdateWeather:(id)sender {
    NSLog(@"--update weather--");
    
    for (CityClass *city in self.tableData) {
         [DataManager getWeather:city];
        
//        [DataManager requestWeatherForCityWithId:cityy.idCity completion:^(CityClass *city, NSError *error) {
//            NSLog(@"загрузка завершена");
//            if (city) {
//                //[DataManager addCity:city];
//                [self.tableCity reloadData];
//            }
//        }];
        [DataManager cityUpdate:city];
    }
    
    //[self.tableCity reloadData];
    
    NSLog(@"--update complete--");
    
}

@end
