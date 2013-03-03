//
//  RecipeProtoStepViewController.h
//  RecipeViewPrototype
//
//  Created by Maximilian Michel on 13.05.12.
//  Copyright (c) 2012 anycook. All rights reserved.
//

#import <UIKit/UIKit.h>

// Represents the controller for the StepView; it also represents the ScrollViewDelegate of the |stepCanvas|
@interface RecipeProtoStepViewController : UIViewController<UIScrollViewDelegate>

// Container containing all step texts.
@property (strong,nonatomic) NSMutableArray * steps;
// Name of the recipe. Important for favorite and camera functionalities in the last step.
@property (strong, nonatomic) NSString * name;

@end
