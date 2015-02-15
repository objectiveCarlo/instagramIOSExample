//
//  InstagramGalleryViewController.h
//  InstagramApp
//
//  Created by Carlo Luis Bation on 2/16/15.
//  Copyright (c) 2015 incube8. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InstagramGalleryViewController : UIViewController<UICollectionViewDataSource, UICollectionViewDelegate>

@property (strong, nonatomic) NSMutableArray *images;

@property (weak, nonatomic) IBOutlet UICollectionView *galleryCollectionView;

@end
