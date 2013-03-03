//
//  IngredientCacheDelegate.m
//  RecipeViewPrototype
//
//  Created by Maximilian Michel on 02.06.12.
//  Copyright (c) 2012 anycook. All rights reserved.
//

#import "IngredientCacheDelegate.h"
#import "SBJson.h"

@implementation IngredientCacheDelegate

// Is called, when the Resource is loaded. From the |receivedData| an array with all ingredientnames is built.
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSMutableArray * recipeNames = [[NSMutableArray alloc] init];
    NSLog(@"Succeeded! Received %d bytes of data",[self.recievedData length]);
    NSString *jsonString = [[NSString alloc] initWithData:self.recievedData encoding:NSUTF8StringEncoding];
    NSDictionary * results = [jsonString JSONValue];
    NSArray * ingredients = [results objectForKey:@"ingredients"];
    
    for(NSDictionary * ingredient in ingredients){
        NSString * name = [ingredient objectForKey:@"name"];
        [recipeNames addObject:name];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"IngredientCacheNotification" object:recipeNames];
    
}

@end
