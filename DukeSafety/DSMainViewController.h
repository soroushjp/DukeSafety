//
//  DSMainViewController.h
//  DukeSafety
//
//  Created by Soroush Pour on 11/11/13.
//  Copyright (c) 2013 Sofa Productions. All rights reserved.
//

#import "DSFlipsideViewController.h"
#import <MapKit/MapKit.h>
#import <QuartzCore/QuartzCore.h>
#import "SKPSMTPMessage.h"
#import "NSStream+SKPSMTPExtensions.h"

@interface DSMainViewController : UIViewController <DSFlipsideViewControllerDelegate, MKMapViewDelegate, SKPSMTPMessageDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

- (IBAction)sendLocationClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *locateBtn;

@property (weak, nonatomic) IBOutlet UIButton *callBtn;
- (IBAction)callPoliceClicked:(id)sender;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *locateLoading;

@end
