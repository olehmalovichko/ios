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
#import "MainVC.h"

@interface SettingsVC ()

@end

@implementation SettingsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    //focus to cityText
    [self.cityText becomeFirstResponder];
    [self.view addSubview:self.cityText];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)actionAddCity:(id)sender {
    NSLog(@"Click!");
    
    if ([self.cityText.text length])  {
        
        CityClass *addCityClass = [CityClass cityWithId:@"696050" name:self.cityText.text] ;
        //[addCityClass getWeather];
        
        [DataManager addCity:addCityClass];
        //[ViewController tableCity reloadData];
        
        
        UIStoryboard *storyBoard = [self storyboard];
        MainVC *gotoVC = [storyBoard instantiateViewControllerWithIdentifier:@"ViewController"];
        [self showViewController:gotoVC sender:self];
    } else {
        // self.cityText.borderStyle = UITextBorderStyleNone;
        UIColor *color = [UIColor colorWithRed:255/255.0f green:163/255.0f blue:145/255.0f alpha:1.0f];
        self.cityText.backgroundColor = color;
        
    }
}



@end
