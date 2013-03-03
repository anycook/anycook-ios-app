//
//  StepView.h
//  RecipeViewPrototype
//
//  Created by Maximilian Michel on 09.07.12.
//  Copyright (c) 2012 anycook. All rights reserved.
//

#import <UIKit/UIKit.h>

// Class representing the step view
@interface StepView : UIView

// Digit of last Step in whole recipe
@property NSInteger maxSteps;

// Sets number |stepnumber| of current steps and updates the text of the matching label
- (void) setStepNumber:(NSInteger) stepnumber;
// Sets the |stepText| and updates the text of the matching label
- (void) setText:(NSString *)stepText;




@end
