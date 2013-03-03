//
//  Recipe.h
//  RecipeViewPrototype
//
//  Created by Maximilian Michel on 08.05.12.
//  Copyright (c) 2012 anycook. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Recipe.h"

// Class representing a Recipe.
@interface RecipeModel  : NSObject

@property (strong, nonatomic) NSString * name;
@property (strong, nonatomic) NSString * description;
@property (strong, nonatomic) NSString * author;

@property (strong, nonatomic) NSString * category;
@property (strong, nonatomic) NSNumber * schmeckt;
@property (strong, nonatomic) NSNumber * persons;
@property (strong, nonatomic) NSNumber * skill;
@property (strong, nonatomic) NSNumber * calories;
@property (strong, nonatomic) NSNumber * timemin;
@property (strong, nonatomic) NSNumber * timestd;

@property (strong, nonatomic) NSMutableArray * ingredients;
@property (strong, nonatomic) NSMutableArray * steps;
@property (strong, nonatomic) NSMutableArray * tags;

@property (strong, nonatomic) UIImage * thumbnail;

// Init method for initializing with JSON Object
- (RecipeModel*) initWithJSON:(NSString*)jsonstring;
// Init method for initializing with Recipe Object
- (RecipeModel*) initWithRecipe:(Recipe*) recipeIn;

@end
