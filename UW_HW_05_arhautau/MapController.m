//
//  MapController.m
//  UW_HW_05_arhautau
//
//  Created by Andrew Hautau on 5/27/15.
//  Copyright (c) 2015 Andrew Hautau. All rights reserved.
//

#import "MapController.h"
#import <MapKit/MapKit.h>
#import "MapViewCell.h"
#import "SearchBarCell.h"
#import "MapAnnotation.h"
#import "CheckIn.h"

@interface MapController () <CLLocationManagerDelegate, MKMapViewDelegate, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (weak, nonatomic) MKMapView *mapView;
@property (strong, nonatomic) MKLocalSearch *localSearch;
@property (weak, nonatomic) UISearchBar *searchBar;



@end

@implementation MapController

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void) viewWillAppear:(BOOL)animated {
    
    if (self.locationManager == nil) {
        self.locationManager = [[CLLocationManager alloc] init];
        [self.locationManager setDesiredAccuracy: kCLLocationAccuracyNearestTenMeters];
        // set our locationManager delegate
        [self.locationManager setDelegate: self];
    }
    
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined) {
        // request authorization
        [self.locationManager requestWhenInUseAuthorization];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

# pragma mark CLLocationManagerDelegate methods

-(void) locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    if (status == kCLAuthorizationStatusAuthorizedWhenInUse) {
        [self.locationManager startUpdatingLocation];
        [self.mapView setShowsUserLocation: YES];
    }
}

-(void) locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    
    [self.locationManager stopUpdatingLocation];
    
}

# pragma mark MKMapViewDelegate methods

-(void) mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    // set the mapView's region to the user's location manually
    [mapView setRegion: MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 10, 10) animated: YES];
}

- (MKAnnotationView *)mapView:(MKMapView *)theMapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    // check that annotation is not the user location
    if ([annotation isEqual: [self.mapView userLocation]]) {
        return nil;
    }

    MKPinAnnotationView*  customPinView = (MKPinAnnotationView*)[self.mapView dequeueReusableAnnotationViewWithIdentifier:@"PinAnnotationView"];
    if (!customPinView) {
        // If no pin view already exists, create a new one.
        customPinView = [[MKPinAnnotationView alloc]
                         initWithAnnotation: annotation reuseIdentifier:@"PinAnnotationView"];
        customPinView.canShowCallout = YES;
        
        // Button
        UIButton *button = [UIButton buttonWithType: UIButtonTypeSystem];
        button.frame = CGRectMake(0, 0, 80, customPinView.frame.size.height);
        [button setTitle:@"Check-In" forState:UIControlStateNormal];
        customPinView.rightCalloutAccessoryView = button;
        
    }
    
    return customPinView;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    
    MapAnnotation *annotation = view.annotation;
    UINavigationController *nav = [self navigationController];
    UINavigationController * parentNav = (UINavigationController *) [nav parentViewController];
    CheckIn *checkIn = [CheckIn createCheckInWithMapAnnotation: annotation];
    // set strong references to nil
    [self setLocalSearch: nil];
    [self setLocationManager:nil];
    
    // NOTE: dismissing a pushed view controller with a completion block
    // http://stackoverflow.com/questions/12904410/completion-block-for-popviewcontroller
    
    [CATransaction begin];
    [CATransaction setCompletionBlock:^{
        // add a check-in
        // post notification to archive check-in collection
        // will add the check in and update the table view
        [[NSNotificationCenter defaultCenter] postNotificationName: @"addCheckIn" object: self userInfo:@{@"CheckIn" : checkIn}];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"archiveCollection" object:self];
    }];
    
    [self.navigationController popViewControllerAnimated:YES];
    
    [CATransaction commit];
    
}


# pragma mark UISearchBarDelegate methods

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    MKLocalSearchRequest *searchRequest = [[MKLocalSearchRequest alloc] init];
    
    searchRequest.region = self.mapView.region;
    searchRequest.naturalLanguageQuery = self.searchBar.text;
    
    if (self.localSearch.isSearching) {
        [[self localSearch] cancel];
        self.localSearch = nil;
    }
    
    
    self.localSearch = [[MKLocalSearch alloc] initWithRequest:searchRequest];
    [self.localSearch startWithCompletionHandler:^(MKLocalSearchResponse *response, NSError *error) {
        for (MKMapItem*mapItem in response.mapItems) {
            MapAnnotation *annotation = [[MapAnnotation alloc] initWithMapItem:mapItem];
            [self.mapView addAnnotation: annotation];
        }
    }];
    
}


# pragma mark UITableViewDelegate methods


-(CGFloat) tableView:(UITableView*) tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger height = 44;
    if ([indexPath row] == 1) {
        height = self.tableView.frame.size.height - 44;
    }
    return height;
}


-(CGFloat) tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 100;
}

# pragma mark UITableViewDataSource methods

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *mapViewID= @"MapViewCell";
    static NSString *searchBarID= @"SearchBarCell";
    
    UITableViewCell *cell;
    
    if ([indexPath row] == 0) {
        NSArray *nibObjects = [[NSBundle mainBundle] loadNibNamed: searchBarID owner:self options:nil];
        cell = (SearchBarCell *) [nibObjects firstObject];
        UISearchBar *searchBar = [[[cell contentView] subviews] firstObject];
        self.searchBar = searchBar;
        [self.searchBar setDelegate: self];
    }
    
    if ([indexPath row] == 1) {
        NSArray *nibObjects = [[NSBundle mainBundle] loadNibNamed: mapViewID owner:self options:nil];
        cell = (MapViewCell *) [nibObjects firstObject];
        [cell setSelectionStyle: UITableViewCellSelectionStyleNone];
        MKMapView *mapView = [[[cell contentView] subviews] firstObject];
        self.mapView = mapView;
        // set our mapView delegate
        [self.mapView setDelegate:self];
        [self.mapView setUserTrackingMode:MKUserTrackingModeFollow];
    }
    
    return cell;
}

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
