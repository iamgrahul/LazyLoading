//
//  CellData.m
//  LazyLoading
//
//  Created by Rahul Gupta on 30/04/15.
//  Copyright (c) 2015 InnovationM. All rights reserved.
//

#import "CellData.h"

@implementation CellData
@synthesize imageUrl;
@synthesize text;

-(id) initWithDict :(NSDictionary *)dict
{
    imageUrl = [[[dict valueForKey:@"im:image"] lastObject] objectForKey:@"label"];
    text = [[[dict valueForKey:@"id"] objectForKey:@"attributes"] objectForKey:@"im:bundleId"];
    return self;
}

@end