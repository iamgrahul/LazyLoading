//
//  LazyTableViewCell.h
//  LazyLoading
//
//  Created by Rahul Gupta on 30/04/15.
//  Copyright (c) 2015 InnovationM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LazyTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *mytitlelabel;

@end