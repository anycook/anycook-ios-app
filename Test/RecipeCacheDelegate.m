//
//  RecipeCacheDelegate.m
//  RecipeViewPrototype
//
//  Created by Maximilian Michel on 31.05.12.
//  Copyright (c) 2012 anycook. All rights reserved.
//

#import "RecipeCacheDelegate.h"
#import "SBJson.h"

@implementation RecipeCacheDelegate

// Is called, when the Resource is loaded. From the |receivedData| an array with all recipenames is built.
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{

    NSMutableArray * recipeNames = [[NSMutableArray alloc] init];
    NSLog(@"Succeeded! Received %d bytes of data",[self.recievedData length]);
    NSString *jsonString = [[NSString alloc] initWithData:self.recievedData encoding:NSUTF8StringEncoding];
    NSDictionary * results = [jsonString JSONValue];
    NSArray * names = [results objectForKey:@"names"];
    
    for(NSString * name in names){
        //NSLog(@"%@", name);
        [recipeNames addObject:name];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"RecipeCacheNotification" object:recipeNames];
    
}

@end
