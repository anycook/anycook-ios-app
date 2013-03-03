//
//  RecipeProtoSearchDelegate.h
//  RecipeViewPrototype
//
//  Created by Maximilian Michel on 07.05.12.
//  Copyright (c) 2012 anycook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ResourceDelegate.h"

// Delegate that is handling the response of the request that is searching for recipes
@interface RecipeProtoSearchDelegate : ResourceDelegate

// Array containing all recipe objects (result of search)
@property (nonatomic, strong) NSMutableArray * recipes;

@end
