//
//  RecipeProtoImageDelegate.h
//  RecipeViewPrototype
//
//  Created by Maximilian Michel on 09.05.12.
//  Copyright (c) 2012 anycook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ResourceDelegate.h"
#import <UIKit/UIKit.h>

// Delegate that is handling the response of the request that is getting an image
@interface RecipeProtoImageDelegate : ResourceDelegate<UIGestureRecognizerDelegate>

// ImageView containing the image made from the data of the request
@property (strong, nonatomic) UIImageView * imageView;

@end
