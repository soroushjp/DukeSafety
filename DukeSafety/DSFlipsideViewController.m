//
//  DSFlipsideViewController.m
//  DukeSafety
//
//  Created by Soroush Pour on 11/11/13.
//  Copyright (c) 2013 Sofa Productions. All rights reserved.
//

#import "DSFlipsideViewController.h"

@interface DSFlipsideViewController ()

@end

@implementation DSFlipsideViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions

- (IBAction)done:(id)sender
{
    [self.delegate flipsideViewControllerDidFinish:self];
}

@end
