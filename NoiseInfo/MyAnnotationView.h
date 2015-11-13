//
//  MyAnnotationView.h
//  NoiseInfo
//
//  Created by apple on 11/6/15.
//  Copyright (c) 2015 apple. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface MyAnnotationView : MKAnnotationView
+(instancetype)annotationViewWithMapView:(MKMapView *)mapView;
@end
