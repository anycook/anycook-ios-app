//
//  RecipeResultCell.m
//  RecipeViewPrototype
//
//  Created by Maximilian Michel on 20.06.12.
//  Copyright (c) 2012 anycook. All rights reserved.
//

#import "RecipeResultCell.h"
#import "RecipeProtoImageDelegate.h"

@interface RecipeResultCell ()
// Timelabel showing the preperation time
@property (strong, nonatomic) UILabel * timeLabel;
// RecipeModel to be displayed
@property (strong, nonatomic) RecipeModel * recipe;
@end

@implementation RecipeResultCell

@synthesize timeLabel = _timeLabel;
@synthesize recipe = _recipe;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier recipe:(RecipeModel*) recipe
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.textLabel.text = recipe.name;
        self.textLabel.font = [UIFont fontWithName:@"Palatino-Bold" size:14];
        self.recipe = recipe;
        
        [self setBackgroundColor:[UIColor colorWithRed:0.941 green:0.937 blue:0.922 alpha:1]];
        
        [self.imageView setImage:recipe.thumbnail];
        self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 45, 20)];
        [self.timeLabel setFont:[UIFont fontWithName:@"Palatino" size:12]];
        self.timeLabel.backgroundColor = [UIColor colorWithRed:0.941 green:0.937 blue:0.922 alpha:1];
        
        NSString * std = @"";
        if([recipe.timestd intValue]<10)
            std = [NSString stringWithFormat:@"0%@", [recipe.timestd stringValue]];
        else
            std = [recipe.timestd stringValue];
        
        
        NSString * min = @"";
        if([recipe.timemin intValue]<10)
            min = [NSString stringWithFormat:@"0%@", [recipe.timemin stringValue]];
        else
            min = [recipe.timemin stringValue];
        
        self.timeLabel.text = [NSString stringWithFormat:@"%@:%@ h", std, min];
        self.timeLabel.center = CGPointMake(50, 90);
        self.timeLabel.textAlignment = UITextAlignmentCenter;
        [self.contentView addSubview:self.timeLabel];
        
        self.detailTextLabel.font = [UIFont fontWithName:@"Palatino-Italic" size:14];
        if ([recipe.schmeckt intValue] > 1) {
            self.detailTextLabel.text = [NSString stringWithFormat:@"Schmeckt %@ Personen", [recipe.schmeckt stringValue]];
        }
        
    }
    
    return self;
    
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
