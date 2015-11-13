//
//  MyAnnotationView.m
//  NoiseInfo
//
//  Created by apple on 11/6/15.
//  Copyright (c) 2015 apple. All rights reserved.
//

#import "MyAnnotationView.h"
#import "MyAnnotation.h"

@implementation MyAnnotationView

+(instancetype)annotationViewWithMapView:(MKMapView *)mapView
{
    static NSString *ID = @"anno";
    MyAnnotationView *annotationView = (MyAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:ID];
    
    if (annotationView == nil) {
        annotationView = [[MyAnnotationView alloc]initWithAnnotation:nil reuseIdentifier:ID];
    }
    return annotationView;
    
}
-(id)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self == [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier]) {
        self.canShowCallout = YES;
        self.backgroundColor = [UIColor redColor];
        
        
        
    }
    return self;
}

-(void)setAnnotation:(MyAnnotation *)annotation
{
    [super setAnnotation:annotation];
    
    self.image = [UIImage imageNamed:annotation.icon];
    
}

@end
