//
//  StepView.m
//  RecipeViewPrototype
//
//  Created by Maximilian Michel on 09.07.12.
//  Copyright (c) 2012 anycook. All rights reserved.
//

#import "StepView.h"

@interface StepView()

@property (nonatomic, strong) UILabel * stepLabel;
@property (nonatomic, strong) UILabel * stepText;

@end


@implementation StepView

@synthesize stepLabel = _stepLabel;
@synthesize stepText = _stepText;
@synthesize maxSteps = _maxSteps;

// Override super's designated initializer. All views and labels are are initialized and their backgroundcolor is set.
- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        _stepLabel = [[UILabel alloc] init];
        _stepText = [[UILabel alloc] init];
        
        
        [self addSubview:self.stepText];
        [self addSubview:self.stepLabel];
        
        
        UIColor * papergray = [UIColor colorWithRed:0.941 green:0.937 blue:0.922 alpha:1];
        self.stepText.backgroundColor = papergray;
        self.stepLabel.backgroundColor = papergray;
        
    }
    return self;
}

- (void) setText:(NSString *)stepText{
    
    self.stepText.frame = CGRectMake(0, 0, 280, 0);
    self.stepText.text = stepText;
    [self.stepText setLineBreakMode:UILineBreakModeWordWrap];
    [self.stepText setNumberOfLines:0];
    
    self.stepText.font = [UIFont fontWithName:@"Palatino" size:18];
    [self.stepText sizeToFit];
    
    self.stepText.center = CGPointMake(self.frame.size.width/2, 200);
}

- (void) setStepNumber:(NSInteger) stepnumber{
    self.stepLabel.text = [NSString stringWithFormat:@"%d / %d", stepnumber, self.maxSteps];
    self.stepLabel.font = [UIFont fontWithName:@"Palatino" size:40];
    if(stepnumber < 0)
        self.stepLabel.text = @"";
    self.stepLabel.textColor = [UIColor lightGrayColor];
    [self.stepLabel sizeToFit];
    self.stepLabel.center = CGPointMake(self.frame.size.width/2, 50);
}


@end
