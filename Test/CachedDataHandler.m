//
//  CachedDataHandler.m
//  RecipeViewPrototype
//
//  Created by Maximilian Michel on 31.05.12.
//  Copyright (c) 2012 anycook. All rights reserved.
//

#import "CachedDataHandler.h"
#import "RecipeCacheDelegate.h"
#import "IngredientCacheDelegate.h"
#import "RecipeModel.h"
#import "IngredientModel.h"
#import "Ingredient.h"
#import "Step.h"

@interface CachedDataHandler()

- (CachedDataHandler*) init;


@end

@implementation CachedDataHandler

@synthesize localDB = _localDB;

- (void) notify{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"LocalDBReadyNotification" object:NULL];
}


- (void) explicitSave{
    NSError * error = nil;
    [self.localDB.managedObjectContext save:&error];
}

- (void) saveRecipesToCache: (NSNotification*) notification{
    NSArray * recipenames = [notification object];
    
    // Create the fetch request to get all Employees matching the IDs.
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:
    [NSEntityDescription entityForName:@"Recipe" inManagedObjectContext:self.localDB.managedObjectContext]];
    [fetchRequest setPredicate: [NSPredicate predicateWithFormat:@"(name IN %@)", recipenames]];
    

    // make sure the results are sorted as well
    [fetchRequest setSortDescriptors:
     @[[[NSSortDescriptor alloc] initWithKey: @"name" ascending:YES selector:@selector(localizedCompare:)]]];
    
    recipenames = [recipenames sortedArrayUsingSelector:@selector(localizedCompare:)];
    
    
    
    NSError *error;
    NSArray *matchingRecipes = [self.localDB.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    NSLog(@"%d matches in cache", [matchingRecipes count]);
    
    if([matchingRecipes count] != [recipenames count]){
        int j = 0;
        for (int i = 0; i < [recipenames count]; ++i) {
            NSString * loadedName = [recipenames objectAtIndex:i];
            NSString * matchedName = @"";
            if([matchingRecipes count] > 0){
                Recipe * mathedRecipe = [matchingRecipes objectAtIndex:j];
                matchedName = mathedRecipe.name;
            }
            
            if([loadedName isEqualToString:matchedName]){
                if(j < [matchingRecipes count])
                    j = j + 1;
            } else{
                NSLog(@"Added recipe: %@", loadedName);
                Recipe * recipe = [NSEntityDescription insertNewObjectForEntityForName:@"Recipe" inManagedObjectContext:self.localDB.managedObjectContext];
                recipe.name = loadedName;
            }
        }
    }
    
    
    [self explicitSave];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"LocalDBSavedCacheNotification" object:NULL];
}

- (Recipe*) getRecipeFromCacheWithName: (NSString*) recipename{
    NSFetchRequest * request = [NSFetchRequest fetchRequestWithEntityName:@"Recipe"];
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"name == %@", recipename];
    [request setPredicate:predicate];
    
    NSError * error = nil;
    NSArray * result = [self.localDB.managedObjectContext executeFetchRequest:request error:&error];
    if(result != nil){
        Recipe * recipe = [result objectAtIndex:0];
        return recipe;
    }
    
    return nil;
}

- (NSMutableArray*) getFavoriteRecipes{
    NSFetchRequest * request = [NSFetchRequest fetchRequestWithEntityName:@"Recipe"];
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"favorite == 1"];
    [request setPredicate:predicate];
    
    NSError * error = nil;
    NSArray * results = [self.localDB.managedObjectContext executeFetchRequest:request error:&error];
    NSMutableArray * recipenames = [[NSMutableArray alloc]init ];
    if(results != nil)
        for(Recipe* recipe in results)
            [recipenames addObject:recipe.name];
    
    return recipenames;
} 

- (NSMutableArray*) getRecipesContaining:(NSString*) searchstring{
    searchstring = [searchstring stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSFetchRequest * request = [NSFetchRequest fetchRequestWithEntityName:@"Recipe"];
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"name CONTAINS[cd] %@", searchstring];
    [request setPredicate:predicate];

    NSError * error = nil;
    NSArray * results = [self.localDB.managedObjectContext executeFetchRequest:request error:&error];
    NSMutableArray * recipenames = [[NSMutableArray alloc]init ];
    if(results != nil)
        for(Recipe* recipe in results)
            [recipenames addObject:recipe.name];

    return recipenames;
}

