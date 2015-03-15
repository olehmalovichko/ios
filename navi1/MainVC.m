//
//  ViewController.m
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

@interface MainVC ()


@property (weak, nonatomic) IBOutlet UITableView *tableCity;
@property (strong, nonatomic) NSArray *tableData;
@property (nonatomic, strong) NSURLSessionDownloadTask *downloadTask;

@end

@implementation MainVC {
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"---start---");
    
    [self backgroundSession];
    
    self.tableData = [DataManager allCities];
    
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
    
    CityClass *tclass = [self.tableData objectAtIndex:indexPath.row];
    
    cell.textLabel.text =  [NSString stringWithFormat:@"%@  %@%@C",tclass.nameCity,tclass.tempCity,@"\u00B0" ];
    
    //http://openweathermap.org/img/w/10d.png
    
    cell.imageView.image = tclass.image;
    //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
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

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //remove the deleted object from your data source.
        NSLog(@"remove row %li",(long)indexPath.row);
        
        [DataManager deleteCity:self.tableData[indexPath.row]];
        self.tableData = [DataManager allCities];
        [tableView reloadData]; // tell table to refresh now
    }
}

#pragma mark - updateWeather

- (IBAction)updateWeather:(id)sender {
    NSLog(@"update weather");
    
    for (CityClass *city in self.tableData) {
        [city getWeather];
    }
    
    [self.tableCity reloadData];
}




- (NSURLSession *)backgroundSession{
    static NSURLSession *session = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSLog(@"create new session");
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration backgroundSessionConfiguration:@"com.dev.BackgroundDownloadTest.BackgroundSession"];
        [config setAllowsCellularAccess:YES];
        session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:nil];
    });
    return session;
}



- (void)callCompletionHandlerIfFinished
{
    NSLog(@"call completion handler");
    [[self backgroundSession] getTasksWithCompletionHandler:^(NSArray *dataTasks, NSArray *uploadTasks, NSArray *downloadTasks) {
        NSUInteger count = [dataTasks count] + [uploadTasks count] + [downloadTasks count];
        if (count == 0) {
            NSLog(@"all tasks ended");
            AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
            if (appDelegate.backgroundSessionCompletionHandler == nil) return;
            
            void (^comletionHandler)() = appDelegate.backgroundSessionCompletionHandler;
            appDelegate.backgroundSessionCompletionHandler = nil;
            comletionHandler();
        }
    }];
}

#pragma mark - NSURLSession deleagte
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
{
    if (error) {
        NSLog(@"error: %@ - %@", task, error);
    } else {
        NSLog(@"success: %@", task);
    }
    self.downloadTask = nil;
    [self callCompletionHandlerIfFinished];
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{
    double progress = (double)totalBytesWritten / (double)totalBytesExpectedToWrite;
    NSLog(@"download: %@ progress: %f", downloadTask, progress);
    dispatch_async(dispatch_get_main_queue(), ^{
        self.progressView.progress = progress;
    });
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location
{
    NSLog(@"did finish downloading");
    
    // We've successfully finished the download. Let's save the file
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSArray *URLs = [fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
    NSURL *documentsDirectory = URLs[0];
    
    NSURL *destinationPath = [documentsDirectory URLByAppendingPathComponent:[location lastPathComponent]];
    NSError *error;
    
    // Make sure we overwrite anything that's already there
    [fileManager removeItemAtURL:destinationPath error:NULL];
    BOOL success = [fileManager copyItemAtURL:location toURL:destinationPath error:&error];
    
    if (success) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.imageView.image = [UIImage imageWithContentsOfFile:[destinationPath path]];
            [self.progressView setHidden:YES];
        });
    }
}




@end
