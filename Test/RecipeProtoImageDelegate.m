//
//  RecipeProtoImageDelegate.m
//  RecipeViewPrototype
//
//  Created by Maximilian Michel on 09.05.12.
//  Copyright (c) 2012 anycook. All rights reserved.
//

//NSNotification

#import "RecipeProtoImageDelegate.h"

@implementation RecipeProtoImageDelegate

@synthesize imageView = _imageView;

// Callback function is called, when the resource is completly loaded. From the |recievedData| an image is created and saved in the |imageView| property.
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    UIImage * image = [[UIImage alloc] initWithData:self.recievedData];
    if(!self.imageView)
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 95, 95)];
    self.imageView.image = image;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ImageNotification" object:image];
}

@end
