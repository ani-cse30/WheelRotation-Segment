//
//  RotaryWheel.m
//  RotaryWheelSegment
//
//  Created by Anindya Das on 8/10/16.
//  Copyright © 2016 AppsInception. All rights reserved.
//

#import "RotaryWheel.h"
#import <QuartzCore/QuartzCore.h>
#import "CLove.h"

@interface RotaryWheel()
- (void)drawWheel;
- (float) calculateDistanceFromCenter:(CGPoint)point;
- (void) buildClovesEven;
- (UIImageView *) getCloveByValue:(int)value;
@end

static float deltaAngle;
//static float minAlphavalue = 0.6;

static float maxAlphavalue = 1.0;
NSString *res = @"";
float touchLimitPoint=0,rotationAngle=0;
UIImage *previousImg;

@implementation RotaryWheel
NSTimer *timer;
int wheelRotationCounter=0,whRotationLimit=0,previousSelectedSection=-1;

@synthesize delegate, container, numberOfSections, startTransform, cloves, currentValue;

- (id) initWithFrame:(CGRect)frame andDelegate:(id)del
        withSections:(int)sectionsNumber rotationLimit:(int)limit  {
    
    whRotationLimit = limit;
    rotationAngle =1.57;
    if ((self = [super initWithFrame:frame])) {
        self.currentValue = 0;
        self.numberOfSections = sectionsNumber;
        self.delegate = del;
        [self drawWheel];
        timer=[NSTimer scheduledTimerWithTimeInterval:0.2
                                               target:self
                                             selector:@selector(rotate)
                                             userInfo:nil
                                              repeats:YES];
    }
    return self;
}

- (void) drawWheel {
    
    container = [[UIView alloc] initWithFrame:self.frame];
    CGFloat angleSize = 2*M_PI/numberOfSections;
    
    for (int i = 0; i < numberOfSections; i++) {
        
        UIImageView *im = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"icon%i.png", i+1]]];
        if (self.frame.size.width == 320.0f){
            im.frame = CGRectMake( 0 ,0,97,74.5);
            touchLimitPoint=97;
        } else if (self.frame.size.width == 375.0f) {
            im.frame = CGRectMake( 0 ,0,112.8,86.3);
            touchLimitPoint=112.8;
        } else if (self.frame.size.width == 414.0f) {
            im.frame = CGRectMake( 0 ,0,125,97);
            touchLimitPoint=125;
        }
        else if (self.frame.size.width == 1024.0f) {
            im.frame = CGRectMake( 0 ,0,305,240);
            touchLimitPoint=300;
        }
        im.layer.anchorPoint = CGPointMake(1.0f, 0.5f);
        im.layer.position = CGPointMake(container.bounds.size.width/2.0-container.frame.origin.x,
                                        container.bounds.size.height/2.0-container.frame.origin.y);
        im.transform = CGAffineTransformMakeRotation(angleSize*i);
        im.tag = i;
        
        UIImageView *cloveImage = [[UIImageView alloc] initWithFrame:CGRectMake(12, 15, 40, 40)];
        cloveImage.userInteractionEnabled = YES;
        [im addSubview:cloveImage];
        
        [container addSubview:im];
        
    }
    
    container.userInteractionEnabled = NO;
    [self addSubview:container];
    cloves = [NSMutableArray arrayWithCapacity:numberOfSections];
    UIImageView *bg = [[UIImageView alloc] initWithFrame:self.frame];
    [self addSubview:bg];
    UIImageView *mask = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0,8,8)];
    mask.image =[UIImage imageNamed:@"centerButton.png"];
    mask.center = self.center;
    mask.center = CGPointMake(mask.center.x, mask.center.y);
    mask.alpha = 0.9;
    [self addSubview:mask];
    
    [self buildClovesEven];
    
}


- (UIImageView *) getCloveByValue:(int)value {
    
    UIImageView *res;
    
    NSArray *views = [container subviews];
    
    for (UIImageView *im in views) {
        
        if (im.tag == value)
            res = im;
    }
    
    return res;
    
}

- (void) buildClovesEven {
    
    CGFloat fanWidth = M_PI*2/numberOfSections;
    CGFloat mid = 0;
    
    for (int i = 0; i < numberOfSections; i++) {
        
        Clove *clove = [[Clove alloc] init];
        clove.midValue = mid;
        clove.minValue = mid - (fanWidth/2);
        clove.maxValue = mid + (fanWidth/2);
        clove.value = i;
        
        
        if (clove.maxValue-fanWidth < - M_PI) {
            
            mid = M_PI;
            clove.midValue = mid;
            clove.minValue = fabsf(clove.maxValue);
        }
        mid -= fanWidth;
        [cloves addObject:clove];
    }
    
}

