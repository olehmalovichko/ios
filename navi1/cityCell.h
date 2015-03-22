//
//  cityCell.h
//  Weather
//
//  Created by admin on 22.03.15.
//  Copyright (c) 2015 admin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CityCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameCity;
@property (weak, nonatomic) IBOutlet UIImageView *imageCity;
@property (weak, nonatomic) IBOutlet UILabel *tempCity;


@end
