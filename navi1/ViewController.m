//
//  ViewController.m
//  navi1
//
//  Created by admin on 06.03.15.
//  Copyright (c) 2015 admin. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController {
   NSArray *tableData;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"start");
    // Initialize table data
   tableData = [NSArray arrayWithObjects:@"Киев", @"Харьков", @"Днепропетровск", @"Кременчуг",nil];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [tableData count];
}


                
 - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
     static NSString *simpleTableIdentifier = @"SimpleTableItem";
     
     UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
     
     if (cell == nil) {
         cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
     }
     
     cell.textLabel.text = [tableData objectAtIndex:indexPath.row];
     cell.imageView.image = [ UIImage imageNamed:@"weather.jpg"];
     
     return cell;
 }

- (IBAction)updateText:(id)sender {
    NSLog(@"button click");
}

- (IBAction)updateTemp:(id)sender {
   labelTemp.text = @"Hello";
   NSLog(@"label");
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
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
     [NSURL URLWithString:@"http://api.openweathermap.org/data/2.5/weather?id=704147"]];
    NSError *error;


    NSMutableDictionary *dict = [NSJSONSerialization
                                       JSONObjectWithData:allCoursesData
                                       options:NSJSONReadingMutableContainers
                                       error:&error];
    
    if( error )
    {
        NSLog(@"%@", [error localizedDescription]);
    }
    else {
        //NSLog(@"%@", dict);
        //NSArray *keys = [dict allKeys];
        
        NSLog(@"city: %@",[dict objectForKey:@"name"]);
        NSLog(@"%@",[dict objectForKey:@"main"]);
        
        
        NSDictionary *mainDetails = [dict objectForKey:@"main"];
        NSLog(@"temp: %@",[mainDetails objectForKey:@"temp"]);
        NSLog(@"humidity: %@",[mainDetails objectForKey:@"humidity"]);
        NSLog(@"------");
        
    }
  
    labelTemp.text = @"Hello";
    
}


@end
