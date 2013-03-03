//
//  ShoppingListHandler.h
//  RecipeViewPrototype
//
//  Created by Maximilian Michel on 30.05.12.
//  Copyright (c) 2012 anycook. All rights reserved.
//

#import <Foundation/Foundation.h>
// Class handling all database functionalities of the shopping list
@interface ShoppingListHandler : NSObject

// Singleton Pattern: returns the current instance of the Shoppinglist handler, or - if not initialized - creates a new instance
+ (ShoppingListHandler *) instance;

// For debugging: fills the database with some ingredients
- (void) fillWithTestData;
// Returns an array of all Ingredients, that are currently saved in the shoppinglist database
- (NSMutableArray*) getAllIngredients;
// Removes the ingredient |name| with the amount |amount| from the shoppinglist database
- (void) removeIngredient:(NSString*) name withAmount: (NSString*) amount;
// Adds an ingredient with |name| and |amount| to the shoppinglist database
- (void) addIngredient:(NSString*) name withAmount: (NSString*) amount;
// Returns number of ingredients in the shoppinglist database
- (NSUInteger) getIngredientNum;
// Clears the shoppinglist database
- (void) clear;
// Saves the current state of the database
- (void) save;

@end

