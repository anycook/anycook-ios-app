//
//  RecipeProtoSearchDelegate.m
//  RecipeViewPrototype
//
//  Created by Maximilian Michel on 07.05.12.
//  Copyright (c) 2012 anycook. All rights reserved.
//

#import "RecipeProtoSearchDelegate.h"
#import "SBJson.h"
#import "RecipeModel.h"
#import "Utility.h"

@implementation RecipeProtoSearchDelegate

@synthesize recipes = _recipes;

- (id)init{
    self = [super init];
    self.recipes = [[NSMutableArray alloc] init];
    return self;
}

- (void) setRecipes:(NSMutableArray *)recipes{
    if(_recipes == nil)
        _recipes = [[NSMutableArray alloc] init];
}

// Callback function is called, when the resource is completly loaded. From the |recievedData| a list of RecipeModel objects is built
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog(@"Succeeded! Received %d bytes of data",[self.recievedData length]);
    NSString *jsonString = [[NSString alloc] initWithData:self.recievedData encoding:NSUTF8StringEncoding];
    NSDictionary * results = [jsonString JSONValue];
    NSArray * recipes = [results objectForKey:@"recipes"];
    
    for(NSDictionary * recipe in recipes){
        RecipeModel * recipeObject = [[RecipeModel alloc] init];
        recipeObject.name = [recipe objectForKey:@"name"];
        recipeObject.timemin = [recipe objectForKey:@"timemin"];
        recipeObject.timestd = [recipe objectForKey:@"timestd"];
        recipeObject.schmeckt = [recipe objectForKey:@"schmecktNum"];
        recipeObject.thumbnail = [Utility loadThumbnailForName:recipeObject.name];
        [self.recipes addObject:recipeObject];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SearchNotification" object:self.recipes];
    
}


@end
