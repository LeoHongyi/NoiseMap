//
//  NoiseInfo.h
//  NoiseInfo
//
//  Created by apple on 11/2/15.
//  Copyright (c) 2015 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NoiseInfo : NSObject
@property(nonatomic, assign)float db;
@property(nonatomic, assign)float lat;
@property(nonatomic, assign)float lon;
+(instancetype)noiseWithDict:(NSDictionary *)dict;
@end
