//
//  ViewController.m
//  RotaryWheelSegment
//
//  Created by Anindya Das on 8/10/16.
//  Copyright © 2016 AppsInception. All rights reserved.
//

#import "ViewController.h"
#import "RotaryWheel.h"

@interface ViewController (){
    RotaryWheel *wheel;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    int limit  = [self getRandomNumberWithRange:25 rangeValue:40];
    wheel = [[RotaryWheel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)  andDelegate:self withSections:8 rotationLimit:limit];
    
    wheel.userInteractionEnabled = YES;
    
    if (self.view.frame.size.width == 320.0f){
        wheel.center = CGPointMake(160.7,309);
    } else if (self.view.frame.size.width == 375.0f) {
        wheel.center = CGPointMake(188.2,363);
    } else if (self.view.frame.size.width == 414.0f) {
        wheel.center = CGPointMake(207.5,400.5);
    }
    else if (self.view.frame.size.width == 1024.0f) {
        wheel.center = CGPointMake(514,763);
    }
    [self.view addSubview:wheel];
}

-(int)getRandomNumberWithRange:(int)lowerValue rangeValue:(int)rangevalue
{
    int ranvalue = arc4random_uniform(rangevalue);
    if (ranvalue<lowerValue)
    {
        return [self getRandomNumberWithRange:lowerValue rangeValue:rangevalue];
    }
    else{
        return ranvalue;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
