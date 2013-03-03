//
//  Recipe.m
//  RecipeViewPrototype
//
//  Created by Maximilian Michel on 08.05.12.
//  Copyright (c) 2012 anycook. All rights reserved.
//

#import "RecipeModel.h"
#import "SBJson.h"
#import "IngredientModel.h"
#import "Ingredient.h"
#import "Step.h"

@implementation RecipeModel

@synthesize name = _name;
@synthesize description = _description;
@synthesize tags = _tags;
@synthesize schmeckt = _schmeckt;
@synthesize persons = _persons;
@synthesize author = _author;
@synthesize calories = _calories;
@synthesize skill = _skill;
@synthesize timemin = _timemin;
@synthesize steps = _steps;
@synthesize timestd = _timestd;
@synthesize ingredients = _ingredients;
@synthesize category = _category;
@synthesize thumbnail = _thumbnail;


- (RecipeModel*) initWithJSON:(NSString *) jsonString{
    NSDictionary * results = [jsonString JSONValue];
    
    RecipeModel * recipe = [[RecipeModel alloc] init];
    
    recipe.name = [results objectForKey:@"name"];
    recipe.category = [results objectForKey:@"category"];
    recipe.description = [results objectForKey:@"description"];
    recipe.persons = [results objectForKey:@"person"];
    recipe.schmeckt = [results objectForKey:@"schmeckt"];
    recipe.timemin = [results objectForKey:@"timemin"];
    recipe.timestd = [results objectForKey:@"timestd"];
    
    recipe.steps = [[NSMutableArray alloc] init];
    
    NSArray * steps = [results objectForKey:@"steps"];
    for(NSDictionary * step in steps){
        NSString * text = [step objectForKey:@"text"];
        NSLog(@"%@", text);
        [recipe.steps addObject:text];
    }
    
    //"authors":[{"id":4,"name":"Mara Krug"}
    NSArray * authors = [results objectForKey:@"authors"];
    NSDictionary * last = [authors lastObject];
    recipe.author = [last objectForKey:@"name"];
    
    
    recipe.ingredients = [[NSMutableArray alloc] init];
    NSArray * ingredients = [results objectForKey:@"ingredients"];    
    for(NSDictionary * ingredient in ingredients){
        IngredientModel * inobj = [[IngredientModel alloc] initWithDictionary:ingredient];
        [recipe.ingredients addObject:inobj]; 
    }

    return recipe;
}

- (RecipeModel*) initWithRecipe:(Recipe *)recipeIn{
    RecipeModel * recipe = [[RecipeModel alloc] init];
    recipe.name = recipeIn.name;
    recipe.category = recipeIn.category;
    recipe.description = recipeIn.description_text;
    recipe.persons = recipeIn.persons;
    recipe.schmeckt = recipeIn.schmeckt;
    recipe.timemin = recipeIn.timemin;
    recipe.timestd = recipeIn.timestd;
    
    recipe.steps = [[NSMutableArray alloc] init];
    
    NSSet * stepSet = recipeIn.steps;
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"step_number" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];

    NSArray * steps = [stepSet sortedArrayUsingDescriptors:sortDescriptors];
    
    for(Step * step in steps){
        NSString * text = step.text;
        NSLog(@"%@", text);
        [recipe.steps addObject:text];
    }
    
    recipe.author = recipeIn.author;
    
    
    recipe.ingredients = [[NSMutableArray alloc] init];
    NSSet * ingredients = [recipeIn ingredients];
    for(Ingredient * ingredient in ingredients){
        IngredientModel * inobj = [[IngredientModel alloc] init];
        inobj.name = ingredient.name;
        inobj.menge = ingredient.menge;
        inobj.singular = ingredient.singular;
        
        [recipe.ingredients addObject:inobj];
    }
    
    return recipe;

}

@end
