//
//  RecipeImageView.m
//  RecipeViewPrototype
//
//  Created by Maximilian Michel on 16.05.12.
//  Copyright (c) 2012 anycook. All rights reserved.
//

#import "RecipeImageView.h"

@implementation RecipeImageView

@synthesize recipename = _recipename;

- (id)init{
    self = [super init];
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [self addGestureRecognizer:tap];
    return self;
}

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [self addGestureRecognizer:tap];
    return self;
}


- (void) handleTap:(UITapGestureRecognizer*)sender{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ExploreTap" object:self.recipename];
}


@end
