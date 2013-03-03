//
//  RecipeProtoFavoritesViewController.m
//  RecipeViewPrototype
//
//  Created by Maximilian Michel on 05.07.12.
//  Copyright (c) 2012 anycook. All rights reserved.
//

#import "RecipeProtoFavoritesViewController.h"
#import "RecipeProtoExploreDelegate.h"
#import "Recipe.h"
#import "Utility.h"
#import "CachedDataHandler.h"

@interface RecipeProtoFavoritesViewController ()

// Array of recipe name represents the datasource for the TableView
@property (strong, nonatomic) NSMutableArray * favorites;

@end

@implementation RecipeProtoFavoritesViewController

@synthesize favorites = _favorites;

// Callback method of a click of the cancerl
- (IBAction)cancelModal:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

// Callback function of the LocalDBReadyNotification is called, when the local cache database is initialized. All favorite recipes are saved to |favorites| and the tableView is reloaded.
- (void) showFavorites{
    self.favorites = [[CachedDataHandler instance] getFavoriteRecipes];
    [self.tableView reloadData];
}

// Is called, when the view did load. The |cacheHandler| is initialized and self subscribes the LocalDBReadyNotification
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.favorites = [[NSMutableArray alloc] init];
    [self.view setBackgroundColor:[Utility getPaperGray]];
    [self showFavorites];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

// Return the number of sections: 1.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

// Return the number of rows in the section |section|: number of elements in the |favorites| container
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.favorites count];
}

// Builds a cell for each row at position |indexPath|.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    
    cell.textLabel.text = [self.favorites objectAtIndex:indexPath.row];
    cell.textLabel.font = [UIFont fontWithName:@"Georgia-Italic" size:18];
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    [cell setAccessoryType:UITableViewCellEditingStyleDelete];
    return cell;
}



#pragma mark - Table view delegate
// Callback, if a cell is selected. The current view is canceled and TODO: the recipe is displayed.
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"showFavoritRecipe" sender:self];
    NSString * tappedrecipe = [[[tableView cellForRowAtIndexPath:indexPath] textLabel] text];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"loadRecipeNotification" object:tappedrecipe];
    [self cancelModal:nil];
}


@end
