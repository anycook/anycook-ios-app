//
//  Tag.h
//  anycook
//
//  Created by Maximilian Michel on 02.10.12.
//  Copyright (c) 2012 anycook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Recipe;

@interface Tag : NSManagedObject

@property (nonatomic, retain) NSString * text;
@property (nonatomic, retain) Recipe *recipes;

@end
