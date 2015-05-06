//
//  ImageManager.m
//  LazyLoading
//
//  Created by Rahul Gupta on 01/05/15.
//  Copyright (c) 2015 InnovationM. All rights reserved.
//
#define ImageDirectory @"Images"

#import "ImageManager.h"
#import "WebServiceManager.h"
#import "DocumentManager.h"

@implementation ImageManager
{
    DocumentManager *documentManager;
}
@synthesize imageData;

- (void) main
{
    @autoreleasepool
    {
        [self fetchImage];
    }
}

-(void) fetchImage
{
    documentManager = [[DocumentManager alloc] init];
    NSError *error = imageData.error;
    NSData *imageRawData = [documentManager readImageData:imageData.imageName fromDir:ImageDirectory];
    
    if (!imageRawData)
    {
        imageRawData = [self downloadImage:&error];
    }
    UIImage *image;
    
    if (error == nil)
    {
        image = [UIImage imageWithData:imageRawData];
        
        [documentManager saveImageData:imageRawData fileName:imageData.imageName fromDir:ImageDirectory];
    }
    else
    {
        imageData.error = error;
    }
    [self processImageData:image];
}

-(NSData *) downloadImage:(NSError **)error
{
    NSData *rawData = [WebServiceManager callGETWebService:imageData.imageURL error:error];
    return rawData;
}

-(void) processImageData :(UIImage *)image
{
    imageData.image = image;
    if (self.delegate && !self.isCancelled)
    {
        [self.delegate imageDataReceived :imageData];
    }
}

@end