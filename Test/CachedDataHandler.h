//
//  CachedDataHandler.h
//  RecipeViewPrototype
//
//  Created by Maximilian Michel on 31.05.12.
//  Copyright (c) 2012 anycook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Recipe.h"
#import "RecipeModel.h"

// Class handling all database functionalities of the cached data
@interface CachedDataHandler : NSObject

// Public Managed Document represents the connection to the Database
@property (strong, nonatomic) UIManagedDocument * localDB;

// Singleton Pattern: returns the current instance of the CachedData handler or - if not initialized - creates a new instance
+ (CachedDataHandler *) instance;
// Clears the cached data database
- (void) clearAll;
// Fills the cache with all recipe- and ingredientinformation from the anycook database
- (void) fillCache: (NSNotification*)notification;

// Returns array with all recipes form the cached database
- (NSMutableArray*) getAllRecipes;
// Returns array with all recipes that are marked as a favorite
- (NSMutableArray*) getFavoriteRecipes;
// Returns array with all recipes with name containing |searchstring|
- (NSMutableArray*) getRecipesContaining:(NSString*) searchstring;
// Returns array with all ingredients with name containing |searchstring|
- (NSMutableArray*) getIngredientsContaining:(NSString*) searchstring;
// Returns Recipe with name |recipename|
- (Recipe*) getRecipeFromCacheWithName: (NSString*) recipename;
// Saves a RecipeModel to the local database
- (void) saveRecipeToFavorites:(RecipeModel*) recipeModel;
// Saves the current state of the database
- (void) explicitSave;

@end
