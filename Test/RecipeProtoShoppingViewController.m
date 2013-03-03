//
//  RecipeProtoShoppingViewController.m
//  RecipeViewPrototype
//
//  Created by Maximilian Michel on 29.05.12.
//  Copyright (c) 2012 anycook. All rights reserved.
//

#import "RecipeProtoShoppingViewController.h"
#import "Ingredient.h"
#import "ShoppingListHandler.h"
#import "Utility.h"

@interface RecipeProtoShoppingViewController ()

// Array consinsting of Ingredients represent the datasource of the TableView
@property (strong, nonatomic) NSMutableArray * ingredients;

@end

@implementation RecipeProtoShoppingViewController

@synthesize ingredients = _ingredients;

// Callback method, if cancel button is pressed. The current modal view is canceled.
- (IBAction)cancelModal:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}

// Deletes all objects in the ShoppingList View
- (IBAction)clearAll:(id)sender {
    ShoppingListHandler * handler = [ShoppingListHandler instance];
    [handler clear];
    [self.tableView reloadData];
    UITabBarItem * kochbuch = [self.navigationController.tabBarController.tabBar.items objectAtIndex:1];
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
    }
    return self;
}

// Is called, when the view did load. The right backgroundcolor of the view is set.
- (void)viewDidLoad
{
    [super viewDidLoad];
    UIColor * papergray = [UIColor colorWithRed:0.941 green:0.937 blue:0.922 alpha:1];
    [self.view setBackgroundColor:papergray];
    self.clearsSelectionOnViewWillAppear = NO;
}

// Callback method of DBReadyNotification. The database is intialized and the
- (void) refresh:(NSNotification*)notification{
    ShoppingListHandler * handler = [ShoppingListHandler instance];
    self.ingredients = [handler getAllIngredients];
    [self.tableView reloadData];
}

// Is called before the view appears. The ShoppingListHandler is initialized and the TableViewController is subscribed to the DBReadyNotification.
- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    ShoppingListHandler * handler = [ShoppingListHandler instance];
    self.ingredients = [handler getAllIngredients];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refresh:) name:@"DBReadyNotification" object:nil];
    [self.tableView reloadData];
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

// Return the number of sections: 1
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

// Return the number of rows in the section: number of Ingredient elements in |ingredients|
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.ingredients count];
}

// Builds a cell with the matching ingredient information at position |indexPath|
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ShoppingCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    Ingredient * ingredient = [self.ingredients objectAtIndex:indexPath.row]; 
    cell.textLabel.text = ingredient.name;
    cell.detailTextLabel.text = ingredient.menge;
     cell.textLabel.font = [UIFont fontWithName:@"Georgia-Italic" size:18];
    return cell;
}


#pragma mark - Table view delegate

// Callback method is called, when a cell at Path |indexPath| was selected. The selected ingredient is deleted from the shopping list database.
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Ingredient * ingredient = [self.ingredients objectAtIndex:indexPath.row];
        ShoppingListHandler * handler = [ShoppingListHandler instance];
    
    [self.ingredients removeObject:ingredient];
    [handler removeIngredient:ingredient.name withAmount:ingredient.menge];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"shoppinglistChanged" object:self];
    
    [handler save];
    
    [self.tableView reloadData];
}

@end
