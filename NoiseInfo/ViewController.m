//
//  ViewController.m
//  NoiseInfo
//
//  Created by apple on 11/2/15.
//  Copyright (c) 2015 apple. All rights reserved.
//

#import "ViewController.h"
#import "MBProgressHUD+HM.h"
#import "NoiseInfo.h"
#import <MapKit/MapKit.h>
#import "MyAnnotation.h"
#import "RecordViewController.h"
#import "testNav.h"
#import "MyAnnotationView.h"

@interface ViewController ()<MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property(nonatomic,strong) CLLocationManager *mgr;
@property(nonatomic,strong) NSString *latitude;
@property(nonatomic,strong) NSString *longtitude;
- (IBAction)logout:(id)sender;


//@property(nonatomic,strong) CLGeocoder *geocoder;
- (IBAction)backToUserLocation:(id)sender;


@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    if ([[UIDevice currentDevice].systemVersion doubleValue] >= 8.0) {
        self.mgr = [[CLLocationManager alloc] init];
        
        [self.mgr requestAlwaysAuthorization];
    }
    self.mapView.userTrackingMode = MKUserTrackingModeFollow;
    self.mapView.zoomEnabled = YES;
    self.mapView.delegate = self;
//    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(40.6500, -74.2500);
//    
//    MyAnnotation *anno = [[MyAnnotation alloc]init];
//    anno.coordinate = coordinate;
//    anno.icon = @"favicon";
//    [self.mapView addAnnotation:anno];
//    float east = -74.20;
//    float west = -74.25;
//    float south = 40.65;
//    float north = 40.70;
//    

   
    
    
}

-(void)loadNoiseDataWithArr:(NSArray *)arr{
    NSURL *noiseUrl = [NSURL URLWithString:@"http://128.235.40.165:8080/ReturnData"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:noiseUrl cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:5.0f];
    
    request.HTTPMethod = @"POST";
    NSString *param = [NSString stringWithFormat:@"east=%@&west=%@&south=%@&north=%@",arr[0],arr[1],arr[2],arr[3]];
    request.HTTPBody = [param dataUsingEncoding:NSUTF8StringEncoding];
    //NSLog(@"%@",request);
    NSOperationQueue *queue = [NSOperationQueue mainQueue];
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:
    ^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        //NSLog(@"%@",data);
        NSLog(@"%@",request);
        if (connectionError || data == nil) {
        
            [MBProgressHUD showError:@"server busy and please wait"];
            
            return;
        }
       
       NSArray *noiseArr = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
 
        
        for (NSMutableDictionary *dict in noiseArr) {
            //NoiseInfo *nf = [NoiseInfo noiseWithDict:dict];
           //NSLog(@"%@",nf);
             //
            if ([dict[@"db"] floatValue] > 50.00) {
               NSLog(@"upload success");
               //  NSLog(@"%@",dict[@"lat"]);
               // MyAnnotation *anno   = [[MyAnnotation alloc]init];
                //anno.title = dict[@"db"];
               // NSLog(@"noise!");
                NSLog(@"noise!");
               CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake([dict[@"lat"] floatValue], [dict[@"lon"] floatValue]);
                MyAnnotation *anno = [[MyAnnotation alloc]init];
                anno.coordinate = coordinate;
                anno.icon = @"favicon";
                [self.mapView addAnnotation:anno];
                
               // [self addPinWithCoordinate:coordinate1 color:MKPinAnnotationColorRed];
                
                //NSLog(@"%@",anno);
               // [self.mapView addAnnotation:anno];
                
            }else{
      
            }

        }

    }];

}

//- (void) addPinWithCoordinate:(CLLocationCoordinate2D)pinLocation
//                        color:(MKPinAnnotationColor)pinColor
//{
//    MyAnnotation *annotation = [[MyAnnotation alloc]initWithCoordinate:pinLocation];
//    annotation.myPinColor = pinColor;
//    [self.mapView addAnnotation:annotation];
//}


