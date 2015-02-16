//
//  InstagramGalleryViewController.m
//  InstagramApp
//
//  Created by Carlo Luis Bation on 2/16/15.
//  Copyright (c) 2015 incube8. All rights reserved.
//

#import "InstagramGalleryViewController.h"
#import "GalleryCollectionViewCell.h"
#import "IGConnect.h"
#import "AppDelegate.h"
#import "NSDictionary+InstagramImages.h"
#import <SDWebImage/UIImageView+WebCache.h>


@interface InstagramGalleryViewController()<IGRequestDelegate>

@property (nonatomic, assign) BOOL paging;
@property (nonatomic, strong) NSString *nextMaxId;

@end

@implementation InstagramGalleryViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.images = [NSMutableArray new];
    
    [self requestForInstagramImages];
}

- (void)requestForInstagramImages {
    
    AppDelegate* appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"users/self/media/recent", @"method", nil];
    
    if (self.nextMaxId) {
        
        [params setObject:self.nextMaxId forKey:@"max_id"];
    }
    
    [appDelegate.instagram requestWithParams:params
                                    delegate:self];
}
- (void)getNextMaxIdFomData:(NSDictionary *)data {
    
    self.nextMaxId = nil;
    
    id possiblePagination = [data objectForKey:@"pagination"];
    
    if (possiblePagination && [possiblePagination respondsToSelector:@selector(objectForKey:)]) {
        
        id possibleNextMaxId = [possiblePagination objectForKey:@"next_max_id"];
        
        if (possibleNextMaxId && [possibleNextMaxId isKindOfClass:[NSString class]]) {
            
            self.nextMaxId = possibleNextMaxId;
        }
    }
}
#pragma mark - UICollectionViewDataSource methods

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.images.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
   
    static NSString *identifier = @"GalleryCollectionViewCell";
    
    GalleryCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    NSDictionary *dictionaryItem = [self.images objectAtIndex:indexPath.row];
    
    NSString *imageUrl = [dictionaryItem instagramImagesGetImageByResolutionKey:@"standard_resolution"];
    
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:imageUrl]];
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y == scrollView.contentSize.height - scrollView.bounds.size.height
        && !_paging) {
        
        _paging = YES;
        
        [self requestForInstagramImages];
    }
}

#pragma mark - IGRequestDelegate

- (void)request:(IGRequest *)request didFailWithError:(NSError *)error {
    NSLog(@"Instagram did fail: %@", error);
    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:[error localizedDescription]
                                                       delegate:nil
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil];
    [alertView show];
}

- (void)request:(IGRequest *)request didLoad:(id)result {
    NSLog(@"Instagram did load: %@", result);
    
    self.nextMaxId = nil;
    
    _paging = NO;
    
    if (result && [result respondsToSelector:@selector(objectForKey:)]) {
        
        id possibleData = result[@"data"];
        
        if (possibleData && [possibleData isKindOfClass:[NSArray class]]) {
            
            [self.images addObjectsFromArray:possibleData];
            
            [self.galleryCollectionView reloadData];
        }
        
        [self getNextMaxIdFomData:result];
    }
}
@end
