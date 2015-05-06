//
//  CachingManager.m
//  LazyLoading
//
//  Created by Rahul Gupta on 01/05/15.
//  Copyright (c) 2015 InnovationM. All rights reserved.
//

#import "CachingManager.h"

@implementation CachingManager
@synthesize imageCache;

static CachingManager *sharedInstance = nil;

+ (CachingManager *) getInstance
{
    @synchronized(self)
    {
        if(sharedInstance == nil)
        {
            sharedInstance = [[self alloc] init];
            sharedInstance.imageCache = [[NSCache alloc] init];
        }
    }
    return sharedInstance;
}

@end