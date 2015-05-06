//
//  ImageManager.h
//  LazyLoading
//
//  Created by Rahul Gupta on 01/05/15.
//  Copyright (c) 2015 InnovationM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface DocumentManager : NSObject

+ (DocumentManager *) getInstance;

-(NSString *) documentDirPath;

-(BOOL) storeFile:(NSData *)fileData fileName:(NSString *)fileName fromDir:(NSString*)pDir;
-(UIImage *) readFromFile:(NSString *)fileName fromDir:(NSString*)pDir;
-(BOOL) removeTheLocalStorage;
-(BOOL) removeTheLocalStorage:(NSString *)folderName;
-(BOOL)saveImageData:(NSData *)data fileName:(NSString *)fileName fromDir:(NSString *)folderName;
-(NSData *)readImageData:(NSString *)fileName fromDir:(NSString *)pDir;
-(BOOL) deleteStoredImage;

-(NSString*)getImageNameWithImageURL:(NSString*)imageURL;

@end
