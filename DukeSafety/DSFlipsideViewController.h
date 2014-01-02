//
//  DSFlipsideViewController.h
//  DukeSafety
//
//  Created by Soroush Pour on 11/11/13.
//  Copyright (c) 2013 Sofa Productions. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DSFlipsideViewController;

@protocol DSFlipsideViewControllerDelegate
- (void)flipsideViewControllerDidFinish:(DSFlipsideViewController *)controller;
@end

@interface DSFlipsideViewController : UIViewController

@property (weak, nonatomic) id <DSFlipsideViewControllerDelegate> delegate;

- (IBAction)done:(id)sender;

@end
