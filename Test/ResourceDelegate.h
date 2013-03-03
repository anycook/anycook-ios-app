//
//  ResourceDelegate.h
//  RecipeViewPrototype
//
//  Created by Maximilian Michel on 09.05.12.
//  Copyright (c) 2012 anycook. All rights reserved.
//

#import <Foundation/Foundation.h>

// Basis class for all Delegates that handle a connection to the anycook API.
@interface ResourceDelegate : NSObject

// Property for collecting the data
@property (nonatomic,strong) NSMutableData * recievedData;

@end
