//
//  PhotoThumbnail.h
//  anycook
//
//  Created by Maximilian Michel on 21.09.12.
//  Copyright (c) 2012 anycook. All rights reserved.
//

#import <UIKit/UIKit.h>

// Represents the View of one PhotoThumbnail in the photo gallery. It has two subviews: one for the thumbnail image and one for the corresponding textlabel
@interface PhotoThumbnail : UIView

// Subviews
@property (strong, nonatomic) UIImageView * imageView;
@property (strong, nonatomic) UILabel * label;

// Setter for image and labeltext
- (void) setImage:(UIImage *)image;
- (void) setLabelText:(NSString *)text;

@end
