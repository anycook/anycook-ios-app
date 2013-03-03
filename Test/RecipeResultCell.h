//
//  RecipeResultCell.h
//  RecipeViewPrototype
//
//  Created by Maximilian Michel on 20.06.12.
//  Copyright (c) 2012 anycook. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecipeModel.h"

// Implementation of a TableViewCell presenting recipe information
@interface RecipeResultCell : UITableViewCell

// Intialization with a RecipeModel.
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier recipe:(RecipeModel*) recipe;

@end
