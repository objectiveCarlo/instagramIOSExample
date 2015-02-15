//
//  ViewController.m
//  InstagramApp
//
//  Created by Carlo Luis Bation on 2/15/15.
//  Copyright (c) 2015 incube8. All rights reserved.
//

#import "InstagramMainViewController.h"
#import "AppDelegate.h"
#import "IGConnect.h"

@interface InstagramMainViewController ()<IGSessionDelegate>

@end

@implementation InstagramMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    AppDelegate* appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    appDelegate.instagram.accessToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"accessToken"];
    appDelegate.instagram.sessionDelegate = self;
    
    if (![appDelegate.instagram isSessionValid]) {
       [appDelegate.instagram authorize:[NSArray arrayWithObjects:@"basic", nil]];
    }

}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    AppDelegate* appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    if ([appDelegate.instagram isSessionValid]) {
        [self pushGalleryView];
        
    }
    
}
- (void)pushGalleryView {
    
    [self performSegueWithIdentifier:@"pushGalleryView" sender:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (IBAction)loginButtonPressed:(id)sender {
    
    AppDelegate* appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    [appDelegate.instagram authorize:[NSArray arrayWithObjects:@"basic", nil]];
}



#pragma - IGSessionDelegate

-(void)igDidLogin {
    NSLog(@"Instagram did login");
    AppDelegate* appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    [[NSUserDefaults standardUserDefaults] setObject:appDelegate.instagram.accessToken forKey:@"accessToken"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self pushGalleryView];
    
}

-(void)igDidNotLogin:(BOOL)cancelled {
    NSLog(@"Instagram did not login");
    NSString* message = nil;
    if (cancelled) {
        message = @"Access cancelled!";
    } else {
        message = @"Access denied!";
    }
    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil];
    [alertView show];
}

-(void)igDidLogout {
    NSLog(@"Instagram did logout");
    // remove the accessToken
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"accessToken"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void)igSessionInvalidated {
    NSLog(@"Instagram session was invalidated");
}

@end
