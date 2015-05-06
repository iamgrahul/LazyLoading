//
//  ImageManager.h
//  LazyLoading
//
//  Created by Rahul Gupta on 01/05/15.
//  Copyright (c) 2015 InnovationM. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "ImageData.h"

@protocol ImageManagerDelegate

@optional
-(void) imageDataReceived :(ImageData *)imageData;

@end

@interface ImageManager : NSOperation
@property (nonatomic, strong) ImageData *imageData;
@property (nonatomic) NSUInteger retryCount;

@property (nonatomic, weak) id<ImageManagerDelegate> delegate;
@end