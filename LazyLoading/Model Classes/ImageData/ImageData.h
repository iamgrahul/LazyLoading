//
//  ImageData.h
//  LazyLoading
//
//  Created by Rahul Gupta on 01/05/15.
//  Copyright (c) 2015 InnovationM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ImageData : NSObject
@property (nonatomic, strong) NSString *imageURL;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) NSString *imageName;
@property (nonatomic, strong) NSError *error;

@end