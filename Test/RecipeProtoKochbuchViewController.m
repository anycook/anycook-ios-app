//
//  RecipeProtoKochbuchViewController.m
//  RecipeViewPrototype
//
//  Created by Maximilian Michel on 06.06.12.
//  Copyright (c) 2012 anycook. All rights reserved.
//

#import "RecipeProtoKochbuchViewController.h"
#import "Utility.h"

@interface RecipeProtoKochbuchViewController ()


@end

@implementation RecipeProtoKochbuchViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


// Is called after View did load. The background color is set and the doodle image is added to the view.
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor colorWithRed:0.941 green:0.937 blue:0.922 alpha:1]];
    
    //UIImageView * doodleImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"doodle.png"]];
    //[doodleImage setCenter:CGPointMake(160, 180)];
    //[self.view addSubview:doodleImage];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
}

@end
