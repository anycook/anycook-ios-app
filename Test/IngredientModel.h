//
//  Ingredient.h
//  RecipeViewPrototype
//
//  Created by Maximilian Michel on 14.05.12.
//  Copyright (c) 2012 anycook. All rights reserved.
//

#import <Foundation/Foundation.h>

// Class represinting a Ingredient. 
@interface IngredientModel : NSObject
@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSString * menge;
@property (nonatomic, strong) NSString * singular;

@property (nonatomic, strong) NSMutableArray * children;

// Init method for initializing with JSON Object
- (IngredientModel*) initWithJson:(NSString*)jsonString;
// Init method for initializing with Dictionary
- (IngredientModel*) initWithDictionary:(NSDictionary*)dictionary;

@end