- (void) saveIngredientsToCache: (NSNotification*) notification{
    NSMutableArray * savedIngredients = [self getAllIngredientNames];
    NSArray * ingredientnames = [notification object];
    for(NSString* name in ingredientnames){
        if ([savedIngredients containsObject:name]) {
            continue;
        }
        Ingredient * ingredient = [NSEntityDescription insertNewObjectForEntityForName:@"Ingredient" inManagedObjectContext:self.localDB.managedObjectContext];
        ingredient.name = name;
        ingredient.recipe = @"none";
    }
    NSError * error = nil;
    [self.localDB.managedObjectContext save:&error];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"LocalDBSavedCacheNotification" object:NULL];
}

- (void) saveRecipeToFavorites:(RecipeModel*) recipeModel{
    Recipe * recipe = [self getRecipeFromCacheWithName:recipeModel.name];
    recipe.persons = recipeModel.persons;
    recipe.schmeckt = recipeModel.schmeckt;
    recipe.skill = recipeModel.skill;
    recipe.timemin = recipeModel.timemin;
    recipe.timestd = recipeModel.timestd;
    recipe.author = recipeModel.author;
    recipe.favorite = [NSNumber numberWithInt:1];
    recipe.description_text = recipeModel.description;
    
    
    NSMutableSet * ingredients = [[NSMutableSet alloc] init];
    for(IngredientModel * ingredient in recipeModel.ingredients){
        Ingredient * ing = [[Ingredient alloc] initWithEntity:[NSEntityDescription entityForName:@"Ingredient" inManagedObjectContext:self.localDB.managedObjectContext] insertIntoManagedObjectContext:self.localDB.managedObjectContext];
        ing.name = ingredient.name;
        ing.menge = ingredient.menge;
        ing.recipe = recipeModel.name;
        [ingredients addObject:ing];
    }
    
    recipe.ingredients = ingredients;
    
    NSMutableSet * steps = [[NSMutableSet alloc] init];
    NSNumber * stepnumber = [NSNumber numberWithInt:1];
    for(NSString * step in recipeModel.steps){
        Step * ste = [[Step alloc] initWithEntity:[NSEntityDescription entityForName:@"Step" inManagedObjectContext:self.localDB.managedObjectContext] insertIntoManagedObjectContext:self.localDB.managedObjectContext];
        ste.text = step;
        ste.step_number = stepnumber;
        [steps addObject:ste];
        stepnumber = [NSNumber numberWithInt:[stepnumber intValue] + 1];
    }
    
    recipe.steps = steps;
    
    [self explicitSave];
}

- (void) fillCache: (NSNotification*)notification{
    RecipeCacheDelegate * rcacheDelegate = [[RecipeCacheDelegate alloc] init];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"LocalDBReadyNotification" object:nil];
    NSString * urlString = @"http://graph.anycook.de/recipe?appid=3";
    NSURLRequest * request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:urlString]];
    NSURLConnection * connection = [[NSURLConnection alloc] initWithRequest:request delegate:rcacheDelegate];
    if (!connection) {
        NSLog(@"No Connection!");
    }
    
    IngredientCacheDelegate * icacheDelegate = [[IngredientCacheDelegate alloc] init];
    urlString = @"http://graph.anycook.de/ingredient?appid=3";
    NSURLRequest * irequest = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:urlString]];
    NSURLConnection * iconnection = [[NSURLConnection alloc] initWithRequest:irequest delegate:icacheDelegate];
    if (!iconnection) {
        NSLog(@"No Connection!");
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveRecipesToCache:) name:@"RecipeCacheNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveIngredientsToCache:) name:@"IngredientCacheNotification" object:nil];
    
    
}

- (NSMutableArray*) getIngredientsContaining:(NSString*) searchstring{
    searchstring = [searchstring stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSFetchRequest * request = [NSFetchRequest fetchRequestWithEntityName:@"Ingredient"];
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"name BEGINSWITH[cd] %@ AND recipe = %@", searchstring, @"none"];
    [request setPredicate:predicate];
    
    NSError * error = nil;
    NSArray * results = [self.localDB.managedObjectContext executeFetchRequest:request error:&error];
    NSMutableArray * names = [[NSMutableArray alloc]init ];
    if(results != nil)
        for(Ingredient* result in results)
            [names addObject:result.name];
    return names;
}

- (NSMutableArray*) getAllRecipes{
    NSMutableArray * recipes = [[NSMutableArray alloc] init];
    NSLog(@"getting data from localdb");
    NSFetchRequest * request = [NSFetchRequest fetchRequestWithEntityName:@"Recipe"];
    NSError * error = nil;
    NSArray * array = [self.localDB.managedObjectContext executeFetchRequest:request error:&error];
    if(array != nil){
        NSLog(@"%d", [array count]);
        for (Recipe * rec in array) {
            //NSLog(@"%@", rec.name);
            [recipes addObject:rec];
        }
    }else {
        NSLog(@"error while fetching");
    }
    
    return recipes;
}

