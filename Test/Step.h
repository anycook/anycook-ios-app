//
//  Step.h
//  anycook
//
//  Created by Maximilian Michel on 02.10.12.
//  Copyright (c) 2012 anycook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Ingredient, Recipe;

@interface Step : NSManagedObject

@property (nonatomic, retain) NSNumber * step_number;
@property (nonatomic, retain) NSString * text;
@property (nonatomic, retain) Recipe *hasRecipe;
@property (nonatomic, retain) NSSet *ingredients;
@end

@interface Step (CoreDataGeneratedAccessors)

- (void)addIngredientsObject:(Ingredient *)value;
- (void)removeIngredientsObject:(Ingredient *)value;
- (void)addIngredients:(NSSet *)values;
- (void)removeIngredients:(NSSet *)values;

@end
