//
//  RecipeProtoFilterViewController.h
//  RecipeViewPrototype
//
//  Created by Maximilian Michel on 09.07.12.
//  Copyright (c) 2012 anycook. All rights reserved.
//

#import <UIKit/UIKit.h>

// ViewController of the Filter TableView
@interface RecipeProtoFilterViewController : UITableViewController

// Model container, containing all ingredients
@property (nonatomic, strong) NSMutableArray * filter_ingredients;

@end
