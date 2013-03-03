//
//  Ingredient.m
//  RecipeViewPrototype
//
//  Created by Maximilian Michel on 14.05.12.
//  Copyright (c) 2012 anycook. All rights reserved.
//

#import "IngredientModel.h"
#import "SBJson.h"

@implementation IngredientModel

@synthesize name = _name;
@synthesize menge = _menge;
@synthesize singular = _singular;
@synthesize children = _children;

- (IngredientModel*) initWithJson:(NSString *)jsonString{
    NSDictionary * values = [jsonString JSONValue];
    IngredientModel * ingredient = [[IngredientModel alloc] init];
    
    ingredient.name = [values objectForKey:@"neme"];
    ingredient.menge = [values objectForKey:@"menge"];
    ingredient.singular = [values objectForKey:@"singular"];
    ingredient.children = [[NSMutableArray alloc] init];
    
    NSArray * children = [values objectForKey:@"children"];
    for(NSDictionary * child in children){
        IngredientModel * childingredient = [[IngredientModel alloc] initWithDictionary:child];
        [ingredient.children addObject:childingredient];
    }
    
    return ingredient;    
}

- (IngredientModel*) initWithDictionary:(NSDictionary *) dictionary{
    IngredientModel * ingredient = [[IngredientModel alloc] init];
    
    ingredient.name = [dictionary objectForKey:@"name"];
    ingredient.menge = [dictionary objectForKey:@"menge"];
    ingredient.singular = [dictionary objectForKey:@"singular"];
    ingredient.children = [[NSMutableArray alloc] init];
    
    NSArray * children = [dictionary objectForKey:@"children"];
    for(NSDictionary * child in children){
        IngredientModel * childingredient = [[IngredientModel alloc] initWithDictionary:child];
        [ingredient.children addObject:childingredient];
    }
    
    return ingredient;    
}


@end
