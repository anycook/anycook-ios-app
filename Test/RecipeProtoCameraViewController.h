//
//  RecipeProtoCameraViewController.h
//  RecipeViewPrototype
//
//  Created by Maximilian Michel on 10.06.12.
//  Copyright (c) 2012 anycook. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XBFilteredCameraView.h"

// ViewController of the CameraView
@interface RecipeProtoCameraViewController : UIViewController<UITextFieldDelegate>

// Name of the Picture is a public property. If the Camera is opened from a recipe, the name is set to the recipename.
@property (strong, nonatomic) NSString * name;

@end
