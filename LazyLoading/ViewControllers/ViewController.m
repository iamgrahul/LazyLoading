//
//  ViewController.m
//  LazyLoading
//
//  Created by Rahul Gupta on 30/04/15.
//  Copyright (c) 2015 InnovationM. All rights reserved.
//
#define MaxConcurrentImageDownload 10

#import "ViewController.h"
#import "CellData.h"
#import "LazyTableViewCell.h"
#import "ImageManager.h"
#import "ImageData.h"
#import "CachingManager.h"
#import "LoadingTableViewCell.h"

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource, ImageManagerDelegate, UIScrollViewDelegate>
{
    NSMutableArray *cellDataArray;
    NSOperationQueue *imageOperationQueue;
    NSMutableDictionary *imageDownLoadInProgressDictioanry;
    NSCache *imageCache;
    CachingManager *cachingManager;
}

@end

@implementation ViewController
@synthesize lazyTableView;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    cachingManager = [CachingManager getInstance];
    imageOperationQueue = [[NSOperationQueue alloc]init];
    [imageOperationQueue setMaxConcurrentOperationCount:MaxConcurrentImageDownload];
    imageDownLoadInProgressDictioanry = [[NSMutableDictionary alloc] init];
    imageCache = cachingManager.imageCache;
    lazyTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [self getDataFromJson];
}

-(void) viewDidDisappear:(BOOL)animated
{
    cachingManager.imageCache = imageCache;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void) getDataFromJson
{
    NSError *error = nil;
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"app" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data
                                                         options:kNilOptions
                                                           error:&error];
    [self processData:json];
}

-(void) processData :(NSDictionary *)dictionary
{
    NSArray *dataArray = [[dictionary objectForKey:@"feed"] valueForKey:@"entry"];
    NSUInteger dataCount = [dataArray count];
    cellDataArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < dataCount; i ++)
    {
        CellData *cellData = [[CellData alloc] initWithDict:[dataArray objectAtIndex:i]];
        [cellDataArray addObject:cellData];
    }
    [lazyTableView reloadData];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([cellDataArray count] == 0)
    {
        return 1;
    }
    return [cellDataArray count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == [cellDataArray count])
    {
        static NSString *cellIdentifier = @"LoadingCell";
        LoadingTableViewCell *cell = (LoadingTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
        [cell.loadingIndicator startAnimating];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        return cell;
    }
    else
    {
        static NSString *cellIdentifier = @"LazyCellId";
        tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        LazyTableViewCell *cell = (LazyTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
        
        CellData *cellData = [cellDataArray objectAtIndex:indexPath.row];
        [cell.mytitlelabel setText:cellData.text];
        if ([imageCache objectForKey:cellData.imageUrl])
        {
            [cell.iconImageView setImage:[imageCache objectForKey:cellData.imageUrl]];
        }
        else
        {
            [cell.iconImageView setImage:[UIImage imageNamed:@"DemoImage"]];
            [self startDownloadForImageAtIndexPath:indexPath :0];
        }
        return cell;
    }
}

-(void) startDownloadForImageAtIndexPath :(NSIndexPath *)indexPath :(NSUInteger) retryCount
{
    CellData *cellData = [cellDataArray objectAtIndex:indexPath.row];
    ImageManager *imageManager = [imageDownLoadInProgressDictioanry objectForKey:cellData.imageUrl];
    if (!imageManager)
    {
        ImageData *imageData = [[ImageData alloc] init];
        imageData.imageURL = cellData.imageUrl;
        imageData.indexPath = indexPath;
        imageData.imageName = cellData.text;
        [self sendRequest:imageData :retryCount];
    }
}

-(void) sendRequest :(ImageData *)imageData :(NSUInteger) retryCount
{
    ImageManager *imageManager = [[ImageManager alloc] init];
    imageManager.imageData = imageData;
    imageManager.retryCount = retryCount;
    imageManager.delegate = self;
    [imageOperationQueue addOperation:imageManager];
    [imageDownLoadInProgressDictioanry setObject:imageManager forKey:imageData.imageURL];
}

-(void) imageDataReceived:(ImageData *)imageData
{
    dispatch_async(dispatch_get_main_queue(), ^{
        ImageManager *imageManager = [imageDownLoadInProgressDictioanry objectForKey:imageData.imageURL];
        [imageManager cancel];
        [imageDownLoadInProgressDictioanry removeObjectForKey:imageData.imageURL];
        
        if ([[lazyTableView indexPathsForVisibleRows] containsObject: imageData.indexPath])
        {
            if (imageData.image)
            {
                LazyTableViewCell *cell = (LazyTableViewCell *)[lazyTableView cellForRowAtIndexPath:imageData.indexPath];
                
                [cell.iconImageView setImage:imageData.image];
                [imageCache setObject:imageData.image forKey:imageData.imageURL];
            }
            else
            {
                imageManager.retryCount = imageManager.retryCount + 1;
                if (imageManager.retryCount <= 3)
                {
                    [self sendRequest:imageManager.imageData :imageManager.retryCount];
                }
            }
        }
        else
        {
            [imageCache setObject:imageData.image forKey:imageData.imageURL];
        }
    });
}

- (void)terminateAllDownloads
{
    imageCache.evictsObjectsWithDiscardedContent = YES;
    // terminate all pending download connections
    [imageOperationQueue cancelAllOperations];
}

@end