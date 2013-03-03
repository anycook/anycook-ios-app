//
//  PhotoThumbnail.m
//  anycook
//
//  Created by Maximilian Michel on 21.09.12.
//  Copyright (c) 2012 anycook. All rights reserved.
//

#import "PhotoThumbnail.h"
#import "Utility.h"

@implementation PhotoThumbnail

@synthesize imageView= _imageView;
@synthesize label = _label;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 150, 150)];
        self.label = [[UILabel alloc] initWithFrame:CGRectMake(0, 150, 150, 20)];
        [self.label setBackgroundColor:[Utility getPaperGray]];
        [self.label setFont:[UIFont fontWithName:@"Palatino" size:12]];
        
        [self addSubview:self.imageView];
        [self addSubview:self.label];
    }
    return self;
}

- (void) setImage:(UIImage *)image{
    self.imageView.image = image;
}

- (void) setLabelText:(NSString *)text{
    self.label.text = text;
}

@end
