//
//  RotaryWheel.h
//  RotaryWheelSegment
//
//  Created by Anindya Das on 8/10/16.
//  Copyright © 2016 AppsInception. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "RotaryProtocol.h"

@interface RotaryWheel : UIControl<UIGestureRecognizerDelegate>

@property (weak) id <RotaryProtocol> delegate;
@property (nonatomic, strong) UIView *container;
@property int numberOfSections;
@property CGAffineTransform startTransform;
@property (nonatomic, strong) NSMutableArray *cloves;
@property int currentValue;


- (id) initWithFrame:(CGRect)frame andDelegate:(id)del
        withSections:(int)sectionsNumber rotationLimit:(int)limit;


@end
