//
//  RecipeProtoViewController.m
//  RecipeViewPrototype
//
//  Created by Maximilian Michel on 02.05.12.
//  Copyright (c) 2012 anycook. All rights reserved.
//

#import "RecipeProtoViewController.h"
#import "RecipeProtoRecipeDelegate.h"
#import "RecipeProtoImageDelegate.h"
#import "RecipeProtoExpolreViewController.h"
#import "RecipeModel.h"
#import "Utility.h"
#import "IngredientModel.h"
#import "ShoppingListHandler.h"
#import "CachedDataHandler.h"
#import "Recipe.h"

#import "RecipeView.h"


@interface RecipeProtoViewController ()

@property (weak, nonatomic) IBOutlet UINavigationItem *navigationField;

@property (strong, nonatomic) RecipeModel * recipe;

@property (strong, nonatomic) NSMutableArray * checkedEntries;

// CoreData-Handler for shopping list and caching issues
@property (strong, nonatomic) ShoppingListHandler* handler;
@property (strong, nonatomic) CachedDataHandler * cacheHandler;

// RecipeView displaying the interface for detailed recipe information
@property (strong, nonatomic) RecipeView * recipeView;

@end

@implementation RecipeProtoViewController

@synthesize navigationField = _navigationField;
@synthesize recipe = _recipe;
@synthesize checkedEntries = _checkedEntries;
@synthesize handler = _handler;
@synthesize cacheHandler = _cacheHandler;

@synthesize recipeView = _recipeView;


// Is called by the favorite button in the navigation bar. It adds the current recipe as a favorite recipe in the cacheHandler
- (IBAction)favoriteRecipe:(id)sender {
    Recipe * recipe = [self.cacheHandler getRecipeFromCacheWithName:self.recipe.name];
    recipe.persons = self.recipe.persons;
    recipe.schmeckt = self.recipe.schmeckt;
    recipe.skill = self.recipe.skill;
    recipe.timemin = self.recipe.timemin;
    recipe.timestd = self.recipe.timestd;
    recipe.author = self.recipe.author;
    recipe.favorite = [NSNumber numberWithInt:1];
    [self.cacheHandler explicitSave];
    
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Gespeichert!" 
                                       message:@"Das Gericht wurde zu deinen Lieblingsrezepten hinzugefügt." 
                                      delegate:self cancelButtonTitle:@"Ok" 
                             otherButtonTitles:nil];
    [alert show];
    
}

// Gets a recipe by its name from the anycook API. This is a callback function if a "showRecipeNotification" is fired. The notification object |notification| contains the recipename that has to be displayed in the recipe view.
- (void) loadRecipe:(NSNotification*) notification{
    NSString * recipeName = notification.object;
    RecipeProtoRecipeDelegate * recipeDelegate = [[RecipeProtoRecipeDelegate alloc] init];
    NSString * urlString = [NSString stringWithFormat:@"http://graph.anycook.de/recipe/%@?appid=3", [recipeName urlencode]];
    NSURLRequest * request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:urlString]];
    NSURLConnection * connection = [[NSURLConnection alloc] initWithRequest:request delegate:(id)recipeDelegate];
    if(!connection)
        NSLog(@"No Connection!");
}

// This is the callback function that is called when a "RecipeNotification" occurs. The object |notification| contains a RecipeModel with all the information that has to be displayed. This model is stored in the recipe view such as in this controller as a datasource for the ingredient TableView.
- (void) updateRecipeView:(NSNotification*) notification{
    self.recipe = [notification object];
    self.recipeView.persons = [self.recipe.persons intValue];
    self.recipeView.stepper.value = [self.recipe.persons intValue];
    [self.recipeView setRecipe:self.recipe];
}

