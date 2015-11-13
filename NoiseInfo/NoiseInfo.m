//
//  NoiseInfo.m
//  NoiseInfo
//
//  Created by apple on 11/2/15.
//  Copyright (c) 2015 apple. All rights reserved.
//

#import "NoiseInfo.h"

@implementation NoiseInfo
+(instancetype)noiseWithDict:(NSDictionary *)dict
{
    NoiseInfo *nf = [[self alloc]init];
    [nf setValuesForKeysWithDictionary:dict];
    return nf;
}
-(NSString *)description
{
    NSString *str = [NSString stringWithFormat:@"db:%f--lat:%f--lon:%f",self.db,self.lat,self.lon];
    return str;
}
@end
