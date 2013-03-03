//
//  Recipe.h
//  anycook
//
//  Created by Maximilian Michel on 02.10.12.
//  Copyright (c) 2012 anycook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Ingredient, Step, Tag;

@interface Recipe : NSManagedObject

@property (nonatomic, retain) NSString * author;
@property (nonatomic, retain) NSNumber * calories;
@property (nonatomic, retain) NSString * category;
@property (nonatomic, retain) NSString * description_text;
@property (nonatomic, retain) NSNumber * favorite;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * persons;
@property (nonatomic, retain) NSNumber * schmeckt;
@property (nonatomic, retain) NSNumber * skill;
@property (nonatomic, retain) NSNumber * timemin;
@property (nonatomic, retain) NSNumber * timestd;
@property (nonatomic, retain) NSSet *ingredients;
@property (nonatomic, retain) NSSet *steps;
@property (nonatomic, retain) NSSet *tags;
@end

@interface Recipe (CoreDataGeneratedAccessors)

- (void)addIngredientsObject:(Ingredient *)value;
- (void)removeIngredientsObject:(Ingredient *)value;
- (void)addIngredients:(NSSet *)values;
- (void)removeIngredients:(NSSet *)values;

- (void)addStepsObject:(Step *)value;
- (void)removeStepsObject:(Step *)value;
- (void)addSteps:(NSSet *)values;
- (void)removeSteps:(NSSet *)values;

- (void)addTagsObject:(Tag *)value;
- (void)removeTagsObject:(Tag *)value;
- (void)addTags:(NSSet *)values;
- (void)removeTags:(NSSet *)values;

@end
