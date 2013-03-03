//
//  RecipeImageView.h
//  RecipeViewPrototype
//
//  Created by Maximilian Michel on 16.05.12.
//  Copyright (c) 2012 anycook. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecipeImageView : UIImageView<UIGestureRecognizerDelegate>

- (void) handleTap:(UITapGestureRecognizer*)sender;
@property (strong,nonatomic) NSString * recipename;

@end
