//
//  DSMainViewController.m
//  DukeSafety
//
//  Created by Soroush Pour on 11/11/13.
//  Copyright (c) 2013 Sofa Productions. All rights reserved.
//

#import "DSMainViewController.h"

@interface DSMainViewController () {
    
    float lastLat;
    float lastLong;
    
}

@end

@implementation DSMainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [_locateBtn setTitle:@"" forState:UIControlStateDisabled];
    _locateLoading.hidden = YES;
    
    _mapView.delegate = self;
    
    _locateBtn.layer.cornerRadius = 10;
    _locateBtn.clipsToBounds = YES;
    [[_locateBtn layer] setBorderWidth:2.0f];
    [[_locateBtn layer] setBorderColor:[UIColor whiteColor].CGColor];
    
    _callBtn.layer.cornerRadius = 10;
    _callBtn.clipsToBounds = YES;
    [[_callBtn layer] setBorderWidth:2.0f];
    [[_callBtn layer] setBorderColor:[UIColor whiteColor].CGColor];
    
    
}

- (void)mapViewDidFinishLoadingMap:(MKMapView *)mapView {
    _mapView.showsUserLocation = YES;
    [_mapView setUserTrackingMode:MKUserTrackingModeFollow animated:YES];
    _mapView.scrollEnabled = NO;
    _mapView.zoomEnabled = YES;
    _mapView.pitchEnabled = NO;
    _mapView.rotateEnabled = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Button actions

- (IBAction)sendLocationClicked:(id)sender {
    NSLog(@"Send Location Button clicked");
    
    _locateBtn.enabled = NO;
    [_locateLoading startAnimating];
    _locateLoading.hidden = NO;
    
    lastLat = _mapView.userLocation.coordinate.latitude;
    lastLong = _mapView.userLocation.coordinate.longitude;
    
    NSString* gmap_url = [[NSString alloc] initWithFormat:@"https://maps.google.com/?q=%f,%f",lastLat, lastLong, nil];
    
//    NSLog(gmap_url);
    
    [self sendEmailInBackgroundWithURL:gmap_url];
}

- (IBAction)callPoliceClicked:(id)sender {
    
    UIDevice *device = [UIDevice currentDevice];
    if ([[device model] isEqualToString:@"iPhone"] ) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:911"]]];
    } else {
        UIAlertView *Notpermitted=[[UIAlertView alloc] initWithTitle:@"Alert" message:@"Your device doesn't support this feature." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [Notpermitted show];
    }
    
}

# pragma mark SMTP email send methods

-(void) sendEmailInBackgroundWithURL:(NSString*)location_url {
    NSLog(@"Start Sending");
    SKPSMTPMessage *emailMessage = [[SKPSMTPMessage alloc] init];
    emailMessage.fromEmail = @"EXAMPLE@GMAIL.COM"; //sender email address -- this can be any email
    emailMessage.toEmail = @"POLICE@DUKE.EDU";  //receiver email address -- this would be the police or other HQ email
    emailMessage.relayHost = @"SMTP.GMAIL.COM"; //SMTP server to use
    //emailMessage.ccEmail =@"your cc address";
    //emailMessage.bccEmail =@"your bcc address";
    emailMessage.requiresAuth = YES;
    emailMessage.relayPorts = [[NSArray alloc] initWithObjects:[NSNumber numberWithShort:465], [NSNumber numberWithShort:587], [NSNumber numberWithShort:25], nil];
    emailMessage.login = @"EXAMPLE@GMAIL.COM"; //SMTP server username
    emailMessage.pass = @"EXAMPLE_PASSWORD"; //SMTP server password
    emailMessage.subject =@"DukeSafety User Location Reported";
    emailMessage.wantsSecure = YES;
    emailMessage.delegate = self; // you must include <SKPSMTPMessageDelegate> to your class
    NSString *messageBody = [NSString stringWithFormat:@"A DukeSafety user has sent this location to DUPD:\n\n %@", location_url];
    //for example :   NSString *messageBody = [NSString stringWithFormat:@"Tour Name: %@\nName: %@\nEmail: %@\nContact No: %@\nAddress: %@\nNote: %@",selectedTour,nameField.text,emailField.text,foneField.text,addField.text,txtView.text];
    // Now creating plain text email message
    NSDictionary *plainMsg = [NSDictionary
                              dictionaryWithObjectsAndKeys:@"text/plain",kSKPSMTPPartContentTypeKey,
                              messageBody,kSKPSMTPPartMessageKey,@"8bit",kSKPSMTPPartContentTransferEncodingKey,nil];
    emailMessage.parts = [NSArray arrayWithObjects:plainMsg,nil];
    //in addition : Logic for attaching file with email message.
    /*
     NSString *filePath = [[NSBundle mainBundle] pathForResource:@"filename" ofType:@"JPG"];
     NSData *fileData = [NSData dataWithContentsOfFile:filePath];
     NSDictionary *fileMsg = [NSDictionary dictionaryWithObjectsAndKeys:@"text/directory;\r\n\tx-
     unix-mode=0644;\r\n\tname=\"filename.JPG\"",kSKPSMTPPartContentTypeKey,@"attachment;\r\n\tfilename=\"filename.JPG\"",kSKPSMTPPartContentDispositionKey,[fileData encodeBase64ForData],kSKPSMTPPartMessageKey,@"base64",kSKPSMTPPartContentTransferEncodingKey,nil];
     emailMessage.parts = [NSArray arrayWithObjects:plainMsg,fileMsg,nil]; //including plain msg and attached file msg
     */
    [emailMessage send];
    // sending email- will take little time to send so its better to use indicator with message showing sending...
}

-(void)messageSent:(SKPSMTPMessage *)message{
    NSLog(@"delegate - message sent");
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Location successfully sent!" message:nil delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
    [alert show];
    
    _locateBtn.enabled = YES;
    [_locateLoading stopAnimating];
    _locateLoading.hidden = YES;
}
// On Failure
-(void)messageFailed:(SKPSMTPMessage *)message error:(NSError *)error{
    // open an alert with just an OK button
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Network Error" message:@"Something went wrong, sorry" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
    [alert show];
    NSLog(@"delegate - error(%d): %@", [error code], [error localizedDescription]);
    
    _locateBtn.enabled = YES;
    [_locateLoading stopAnimating];
    _locateLoading.hidden = YES;
}

#pragma mark - Flipside View

- (void)flipsideViewControllerDidFinish:(DSFlipsideViewController *)controller
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showAlternate"]) {
        [[segue destinationViewController] setDelegate:self];
    }
}

@end
