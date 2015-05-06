//
//  CellData.h
//  LazyLoading
//
//  Created by Rahul Gupta on 30/04/15.
//  Copyright (c) 2015 InnovationM. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CellData : NSObject
@property (nonatomic, strong) NSString *imageUrl;
@property (nonatomic, strong) NSString *text;
-(id) initWithDict :(NSDictionary *)dict;

@end