// Is called when the view did load. The |recipeView| property is initialized and datasources and delegate are set. Also subscriptions for the RecipeNotification and showRecipeNotifications are done.
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.handler = [ShoppingListHandler instance];
    NSLog(@"viewsize: %f %f %f %f ",self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
    self.recipeView = [[RecipeView alloc] initWithFrame:self.view.frame];
    self.view = self.recipeView;
    //[self.view addSubview:self.recipeView];
    
    self.recipeView.scrollView.delegate = self;
    self.recipeView.scrollView.scrollEnabled = YES;
    
    self.recipeView.ingredients.delegate = self;
    self.recipeView.ingredients.dataSource = self;
        
    [self.recipeView.stepper addTarget:self action:@selector(changedPersonsCount:) forControlEvents:UIControlEventValueChanged];
    [self.recipeView.stepper setMinimumValue:1];
    [self.recipeView.stepper setMaximumValue:99];
    [self.recipeView.stepper setWraps:YES];
    [self.recipeView.stepper setContinuous:NO];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateRecipeView:) name:@"RecipeNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadRecipe:) name:@"showRecipeNotification" object:nil];
    
    [self.navigationController.navigationBar setHidden:NO];
    
    self.cacheHandler = [CachedDataHandler instance];

}

// Is called when the stepper is used. In this case the pesoncount changed and the ingredient amounts has to be extrapolated for this new value.
- (void)changedPersonsCount:(UIStepper *)sender {
    double value = [sender value];
    [self multiplyAmountForPersons:value];
    self.recipeView.persons = value;
}

// Extrapolates the amount of ingredients for a given new |personcount|. The String is processed for measurement numbers and units. Look in the documentation for a more detailed description of this algorithm.
- (void) multiplyAmountForPersons:(NSInteger) personcount{
    NSInteger oldPersonscount = self.recipeView.persons;
    
    for(IngredientModel * ingredient in self.recipe.ingredients){
        NSArray *amountSplit = [ingredient.menge componentsSeparatedByCharactersInSet:
                            [NSCharacterSet characterSetWithCharactersInString:@" "]
                            ];
        NSString *resultstring = @"";
        for(NSString * split in amountSplit){
            
            NSRange range = [split rangeOfString:@"/"
                                         options:NSCaseInsensitiveSearch];
            if(range.location != NSNotFound) {
                NSArray *splitsplit = [split componentsSeparatedByString: @"/"];
                double quotient = [[splitsplit objectAtIndex:0] doubleValue] / [[splitsplit objectAtIndex:1] doubleValue];
                NSLog(@"quotient: %f / %f = %f", [[splitsplit objectAtIndex:0] doubleValue], [[splitsplit objectAtIndex:1] doubleValue], quotient);
                resultstring = [resultstring stringByAppendingString:[self extrapolate:quotient withA:oldPersonscount andB: personcount]];
                resultstring = [resultstring stringByAppendingString:@" "];
                continue;
            }
            
            range = [split rangeOfString:@"-"
                                         options:NSCaseInsensitiveSearch];
            if(range.location != NSNotFound) {
                NSArray *splitsplit = [split componentsSeparatedByString: @"-"];
                double median = ([[splitsplit objectAtIndex:0] doubleValue] + [[splitsplit objectAtIndex:1] doubleValue]) / 2;
                resultstring = [resultstring stringByAppendingString:[self extrapolate:median withA:oldPersonscount andB: personcount]];
                resultstring = [resultstring stringByAppendingString:@" "];
                continue;
            }
            
            
            resultstring = [resultstring stringByAppendingString:[self processString:split forOldAmount:oldPersonscount andNewAmount:(NSInteger) personcount]];
            resultstring = [resultstring stringByAppendingString:@" "];
            
        }
        resultstring = [resultstring stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        ingredient.menge = resultstring;
    }
    
    [self.recipeView.ingredients reloadData];
}

// Extrapolates a given double |number| with the old value |a| for the new value |b|
- (NSString*) extrapolate:(double)number withA:(NSInteger)a andB:(NSInteger)b{
    number = (number / (double)a) * (double)b;
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    NSString * numberString = [numberFormatter stringFromNumber:[NSNumber numberWithDouble:number]];
    numberString = [numberString stringByReplacingOccurrencesOfString:@"." withString:@","];
    return numberString;
}

// Extracts from a given String |split| the numbers and extrapolates them with the amounts |old| and |new|. The resulting number is then converted to a string. If the String does not contain any Numbers, the source string is returned.
- (NSString*) processString:(NSString*)split forOldAmount:(NSInteger) old andNewAmount:(NSInteger) new{
    NSScanner *scanner = [NSScanner scannerWithString:split];
    NSCharacterSet *numbers = [NSCharacterSet characterSetWithCharactersInString:@"0123456789,"];
    NSString *noNumberString;
    [scanner scanCharactersFromSet:[NSCharacterSet letterCharacterSet] intoString:&noNumberString];
    NSString *numberString;
    [scanner scanCharactersFromSet:numbers intoString:&numberString];
    
    if([numberString length] != 0){
        numberString = [numberString stringByReplacingOccurrencesOfString:@"," withString:@"."];
        double number = [numberString doubleValue];
        NSString * resultstring = [self extrapolate:number withA: old andB: new];
        if([noNumberString length] != 0)
            resultstring = [resultstring stringByAppendingString: noNumberString];
        return resultstring;
    }
    
    return split;
}

- (void)viewDidUnload
{
    [self setNavigationField:nil];
    [super viewDidUnload];
}

// Sets the step information of the recipe for the StepView that is connected with a segue
- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.destinationViewController respondsToSelector:@selector(setSteps:)]){
        [segue.destinationViewController setSteps:self.recipe.steps];
    }
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark - Table view delegate

