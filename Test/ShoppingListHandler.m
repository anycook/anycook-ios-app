//
//  ShoppingListHandler.m
//  RecipeViewPrototype
//
//  Created by Maximilian Michel on 30.05.12.
//  Copyright (c) 2012 anycook. All rights reserved.
//

#import "ShoppingListHandler.h"
#import "Ingredient.h"

@interface ShoppingListHandler()

// Singleton pattern: private init method
- (ShoppingListHandler*) init;

@property (strong, nonatomic) UIManagedDocument * ingredientDB;

@end

@implementation ShoppingListHandler

@synthesize ingredientDB = _ingredientDB;

- (void) notify{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"DBReadyNotification" object:NULL];
}

- (void) notifyChange:(id) object{
    NSManagedObjectContext * context = (NSManagedObjectContext*) object;
    //if(context == self.ingredientDB.managedObjectContext)
    [[NSNotificationCenter defaultCenter] postNotificationName:@"shoppingListChangedNotification" object:NULL];
}

- (void) useDocument{
    if (![[NSFileManager defaultManager] fileExistsAtPath:[self.ingredientDB.fileURL path]]) {
        // does not exist --> create
        [self.ingredientDB saveToURL:self.ingredientDB.fileURL forSaveOperation:UIDocumentSaveForCreating completionHandler:^(BOOL success) {
            NSLog(@"does not exist --> create");
            [self notify];
        }];
    } else if(self.ingredientDB.documentState == UIDocumentStateClosed){
        // exists, but closed --> open
        [self.ingredientDB openWithCompletionHandler:^(BOOL success){
            NSLog(@"does exist --> open");
            [self notify];
        }];
    } else if (self.ingredientDB.documentState == UIDocumentStateNormal) {
        NSLog(@"ready");
        [self notify];
    }
    
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifyChange:) name:NSManagedObjectContextDidSaveNotification object:self.ingredientDB.managedObjectContext];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifyChange:) name:NSManagedObjectContextObjectsDidChangeNotification object:self.ingredientDB.managedObjectContext];
}

- (void) setIngredientDB:(UIManagedDocument *)ingredientDB{
    if(_ingredientDB != ingredientDB){
        _ingredientDB = ingredientDB;
        [self useDocument];
    }
}

- (ShoppingListHandler*) init{
    self = [super init];
     if(self){
         if(!self.ingredientDB){
             NSURL * url = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
             url = [url URLByAppendingPathComponent:@"Anycook Shopping Database"]; // url is now "<Documents Directory>/Anycook Shopping Database"
             self.ingredientDB = [[UIManagedDocument alloc] initWithFileURL:url];
         }
     }
     return self;
}


+ (ShoppingListHandler*) instance{
    static ShoppingListHandler * theHandler;
    
    @synchronized(self){
        if(!theHandler)
            theHandler = [[ShoppingListHandler alloc] init];
        return theHandler;
    }
}


- (void) fillWithTestData{
    [self addIngredient:@"Tomaten" withAmount:@"300g"];
    [self addIngredient:@"Kartoffeln" withAmount:@"400g"];
    [self addIngredient:@"Hackfleisch" withAmount:@"1000g"];
    [self addIngredient:@"Eier" withAmount:@"4"];
    [self.ingredientDB saveToURL:self.ingredientDB.fileURL forSaveOperation:UIDocumentSaveForOverwriting completionHandler:NULL];
}

- (void) addIngredient:(NSString*) name withAmount: (NSString*) amount {
    Ingredient * ingredient = nil;
    ingredient = [NSEntityDescription insertNewObjectForEntityForName:@"Ingredient" inManagedObjectContext:self.ingredientDB.managedObjectContext];
    ingredient.name = name;
    ingredient.menge = amount;
    NSError * error = nil;
    [self.ingredientDB.managedObjectContext save:&error];    
}

- (void) removeIngredient:(NSString*) name withAmount: (NSString*) amount{
    NSFetchRequest * request = [NSFetchRequest fetchRequestWithEntityName:@"Ingredient"];
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"name LIKE[cd] %@ ", name];
    [request setPredicate:predicate];
    NSError * error = nil;
    NSArray * array = [self.ingredientDB.managedObjectContext executeFetchRequest:request error:&error];
    if(array != nil){
        for(Ingredient * ingredient in array){
            [self.ingredientDB.managedObjectContext deleteObject:ingredient];
        }
        NSError * serror = nil;
        [self.ingredientDB.managedObjectContext save:&serror];
    } else{
        NSLog(@"error while fetching");
    }
    
    NSError * serror = nil;
    [self.ingredientDB.managedObjectContext save:&serror];
}



- (NSMutableArray*) getAllIngredients{
    NSMutableArray * ingredients = [[NSMutableArray alloc] init];
    NSLog(@"getting data from db");
    NSFetchRequest * request = [NSFetchRequest fetchRequestWithEntityName:@"Ingredient"];
    NSError * error = nil;
    NSArray * array = [self.ingredientDB.managedObjectContext executeFetchRequest:request error:&error];
    if(array != nil){
        NSLog(@"%d", [array count]);
        for (Ingredient * ingred in array) {
            NSLog(@"%@", ingred.name);
            [ingredients addObject:ingred];
        }
    }else {
        NSLog(@"error while fetching");
    }
    
    return ingredients;
}

- (NSUInteger) getIngredientNum{
    NSFetchRequest * request = [NSFetchRequest fetchRequestWithEntityName:@"Ingredient"];
    NSError * error = nil;
    NSUInteger count = [self.ingredientDB.managedObjectContext countForFetchRequest:request error:&error];
    NSLog(@"Elements in Shoppinglist: %d", count);
    return count;
}

- (void) clear{
       NSFetchRequest * request = [NSFetchRequest fetchRequestWithEntityName:@"Ingredient"];
    NSError * error = nil;
    NSArray * array = [self.ingredientDB.managedObjectContext executeFetchRequest:request error:&error];
    if(array != nil){
        for (Ingredient * ingred in array) {
            [self.ingredientDB.managedObjectContext deleteObject:ingred];
        }
         NSError * serror = nil;
        [self.ingredientDB.managedObjectContext save:&serror];
    }else {
        NSLog(@"error while fetching");
    }
    
}

- (void) save{
    [self.ingredientDB saveToURL:self.ingredientDB.fileURL forSaveOperation:UIDocumentSaveForOverwriting completionHandler:NULL];
}

@end
