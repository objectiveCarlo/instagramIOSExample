//
//  NSDictionary+InstagramImages.m
//  InstagramApp
//
//  Created by Carlo Luis Bation on 2/16/15.
//  Copyright (c) 2015 incube8. All rights reserved.
//

#import "NSDictionary+InstagramImages.h"

@implementation NSDictionary (InstagramImages)

- (NSString *)instagramImagesGetImageByResolutionKey:(NSString *)key {
    
    NSString *ret = nil;
    
    id possibleImages = [self objectForKey:@"images"];
    
    if (possibleImages && [possibleImages respondsToSelector:@selector(objectForKey:)]) {
        
        id possibleImage = [possibleImages objectForKey:key];
        
        if (possibleImage && [possibleImage respondsToSelector:@selector(objectForKey:)]) {
            
            ret = [possibleImage objectForKey:@"url"];
        }
        
    }
    
    return ret;
}

@end
