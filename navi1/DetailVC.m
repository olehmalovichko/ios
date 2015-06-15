//
//  SettingsVC.m
//  navi1
//
//  Created by admin on 06.03.15.
//  Copyright (c) 2015 admin. All rights reserved.
//

#import "DetailVC.h"
#import "CityClass.h"
#import "DataManager.h"
#import "MainVC.h"
#import "DetailVC.h"

@interface DetailVC ()

@end

@implementation DetailVC

//@synthesize delegate;

- (void)viewDidLoad {
    [super viewDidLoad];
    //self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //focus to cityText
    [self.cityText becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)actionAddCity:(id)sender {
    NSLog(@"Click!");
    
    if ([self.cityText.text length])  {
        // FIXME не дописан функционал
        CityClass *addCityClass = [CityClass cityWithId:@2643743 name:self.cityText.text];
        [DataManager addCity:addCityClass];
        [self.delegate reloadTableData];
        [self.navigationController popToRootViewControllerAnimated:YES];
        
    } else {
        // self.cityText.borderStyle = UITextBorderStyleNone;
        UIColor *color = [UIColor colorWithRed:255/255.0f green:163/255.0f blue:145/255.0f alpha:1.0f];
        self.cityText.backgroundColor = color;
        
    }
}




@end
