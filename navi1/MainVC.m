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
#import "CityCell.h"

@interface MainVC () 


@property (weak, nonatomic) IBOutlet UITableView *tableCity;
@property (strong, nonatomic) NSArray *tableData;
//@property (nonatomic, strong) NSURLSessionDownloadTask *downloadTask;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;


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
    //DataManager.delegate = self;

//    self.backgroundImage.image = [UIImage imageNamed:@"background_city"];
//    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background_city"]];
//    self.tableCity.contentMode = UIViewContentModeScaleToFill;
//    self.tableCity.clipsToBounds= YES;
//    self.tableCity.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background_city"]];

    
    
    //self.tableCity.backgroundView = nil;
    //[[UIColor alloc] initWithWhite:1 alpha:0.0];
    //[UIColor clearColor];
    //self.tableCity.opaque = NO;
    //self.tableCity.backgroundColor =[UIColor clearColor];
    //UIImageView *imageview = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"background"]];
    //self.tableCity.opaque = NO;
    //self.tableCity.backgroundView = imageview;
    //self.tableCity.backgroundColor =[UIColor clearColor];
    
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
}


#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    //static NSString *simpleTableIdentifier = @"SimpleTableItem";
    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    static NSString *CellIdentifier = @"idCell";
    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    CityCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
//    if (cell == nil) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
//    }
    
    CityClass *tclass = [self.tableData objectAtIndex:indexPath.row];
    
    //cell.textLabel.text =  [NSString stringWithFormat:@"%@  %@%@C",tclass.nameCity,tclass.tempCity,@"\u00B0" ];
    
    cell.nameCity.text = [NSString stringWithFormat:@"%@",tclass.nameCity];
    cell.tempCity.text = [NSString stringWithFormat:@"%1.1f%@C",tclass.tempCity.floatValue ,@"\u00B0" ];
    //cell.tempCity.text = [NSString stringWithFormat:@"%@%@C",tclass.tempCity,@"\u00B0" ];
    
    NSLog(@"%@",cell.tempCity.text);
    //http://openweathermap.org/img/w/10d.png
    
//    cell.imageView.image = tclass.image;
    
    [cell.imageCity sd_setImageWithURL:tclass.weatherIconURL completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [cell setNeedsLayout];
    }];
    
//    cell.imageView.contentMode = UIViewContentModeScaleAspectFill;
//    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://openweathermap.org/img/w/%@.png",tclass.icon]];
//      NSLog(@"icon---:%@",tclass.icon);
//    
//    [cell.imageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"placeholder"] options:indexPath.row == 0 ? SDWebImageRefreshCached : 0];
//    

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
    // FIXME сделать переход через seague
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
    // FIXME 
    for (CityClass *city in self.tableData) {
        CityClass *cityUpdate = city;
        //[DataManager deleteCity:city];
        [DataManager getWeather:cityUpdate];
        //[DataManager addCity:cityUpdate];
    }
    
    //self.tableData = [DataManager allCities];
    [self.tableCity reloadData];
     NSLog(@"--update complete--");
}
@end
