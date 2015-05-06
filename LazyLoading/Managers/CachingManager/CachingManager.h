//
//  CachingManager.h
//  LazyLoading
//
//  Created by Rahul Gupta on 01/05/15.
//  Copyright (c) 2015 InnovationM. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CachingManager : NSObject
@property (nonatomic, strong) NSCache *imageCache;
+ (CachingManager *) getInstance;

@end