// Sets the number of rows in the ingredient tableview
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.recipe.ingredients count];
}

// Sets the data of each cell in the table view based on the ingredient data stored in [self.recipe|.
- (UITableViewCell* )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"ingredientCell"];
    if(!cell)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"ingredientCell"];
    
    IngredientModel * ingredient = [self.recipe.ingredients objectAtIndex:indexPath.row];
    cell.textLabel.text = ingredient.name;
    cell.detailTextLabel.text = ingredient.menge;
    cell.textLabel.font = [UIFont fontWithName:@"Palatino-Italic" size:15];
    cell.textLabel.textColor = [UIColor grayColor];
    cell.detailTextLabel.font = [UIFont fontWithName:@"Palatino-Italic" size:15];
    cell.detailTextLabel.textColor = [UIColor grayColor];
    
    if([self.checkedEntries containsObject:ingredient.name])
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    else 
        cell.accessoryType = UITableViewCellAccessoryNone;
    
    return cell;
}

// Sets the height of each row in the ingredient table view to 30
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 30;
}

// Sets the number of sections in the ingredients tableview to 1
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

// Is called when a row in the ingredients tableview is selected. At this point the selected ingredient is either added or removed to the shopping list core data database. A shoppinglistChanged notification is posted, that updates the cookbook badge in the TabBar.
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    IngredientModel* ingredient = [self.recipe.ingredients objectAtIndex:indexPath.row];
    
    if(!self.checkedEntries)
        self.checkedEntries = [[NSMutableArray alloc] init];
    
    if([self.checkedEntries containsObject:ingredient.name]){
        [self.checkedEntries removeObject:ingredient.name];
        [self.handler removeIngredient:ingredient.name withAmount:ingredient.menge];
        //[Utility decrementBadgeOfTabBarItem:kochbuch];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"shoppinglistChanged" object:self];
        [self.handler save];
    }
    else{ 
        [self.checkedEntries addObject:ingredient.name];
        [self.handler addIngredient:ingredient.name withAmount:ingredient.menge];
        //[Utility incrementBadgeOfTabBarItem:kochbuch];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"shoppinglistChanged" object:self];
        [self.handler save];
    }
    [tableView reloadData];
}



@end
