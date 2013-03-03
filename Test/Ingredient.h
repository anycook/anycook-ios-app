//
//  Ingredient.h
//  anycook
//
//  Created by Maximilian Michel on 02.10.12.
//  Copyright (c) 2012 anycook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Ingredient, Recipe, Step;

@interface Ingredient : NSManagedObject

@property (nonatomic, retain) NSString * menge;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * singular;
@property (nonatomic, retain) NSString * recipe;
@property (nonatomic, retain) NSSet *children;
@property (nonatomic, retain) Step *newRelationship;
@property (nonatomic, retain) Ingredient *parent;
@property (nonatomic, retain) Recipe *recipes;
@end

@interface Ingredient (CoreDataGeneratedAccessors)

- (void)addChildrenObject:(Ingredient *)value;
- (void)removeChildrenObject:(Ingredient *)value;
- (void)addChildren:(NSSet *)values;
- (void)removeChildren:(NSSet *)values;

@end
