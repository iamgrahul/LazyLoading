//
//  WebServiceManager.m
//  LazyLoading
//
//  Created by Rahul Gupta on 01/05/15.
//  Copyright (c) 2015 InnovationM. All rights reserved.
//

#import "WebServiceManager.h"
#import "AppDelegate.h"

@implementation WebServiceManager

+(NSData *) callGETWebService:(NSString *)url error:(NSError **)error
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:100.0];
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    NSHTTPURLResponse *response = nil;
    [request setHTTPMethod:@"GET"];
    
    //Check for NSError
    NSData  *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:error];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
    return responseData;
}

@end
