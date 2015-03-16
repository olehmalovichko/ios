//
//  SettingsVC.h
//  navi1
//
//  Created by admin on 06.03.15.
//  Copyright (c) 2015 admin. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DetailVCDElegate <NSObject>
-(void)reloadTableData;
@end

@interface DetailVC : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *cityText;

@property (nonatomic,weak) id <DetailVCDElegate> delegate;





@end
