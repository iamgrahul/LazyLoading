//
//  LoadingTableViewCell.h
//  LazyLoading
//
//  Created by Rahul Gupta on 01/05/15.
//  Copyright (c) 2015 InnovationM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoadingTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingIndicator;

@end
