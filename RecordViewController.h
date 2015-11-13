//
//  RecordViewController.h
//  NoiseInfo
//
//  Created by apple on 11/4/15.
//  Copyright (c) 2015 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecordViewController : UIViewController
@property NSString *lat;
@property NSString *lon;
@property NSString *db1;
@property NSString *user;
@property int mainInt;
@property (nonatomic) int range;
@property (nonatomic) int offset;
@property (nonatomic) int referenceLevel;
@property NSTimer *timer;
//@property NSArray *testArr;
@end
