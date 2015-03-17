//
//  DetailcVC.h
//
//  Created by admin on 06.03.15.
//  Copyright (c) 2015 admin. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DetailVCDelegate <NSObject>
- (void)reloadTableData;
@end

@interface DetailVC : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *cityText;
@property (nonatomic,weak) id <DetailVCDelegate> delegate;


@end