- (float) calculateDistanceFromCenter:(CGPoint)point {
    
    CGPoint center = CGPointMake(self.bounds.size.width/2.0f, self.bounds.size.height/2.0f);
    float dx = point.x - center.x;
    float dy = point.y - center.y;
    return sqrt(dx*dx + dy*dy);
}

- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    
    CGPoint touchPoint = [touch locationInView:self];
    float dist = [self calculateDistanceFromCenter:touchPoint];
    
    if (dist < 5 || dist > touchLimitPoint)
    {
        return NO;
    }
    
    float dx = touchPoint.x - container.center.x;
    float dy = touchPoint.y - container.center.y;
    deltaAngle = atan2(dy,dx);
    startTransform = container.transform;
    
    
    switch (currentValue)
    
    {
        case 0:
            if (deltaAngle>=-0.3926 && deltaAngle<=0.392699) {
                res=@"4";
            }
            else if (deltaAngle>=-1.178097 && deltaAngle<=-0.392699){
                res=@"3";
            }
            else if (deltaAngle>=-1.963495 && deltaAngle<=-1.178097){
                res=@"2";
            }
            else if (deltaAngle>=-2.748893 && deltaAngle<=-1.963495){
                res=@"1";
            }
            
            else if (deltaAngle>=1.963495 && deltaAngle<=2.748894){
                res=@"7";
            }
            else if (deltaAngle>=1.178097 && deltaAngle<=1.963495){
                res=@"6";
            }
            else if (deltaAngle>=0.392699 && deltaAngle<=1.178097){
                res=@"5";
            }
            else{
                res=@"0";
            }
            
            break;
            
        case 1:
            if (deltaAngle>=-0.3926 && deltaAngle<=0.392699) {
                res=@"5";
            }
            else if (deltaAngle>=-1.178097 && deltaAngle<=-0.392699){
                res=@"4";
            }
            else if (deltaAngle>=-1.963495 && deltaAngle<=-1.178097){
                res=@"3";
            }
            else if (deltaAngle>=-2.748893 && deltaAngle<=-1.963495){
                res=@"2";
            }
            
            else if (deltaAngle>=1.963495 && deltaAngle<=2.748894){
                res=@"0";
            }
            else if (deltaAngle>=1.178097 && deltaAngle<=1.963495){
                res=@"7";
            }
            else if (deltaAngle>=0.392699 && deltaAngle<=1.178097){
                res=@"6";
            }
            else{
                res=@"1";
            }
            
            break;
        case 2:
            if (deltaAngle>=-0.3926 && deltaAngle<=0.392699) {
                res=@"6";
            }
            else if (deltaAngle>=-1.178097 && deltaAngle<=-0.392699){
                res=@"5";
            }
            else if (deltaAngle>=-1.963495 && deltaAngle<=-1.178097){
                res=@"4";
            }
            else if (deltaAngle>=-2.748893 && deltaAngle<=-1.963495){
                res=@"3";
            }
            
            else if (deltaAngle>=1.963495 && deltaAngle<=2.748894){
                res=@"1";
            }
            else if (deltaAngle>=1.178097 && deltaAngle<=1.963495){
                res=@"0";
            }
            else if (deltaAngle>=0.392699 && deltaAngle<=1.178097){
                res=@"7";
            }
            else{
                res=@"2";
            }
            
            break;
        case 3:
            if (deltaAngle>=-0.3926 && deltaAngle<=0.392699) {
                res=@"7";
            }
            else if (deltaAngle>=-1.178097 && deltaAngle<=-0.392699){
                res=@"6";
            }
            else if (deltaAngle>=-1.963495 && deltaAngle<=-1.178097){
                res=@"5";
            }
            else if (deltaAngle>=-2.748893 && deltaAngle<=-1.963495){
                res=@"4";
            }
            
            else if (deltaAngle>=1.963495 && deltaAngle<=2.748894){
                res=@"2";
            }
            else if (deltaAngle>=1.178097 && deltaAngle<=1.963495){
                res=@"1";
            }
            else if (deltaAngle>=0.392699 && deltaAngle<=1.178097){
                res=@"0";
            }
            else{
                res=@"3";
            }
            
            break;
        case 4:
            if (deltaAngle>=-0.3926 && deltaAngle<=0.392699) {
                res=@"0";
            }
            else if (deltaAngle>=-1.178097 && deltaAngle<=-0.392699){
                res=@"7";
            }
            else if (deltaAngle>=-1.963495 && deltaAngle<=-1.178097){
                res=@"6";
            }
            else if (deltaAngle>=-2.748893 && deltaAngle<=-1.963495){
                res=@"5";
            }
            
            else if (deltaAngle>=1.963495 && deltaAngle<=2.748894){
                res=@"3";
            }
            else if (deltaAngle>=1.178097 && deltaAngle<=1.963495){
                res=@"2";
            }
            else if (deltaAngle>=0.392699 && deltaAngle<=1.178097){
                res=@"1";
            }
            else{
                res=@"4";
            }
            
            break;
        case 5:
            if (deltaAngle>=-0.3926 && deltaAngle<=0.392699) {
                res=@"1";
            }
            else if (deltaAngle>=-1.178097 && deltaAngle<=-0.392699){
                res=@"0";
            }
            else if (deltaAngle>=-1.963495 && deltaAngle<=-1.178097){
                res=@"7";
            }
            else if (deltaAngle>=-2.748893 && deltaAngle<=-1.963495){
                res=@"6";
            }
            
            else if (deltaAngle>=1.963495 && deltaAngle<=2.748894){
                res=@"4";
            }
            else if (deltaAngle>=1.178097 && deltaAngle<=1.963495){
                res=@"3";
            }
            else if (deltaAngle>=0.392699 && deltaAngle<=1.178097){
                res=@"2";
            }
            else{
                res=@"5";
            }
            
            break;
        case 6:
            if (deltaAngle>=-0.3926 && deltaAngle<=0.392699) {
                res=@"2";
            }
            else if (deltaAngle>=-1.178097 && deltaAngle<=-0.392699){
                res=@"1";
            }
            else if (deltaAngle>=-1.963495 && deltaAngle<=-1.178097){
                res=@"0";
            }
            else if (deltaAngle>=-2.748893 && deltaAngle<=-1.963495){
                res=@"7";
            }
            else if (deltaAngle>=1.963495 && deltaAngle<=2.748894){
                res=@"5";
            }
            else if (deltaAngle>=1.178097 && deltaAngle<=1.963495){
                res=@"4";
            }
            else if (deltaAngle>=0.392699 && deltaAngle<=1.178097){
                res=@"3";
            }
            else{
                res=@"6";
            }
            
            break;
            
        case 7:
            if (deltaAngle>=-0.3926 && deltaAngle<=0.392699) {
                res=@"3";
            }
            else if (deltaAngle>=-1.178097 && deltaAngle<=-0.392699){
                res=@"2";
            }
            else if (deltaAngle>=-1.963495 && deltaAngle<=-1.178097){
                res=@"1";
            }
            else if (deltaAngle>=-2.748893 && deltaAngle<=-1.963495){
                res=@"0";
            }
            
            else if (deltaAngle>=1.963495 && deltaAngle<=2.748894){
                res=@"6";
            }
            else if (deltaAngle>=1.178097 && deltaAngle<=1.963495){
                res=@"5";
            }
            else if (deltaAngle>=0.392699 && deltaAngle<=1.178097){
                res=@"4";
            }
            else{
                res=@"7";
            }
            break;
            
            
        default:
            break;
    }
    
    UIImageView *selectedImgView = [self getCloveByValue:[res intValue]];
    NSString *imageName = [@"active-icon" stringByAppendingFormat:@"%d",[res intValue]+1];
    selectedImgView.image = [UIImage imageNamed:imageName];
    return YES;
}



-(void)selectedSegment{
    
    CGFloat radians = atan2f(container.transform.b, container.transform.a);
    
    CGFloat newVal = 0.0;
    
    for (Clove *c in cloves) {
        if (c.minValue > 0 && c.maxValue < 0) {
            
            if (c.maxValue > radians || c.minValue < radians) {
                if (radians > 0) {
                    newVal = radians - M_PI;
                } else {
                    newVal = M_PI + radians;
                }
                currentValue = c.value;
            }
        }
        else if (radians > c.minValue && radians < c.maxValue) {
            newVal = radians - c.midValue;
            currentValue = c.value;
        }
    }
    
    UIImageView *im = [self getCloveByValue:currentValue];
    im.alpha = maxAlphavalue;
}



- (void) rotate
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];

    CGAffineTransform t = CGAffineTransformRotate(container.transform, rotationAngle);
    container.transform = t;
    [UIView commitAnimations];
    [self selectedSegment];

    if (wheelRotationCounter>whRotationLimit)
    {
        wheelRotationCounter =0;
        [timer invalidate];
        timer =nil;
       
    }
    if (wheelRotationCounter>= whRotationLimit / 2)
    {
        rotationAngle = -1.57;
    }
    wheelRotationCounter++;
}






@end
