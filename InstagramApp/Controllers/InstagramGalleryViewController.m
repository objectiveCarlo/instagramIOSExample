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

@interface InstagramGalleryViewController()<IGRequestDelegate>

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
    [appDelegate.instagram requestWithParams:params
                                    delegate:self];
}

#pragma mark - UICollectionViewDataSource methods

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.images.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
   
    static NSString *identifier = @"GalleryCollectionViewCell";
    
    GalleryCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    return cell;
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
    
    if (result && [result respondsToSelector:@selector(objectForKey:)]) {
        
        id possibleData = result[@"data"];
        
        if (possibleData && [possibleData isKindOfClass:[NSArray class]]) {
            
            [self.images addObjectsFromArray:possibleData];
            
            [self.galleryCollectionView reloadData];
        }
    }
}
@end
