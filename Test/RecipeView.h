//
//  RecipeView.h
//  RecipeViewPrototype
//
//  Created by Maximilian Michel on 13.08.12.
//  Copyright (c) 2012 anycook. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "RecipeModel.h"

// Class representing the recipe view
@interface RecipeView : UIView

@property (strong, nonatomic) UIImageView * imageView;
@property (strong, nonatomic) UILabel * titleLabel;
@property (strong, nonatomic) UILabel * descriptionLabel;
@property (strong, nonatomic) UILabel * authorLabel;
@property (strong, nonatomic) UILabel * personsLabel;
@property (strong, nonatomic) UITableView * ingredients;
@property (strong, nonatomic) UIScrollView * scrollView;
@property (strong, nonatomic) UIStepper * stepper;


// Models, observed by the view
@property (strong, nonatomic) RecipeModel * recipe;
@property NSInteger persons; // number of currently set persons


@end
