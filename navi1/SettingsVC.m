//
//  SettingsVC.m
//  navi1
//
//  Created by admin on 06.03.15.
//  Copyright (c) 2015 admin. All rights reserved.
//

#import "SettingsVC.h"
#import "CityClass.h"
#import "DataManager.h"
#import "ViewController.h"

@interface SettingsVC ()

@end

@implementation SettingsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
- (IBAction)actionAddCity:(id)sender {
    NSLog(@"Click!");
    //    UIAlertView *messageAlert = [[UIAlertView alloc]
    //                                 initWithTitle:@"Button" message:@"Click button..." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    // Display Alert Message
    //    [messageAlert show];
    
    if ([self.cityText.text length])  {
    
    CityClass *addCityClass = [CityClass cityWithId:@"696050" name:self.cityText.text] ;
    [addCityClass getWeather];
    [DataManager addCity:addCityClass];
    //    [ViewController tableCity reloadData];
    
    
    UIStoryboard *storyBoard = [self storyboard];
    ViewController *gotoVC = [storyBoard instantiateViewControllerWithIdentifier:@"ViewController"];
    [self showViewController:gotoVC sender:self];
    } else {
       // self.cityText.borderStyle = UITextBorderStyleNone;
        self.cityText.backgroundColor = [UIColor redColor];
        
    }
}

@end
