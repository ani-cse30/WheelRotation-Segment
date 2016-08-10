//
//  RotaryProtocol.h
//  RotaryWheelProject
//
//  Created by cesarerocchi on 2/10/12.
//  Copyright (c) 2012 studiomagnolia.com. All rights reserved.


#import <Foundation/Foundation.h>

@protocol RotaryProtocol <NSObject>

- (void) wheelDidChangeValue:(NSString *)newValue;
- (void) yourTurnAlertViewShow:(NSString *)newValue;
- (void) HideYourTurnAlertView:(NSString *)newValue;

@end
