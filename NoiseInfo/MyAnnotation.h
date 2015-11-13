//
//  MyAnnotation.h
//  NoiseInfo
//
//  Created by apple on 11/3/15.
//  Copyright (c) 2015 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface MyAnnotation : NSObject<MKAnnotation>
@property (nonatomic,assign)CLLocationCoordinate2D coordinate;
@property (nonatomic,copy) NSString *title;

//@property (nonatomic, assign) MKPinAnnotationColor myPinColor;
@property(nonatomic,copy)NSString *icon;


@end