- (NSMutableArray*) getAllRecipeNames{
    NSMutableArray * recipes = [[NSMutableArray alloc] init];
    NSLog(@"getting data from localdb");
    NSFetchRequest * request = [NSFetchRequest fetchRequestWithEntityName:@"Recipe"];
    NSError * error = nil;
    NSArray * array = [self.localDB.managedObjectContext executeFetchRequest:request error:&error];
    if(array != nil){
        NSLog(@"%d", [array count]);
        for (Recipe * rec in array) {
            //NSLog(@"%@", rec.name);
            [recipes addObject:rec.name];
        }
    }else {
        NSLog(@"error while fetching");
    }
    
    return recipes;
}

- (NSMutableArray*) getAllIngredientNames{
    NSMutableArray * ingredients = [[NSMutableArray alloc] init];
    NSLog(@"getting data from localdb");
    NSFetchRequest * request = [NSFetchRequest fetchRequestWithEntityName:@"Ingredient"];
    NSError * error = nil;
    NSArray * array = [self.localDB.managedObjectContext executeFetchRequest:request error:&error];
    if(array != nil){
        NSLog(@"%d", [array count]);
        for (Ingredient * ingred in array) {
            //NSLog(@"%@", rec.name);
            [ingredients addObject:ingred.name];
        }
    }else {
        NSLog(@"error while fetching");
    }
    
    return ingredients;
}

- (void) clearAll{
    [self.localDB.managedObjectContext performBlockAndWait:^{
        [self clearEntities:@"Ingredient"];
        [self clearEntities:@"Recipe"];
        [self clearEntities:@"Step"];
        [self clearEntities:@"Tag"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"LocalDBClearedCacheNotification" object:NULL];
    }];
}

- (void) clearEntities:(NSString*)entityname{
    NSFetchRequest * request = [NSFetchRequest fetchRequestWithEntityName:entityname];
    NSError * error = nil;
    NSArray * array = [self.localDB.managedObjectContext executeFetchRequest:request error:&error];
    if(array != nil){
        for (NSManagedObject * entity in array) {
            [self.localDB.managedObjectContext performBlockAndWait:^{
                [self.localDB.managedObjectContext deleteObject:entity];
                NSError * serror = nil;
                [self.localDB.managedObjectContext save:&serror];
            }];
        }
        [self.localDB saveToURL:self.localDB.fileURL forSaveOperation:UIDocumentSaveForOverwriting completionHandler:NULL];
    }else {
        NSLog(@"error while fetching");
    }
    
}

- (CachedDataHandler*) init{
    self = [super init];
    if(self){
        if(!self.localDB){
            NSURL * url = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
            url = [url URLByAppendingPathComponent:@"Anycook Cached Database"]; // url is now "<Documents Directory>/Anycook Cached Database"
            self.localDB = [[UIManagedDocument alloc] initWithFileURL:url];        
        }
    }
    return self;
}

+ (CachedDataHandler*) instance{
    static CachedDataHandler * theHandler;
    
    @synchronized(self){
        if(!theHandler)
            theHandler = [[CachedDataHandler alloc] init];
        @try {
            return theHandler;
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            //[[NSNotificationCenter defaultCenter] postNotificationName:@"LocalDBReadyNotification" object:NULL];
        }
        
    }
}

- (void) useDocument{
    if (![[NSFileManager defaultManager] fileExistsAtPath:[self.localDB.fileURL path]]) {
        // does not exist --> create
        [self.localDB saveToURL:self.localDB.fileURL forSaveOperation:UIDocumentSaveForCreating completionHandler:^(BOOL success) {
            NSLog(@"does not exist --> create");
            [self notify];
        }];
    } else if(self.localDB.documentState == UIDocumentStateClosed){
        // exists, but closed --> open
        [self.localDB openWithCompletionHandler:^(BOOL success){
            NSLog(@"does exist --> open");
            [self notify];
        }];
    } else if (self.localDB.documentState == UIDocumentStateNormal) {
        NSLog(@"ready");
        [self notify];
    }
}

- (void) setLocalDB:(UIManagedDocument *)localDB{
    if(_localDB != localDB){
        _localDB = localDB;
        [self useDocument];
    }
}

@end
