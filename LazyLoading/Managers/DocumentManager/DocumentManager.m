//
//  ImageManager.m
//  LazyLoading
//
//  Created by Rahul Gupta on 01/05/15.
//  Copyright (c) 2015 InnovationM. All rights reserved.
//

#import "DocumentManager.h"

@implementation DocumentManager
{
    NSFileManager *filemgr;
    NSString *docsDir;
    NSArray *dirPaths;
}

static DocumentManager *sharedInstance = nil;

#pragma mark FileManager singleton class method
+ (DocumentManager *) getInstance
{
    @synchronized(self)
    {
        if(sharedInstance == nil)
        {
            sharedInstance = [[self alloc] init];
        }
    }
    
    return sharedInstance;
}


-(NSString *)documentDirPath
{
    filemgr = [NSFileManager defaultManager];
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir =  [[dirPaths objectAtIndex:0] stringByAppendingPathComponent:@"Images"];
    
    NSArray *path = [filemgr contentsOfDirectoryAtPath:docsDir error:nil];
    if (path == nil)
    {
        if ([filemgr createDirectoryAtPath:docsDir withIntermediateDirectories:YES
                                attributes:nil error: NULL] == NO)
        {
          //  NSLog(@"Folder not created");
            
        }
        else
        {
           // NSLog(@"Folder created");
        }
    }
    
    return docsDir;
}
-(BOOL) createFolder:(NSString *)folderName
{
    NSString *docsDirPath = [self documentDirPath];
    NSString *folderPath = [docsDirPath stringByAppendingPathComponent:folderName];
    
    if ([filemgr createDirectoryAtPath:folderPath withIntermediateDirectories:YES
                            attributes:nil error: NULL] == NO)
    {
       // NSLog(@"Folder not created");
        return NO;
    }
    else
    {
       // NSLog(@"Folder created");
        return YES;
    }
    
}

-(BOOL) storeFile:(NSData *)fileData fileName:(NSString *)fileName fromDir:(NSString *)pDir
{
    NSString *docsDirPath = [self documentDirPath];
    NSString *folderPath = [docsDirPath stringByAppendingPathComponent:pDir];
    
    if ([filemgr createDirectoryAtPath:folderPath withIntermediateDirectories:YES
                            attributes:nil error: NULL] == NO)
    {
       // NSLog(@"Folder not created");
    }
  //  NSLog(@"file name is %@",fileName);
    NSString *filePath = [folderPath stringByAppendingPathComponent:fileName];
    
    if([filemgr createFileAtPath: filePath contents: fileData attributes:nil] == YES)
    {
      //  NSLog(@"file created at given path");
        return YES;
    }
    
    return NO;
}

-(UIImage *)readFromFile:(NSString *)fileName fromDir:(NSString *)pDir
{
    NSString *docsDirPath = [self documentDirPath];
    NSString *folderPath = [docsDirPath stringByAppendingPathComponent:pDir];
    NSString *filePath = [folderPath stringByAppendingPathComponent:fileName];
    
    NSData *fileData = [filemgr contentsAtPath:filePath ];
    UIImage *image = [UIImage imageWithData:fileData scale:1.0];
    return image;
}

-(BOOL) removeTheLocalStorage
{
    NSError *error;
    NSString *docsDirPath = [self documentDirPath];
    NSString *outletfolderPath = [docsDirPath stringByAppendingPathComponent:@"Outlet"];
    
    if([filemgr removeItemAtPath:outletfolderPath error:&error])
    {
       // NSLog(@"folder removed");
    }
    if (error)
    {
        return NO;
    }
    else
    {
        return YES;
    }
    
    
    return NO;
}


-(BOOL) removeTheLocalStorage:(NSString *)folderName
{
    NSError *error;
    NSString *docsDirPath = [self documentDirPath];
    NSString *outletfolderPath = [docsDirPath stringByAppendingPathComponent:folderName];
    
    if([filemgr removeItemAtPath:outletfolderPath error:&error])
    {
       // NSLog(@"folder removed");
    }
    if (error)
    {
        return NO;
    }
    else
    {
        return YES;
    }
    
    
    return NO;
}

-(BOOL)saveImageData:(NSData *)data fileName:(NSString *)fileName fromDir:(NSString *)folderName
{
    NSString *docsDirPath = [self documentDirPath];
    NSString *folderPath = [docsDirPath stringByAppendingPathComponent:folderName];
    
    if ([filemgr createDirectoryAtPath:folderPath withIntermediateDirectories:YES
                            attributes:nil error: NULL] == NO)
    {
       // NSLog(@"Folder not created");
    }
   // NSLog(@"file name is %@",fileName);
    NSString *filePath = [folderPath stringByAppendingPathComponent:fileName];
    
    if([filemgr createFileAtPath: filePath contents: data attributes:nil] == YES)
    {
       // NSLog(@"file created at given path");
        return YES;
    }
    
    return NO;
}

-(NSData *)readImageData:(NSString *)fileName fromDir:(NSString *)pDir
{
    NSString *docsDirPath = [self documentDirPath];
    NSString *folderPath = [docsDirPath stringByAppendingPathComponent:pDir];
    NSString *filePath = [folderPath stringByAppendingPathComponent:fileName];
    
    NSData *fileData = [filemgr contentsAtPath:filePath ];
    
    return fileData;
}

-(BOOL) deleteStoredImage
{
    NSError *error;
    NSString *docsDirPath = [self documentDirPath];
    NSString *outletfolderPath = [docsDirPath stringByAppendingPathComponent:@"data"];
    
    if([filemgr removeItemAtPath:outletfolderPath error:&error])
    {
        NSLog(@"folder removed");
    }
    if (error)
    {
        return NO;
    }
    else
    {
        return YES;
    }
    
    return NO;
}

-(NSString*)getImageNameWithImageURL:(NSString*)imageURL
{
    NSString *name = @"";
    
    if( ![imageURL isEqualToString:@""])
    {
        NSArray *stringNameArry = [imageURL componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"="]];
        
        NSString *imageName = [stringNameArry objectAtIndex:1];
        
        name = [[imageName componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"&"]] objectAtIndex:0];
//        if ([ValidationManager validateUrl:imageURL])
//        {
//            return name;
//        }
//        else
//        {
//           return @"";
//        }
    }
   
    return name;
}

@end
