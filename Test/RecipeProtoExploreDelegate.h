//
//  RecipeProtoExploreDelegate.h
//  RecipeViewPrototype
//
//  Created by Maximilian Michel on 09.05.12.
//  Copyright (c) 2012 anycook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ResourceDelegate.h"
#import "RecipeProtoExpolreViewController.h"

// Enumeration holding the type of exploring: beliebt, leckerste or saisonal
enum ExploreType{
    BELIEBT,
    LECKERSTE,
    SAISONAL,
};

// Delegate that is handling the response of the request that is getting all the recipes for the explore view
@interface RecipeProtoExploreDelegate : ResourceDelegate

// Type of recipes to be shown
@property enum ExploreType type;

@end
