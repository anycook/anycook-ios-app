//
//  RecipeProtoTabBarViewController.m
//  RecipeViewPrototype
//
//  Created by Maximilian Michel on 02.07.12.
//  Copyright (c) 2012 anycook.de. All rights reserved.
//

#import "RecipeProtoTabBarViewController.h"
#import "ShoppingListHandler.h"

@interface RecipeProtoTabBarViewController ()

@end

@implementation RecipeProtoTabBarViewController


// Standard initialization
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

// Callback of the shoopinglistChanged Notification. The badge of the Kochbuch-item in the bar is set to the current number of entries in the shoppinglist database.
- (void) updateBadge:(NSNotification*)notification{
    ShoppingListHandler * slh = [ShoppingListHandler instance];
    NSUInteger count = [slh getIngredientNum];
    UITabBarItem * kochbuch = [self.tabBar.items objectAtIndex:1];
    
    if(count == 0)
        [kochbuch setBadgeValue:nil];
    else
        [kochbuch setBadgeValue:[NSString stringWithFormat:@"%d",count]];
}

// Is called, when the view did load. The TabBar subscribes the shoppinglistChanged Notification and all icons are set for the TabBar items.
- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateBadge:) name:@"shoppingListChangedNotification" object:nil];
    for(UITabBarItem * item in self.tabBar.items){
        [item setFinishedSelectedImage:item.image withFinishedUnselectedImage:item.image];
    }
    
    [[self.tabBar.items objectAtIndex:0] setFinishedSelectedImage:[UIImage imageNamed:@"search-sel.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"search.png"]];
    [[self.tabBar.items objectAtIndex:1] setFinishedSelectedImage:[UIImage imageNamed:@"kochbuch-active.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"kochbuch-inactive.png"]];
    [[self.tabBar.items objectAtIndex:2] setFinishedSelectedImage:[UIImage imageNamed:@"entdecken-sel.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"entdecken.png"]];
    
	// Do any additional setup after loading the view.
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

@end