- (MyAnnotationView*) mapView:(MKMapView *)mapView viewForAnnotation:(MyAnnotation *)annotation
{
    
    if (![annotation isKindOfClass:[MyAnnotation class]]) {
        return nil;
    }
    MyAnnotationView *annoView = [MyAnnotationView annotationViewWithMapView:mapView];
    
    annoView.annotation = annotation;
    
    return annoView;
    
//    if (! [annotation isKindOfClass:[MyAnnotation class]]) {
//        
//        return nil;
//    }
//    
//    static NSString *reuseId = @"id";
//    
//    
//    MKPinAnnotationView *pinView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:reuseId];
//    if (pinView == nil) {
//        pinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:reuseId];
//        pinView.canShowCallout = YES;
//    }
//    else {
//        //[pinView addSubview:[UIButton buttonWithType:UIButtonTypeContactAdd]];
//        pinView.annotation = annotation;
//        
//    }

 //   MyAnnotation *ppm = (MyAnnotation *)annotation;
 //   pinView.pinColor = ppm.myPinColor;
    
   // return pinView;
}

-(void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    //NSLog(@"region change");
//    double centerLatitude= mapView.centerCoordinate.latitude;
//    double centerLongitude= mapView.centerCoordinate.longitude;
    CLLocationCoordinate2D center = mapView.region.center;
    double north= (center.latitude)+(mapView.region.span.latitudeDelta)/2;

    double west= (center.longitude)-(mapView.region.span.longitudeDelta) / 2;
    
    
    double south= (center.latitude)-(mapView.region.span.latitudeDelta)/2;
    
    double east= (center.longitude)+(mapView.region.span.longitudeDelta)/2;
    NSLog(@"%f,%f,%f,%f",north,west,south,east);
    
    if (north < 40.95 && north > 40.55 && south > 40.55 && south < 40.95 && east < -73.85 && east > -74.25 && west > -74.25 && west < 73.85) {
          NSArray *arr = [NSArray arrayWithObjects:[NSNumber numberWithFloat:east],[NSNumber numberWithFloat:west],[NSNumber numberWithFloat:south],[NSNumber numberWithFloat:north],nil];
        NSLog(@"%@",arr);
        [self loadNoiseDataWithArr:arr];
        
    }
    
//    NSArray *arr = [NSArray arrayWithObjects:[NSNumber numberWithFloat:east],[NSNumber numberWithFloat:west],[NSNumber numberWithFloat:south],[NSNumber numberWithFloat:north],nil];
//   
//        [self loadNoiseDataWithArr:arr];
 
}

-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    //  NSLog(@"%f-%f",self.mapView.userLocation.coordinate.latitude,self.mapView.userLocation.coordinate.longitude);
    CLLocationCoordinate2D center = userLocation.location.coordinate;
    MKCoordinateSpan span = MKCoordinateSpanMake(0.2 , 0.2);
    MKCoordinateRegion region = MKCoordinateRegionMake(center, span);
    [self.mapView setRegion:region animated:YES];
    
    self.latitude = [NSString stringWithFormat:@"%f",self.mapView.userLocation.location.coordinate.latitude];
    self.longtitude = [NSString stringWithFormat:@"%f",self.mapView.userLocation.location.coordinate.longitude];
    NSLog(@"user's location is %@--%@",self.latitude,self.longtitude);
   
    
}

//-(CLGeocoder *)geocoder{
//    if(!_geocoder){
//        _geocoder = [[CLGeocoder alloc]init];
//    }
//    return _geocoder;
//}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    testNav *nav = (testNav *)[segue destinationViewController];
    if ([[segue identifier] isEqualToString:@"contribute"]) {
        
        //radio.lat= self.latitude;
        RecordViewController *record = (RecordViewController *)nav.topViewController;
        record.lon = self.longtitude;
        record.lat = self.latitude;
        //NSLog(@"%@",self.username);
        record.user = self.username;
    }
  
}

- (IBAction)backToUserLocation:(id)sender {
    CLLocationCoordinate2D center = self.mapView.userLocation.location.coordinate;
    [self.mapView setCenterCoordinate:center animated:YES]; 
}


- (IBAction)logout:(id)sender {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"sure logout？" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        [self.navigationController popViewControllerAnimated:YES];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"NO" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action){
        
    }];
    [alert addAction:ok];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
}


@end
