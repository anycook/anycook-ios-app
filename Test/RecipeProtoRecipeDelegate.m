//
//  RecipeProtoRecipeDelegate.m
//  RecipeViewPrototype
//
//  Created by Maximilian Michel on 07.05.12.
//  Copyright (c) 2012 anycook. All rights reserved.
//

#import "RecipeProtoRecipeDelegate.h"
#import "SBJson.h"

@implementation RecipeProtoRecipeDelegate

// Callback function is called, when the resource is completly loaded. From the |recievedData| a RecipeModel object is built and attached to a RecipeNotification.
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if ([self.recievedData length] == 0) {
        return;
    }
    NSString *jsonString = [[NSString alloc] initWithData:self.recievedData encoding:NSUTF8StringEncoding];
    
    RecipeModel * recipe = [[RecipeModel alloc] initWithJSON:jsonString];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"RecipeNotification" object:recipe];
}

@end
