//
//  CLove.m
//  RotaryWheelSegment
//
//  Created by Anindya Das on 8/10/16.
//  Copyright © 2016 AppsInception. All rights reserved.
//

#import "CLove.h"

@implementation Clove

@synthesize minValue, maxValue, midValue, value;

- (NSString *) description {
    
    return [NSString stringWithFormat:@"%i | %f, %f, %f", self.value, self.minValue, self.midValue, self.maxValue];
    
}

@end
