//
//  OverlaySearchResultViewController.m
//  RecipeViewPrototype
//
//  Created by Maximilian Michel on 19.06.12.
//  Copyright (c) 2012 anycook. All rights reserved.
//

#import "OverlaySearchResultViewController.h"
#import "CachedDataHandler.h"
#import "RecipeProtoSearchDelegate.h"
#import "RecipeModel.h"
#import "RecipeResultCell.h"
#import "Utility.h"
#import <QuartzCore/QuartzCore.h>
#import "RecipeProtoFilterViewController.h"

@interface OverlaySearchResultViewController ()

@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) UIBarButtonItem * barbutton;
@property (strong, nonatomic) CachedDataHandler * cachedDataHandler;
// Views of the SearchView
@property (strong, nonatomic) UITableView * autocompleteView;
@property (strong, nonatomic) UIView * overlayView;
@property (strong, nonatomic) UIView * progressView;
@property (strong, nonatomic) UIView * emptyView;
// Data sources for the TableViews
@property (strong, nonatomic) NSMutableArray * results;
@property (strong, nonatomic) NSMutableArray * auto_recipes;
@property (strong, nonatomic) NSMutableArray * auto_ingredients;
@property (strong, nonatomic) NSMutableArray * filter_ingredients;

@property float maxsim_recipes;
@property float maxsim_ingredients;

@end

@implementation OverlaySearchResultViewController

@synthesize searchBar;
@synthesize autocompleteView=_autocompleteView;
@synthesize emptyView = _emptyView;
@synthesize overlayView = _overlayView;
@synthesize results = _results;
@synthesize auto_recipes = _auto_recipes;
@synthesize auto_ingredients = _auto_ingredients;
@synthesize filter_ingredients = _filter_ingredients;
@synthesize progressView = _progressView;
@synthesize barbutton = _barbutton;
@synthesize maxsim_recipes = _maxsim_recipes;
@synthesize maxsim_ingredients = _maxsim_ingredients;
@synthesize cachedDataHandler = _cachedDataHandler;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

// Shows the TableView with the Filters as a modal
- (void) toggleFilter{
    [self performSegueWithIdentifier:@"showFilter" sender:self];
}

// Hides all overlaying views
- (void) hideOverlay{
    [self.overlayView setHidden:YES];
    [self.searchBar resignFirstResponder];
    [self.emptyView setHidden:YES];
}

// Is called when the view did load. All views are initialized added and placed. All delegates are set. The ViewController subscribes the SearchNotification and UpdatedFilterNotification
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.barbutton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"kochtopf.png"] style:UIBarButtonItemStyleBordered target:self action:@selector(toggleFilter)];
    self.navigationItem.rightBarButtonItem = self.barbutton;
    

    [self.searchBar setAutocorrectionType:UITextAutocorrectionTypeNo];
    
    
    CGFloat yoffset = self.navigationController.navigationBar.frame.size.height;
    
    yoffset += self.tabBarController.tabBar.frame.size.height;
    CGFloat width = self.tableView.frame.size.width;
    CGFloat height = self.tableView.frame.size.height;
    
    
    self.emptyView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, height-yoffset)];
    
    [self.emptyView setBackgroundColor:[UIColor colorWithRed:0.941 green:0.937 blue:0.922 alpha:1]];
    UIImageView * emptyImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo.png"]];
    [emptyImage setCenter:CGPointMake(160, 180)];
    [self.emptyView addSubview:emptyImage];
    [self.view addSubview:self.emptyView];
    [self.emptyView setHidden:NO];
    
    
    self.progressView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, height-yoffset)];
    [self.progressView setBackgroundColor:[UIColor colorWithRed:0.941 green:0.937 blue:0.922 alpha:1]];
    UIImageView * progressImage = [Utility animateViewFrameNumber:8 baseName:@"25-1-"];
    progressImage.center = self.progressView.center;
    [self.progressView addSubview:progressImage];
    
    [self.view addSubview:self.progressView];
    [self.progressView setHidden:YES];
    
    self.overlayView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, height-yoffset)];
    [self.overlayView setBackgroundColor:[UIColor blackColor]];
    [self.overlayView setAlpha:0.8];
    [self.overlayView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideOverlay)]];
    [self.view addSubview:self.overlayView];
    
    
    self.autocompleteView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, width, height-yoffset)];
    [self.view addSubview:self.autocompleteView];
    [self.autocompleteView setBackgroundColor:[Utility getPaperGray]];
    [self.autocompleteView setDelegate:self];
    [self.autocompleteView setDataSource:self];
    
    [self.overlayView setHidden:YES];
    [self.autocompleteView setHidden:YES];
    
    [self.searchBar setDelegate:self];
    for (UIView *searchBarSubview in [self.searchBar subviews]) {
        if ([searchBarSubview conformsToProtocol:@protocol(UITextInputTraits)]) {
            [(UITextField *)searchBarSubview setReturnKeyType:UIReturnKeyDone];
            [(UITextField *)searchBarSubview setKeyboardAppearance:UIKeyboardAppearanceAlert];
        }
    }
    
    self.cachedDataHandler = [CachedDataHandler instance];
    
    [self.view setBackgroundColor:[UIColor colorWithRed:0.941 green:0.937 blue:0.922 alpha:1]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateResults:) name:@"SearchNotification"  object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(searchFromFilter:animated:) name:@"UpdatedFilterNotification"  object:nil];
}

- (void)viewDidUnload
{
    [self setSearchBar:nil];
    [super viewDidUnload];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

// Formats the queryString |query| and starts a SearchDelegate, that performs the search. 
- (void) searchQuery:(NSString*) query{
    RecipeProtoSearchDelegate * searchDelegate = [[RecipeProtoSearchDelegate alloc] init];
    query = [query stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    query = [query stringByTrimmingCharactersInSet:[NSCharacterSet symbolCharacterSet]];
    NSLog(@"searching for: %@", query);
    NSString * urlvalues = [query stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString * urlString = [NSString stringWithFormat:@"http://graph.anycook.de/search?ingredients=%@&appid=3&num=50", urlvalues];
    NSURLRequest * request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:urlString]];
    NSURLConnection * connection = [[NSURLConnection alloc] initWithRequest:request delegate:searchDelegate];
    if(!connection)
        NSLog(@"No Connection!");
}

// Cell fly animation. A Cell with the label |cellcontent| is drawn and moved to the filterbutton.
- (void) cellFly:(NSString*)cellcontent{
    [self.barbutton setImage:[UIImage imageNamed:@"kochtopf-auf.png"]];
    CGRect pframe = self.progressView.frame;
    UIView * cellview = [[UIView alloc] initWithFrame:CGRectMake(0, 150, pframe.size.width, 49)];
    cellview.backgroundColor = [UIColor whiteColor];
    UILabel * celllabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    celllabel.text = cellcontent;
    celllabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:20];
    [celllabel sizeToFit];
    celllabel.center = CGPointMake(celllabel.center.x + 10, cellview.frame.size.height / 2);
    [cellview addSubview:celllabel];
    cellview.layer.borderColor = [UIColor lightGrayColor].CGColor;
    cellview.layer.borderWidth = 1;
    
    [self.navigationController.view addSubview:cellview];
    [UIView animateWithDuration:1.0 animations:^{
        cellview.transform = CGAffineTransformMakeScale(0.025, 0.2);
        cellview.center = CGPointMake(pframe.size.width-40, 35);
    } completion:^(BOOL finished) {
        [cellview removeFromSuperview];
        [self.barbutton setImage:[UIImage imageNamed:@"kochtopf.png"]];
    }];
}

// Returns a highes similarity value (between 0.0 and 1.0) of all String contained in |array| compared to the string |query|
- (float) determineMaximumSimilarityInArray:(NSMutableArray*)array forQuery:(NSString*)query{
    float maxsim = 0.0f;
    for(NSString * string in array){
        float similarity = [Utility determineJaccardSimilarityofString:query andString:string];
        if (maxsim<similarity) {
            maxsim = similarity;
        }
    }
    
    return maxsim;
}


#pragma mark - Notification Handling

// SearchNotification
- (void) updateResults:(NSNotification*) notification{
    self.results = [notification object];
    [self.tableView reloadData];
    [self.progressView setHidden:YES];
    self.tableView.scrollEnabled = YES;
    NSLog(@"%d", [self.results count]);
    if([self.results count] != 0){
        [self.emptyView setHidden:YES];
        self.tableView.separatorColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1.0];
    }
    else{
        [self.emptyView setHidden:NO];
        self.tableView.separatorColor = [UIColor clearColor];
    }
        
}

// Is called when a UpdatedFilterNotification occurs. A query is built from all elements in the filter container |filter_ingredients| and a search is performed. If |animated| is set to YES, a animation is triggered, that indicates, that a new element was added to the filter.
- (void) searchFromFilter:(NSNotification*) notification animated:(BOOL) animated{
    if(notification != nil){
        self.filter_ingredients = [notification object];
    }
    [self.progressView setHidden:NO];
    NSMutableString * query = [[NSMutableString alloc] init];
    for(NSString * ingredient in self.filter_ingredients){
        [query appendString:ingredient];
        [query appendString:@","];
    }
    [self searchQuery:query];
    if(animated){
        [self cellFly:[self.filter_ingredients lastObject]];
    }
}


#pragma mark - SearchBar delegate source
// Show the overlay view, when the inputfield in the searchbar is selected. The overlayview is moved to the current scrollposition.
- (void) searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    CGFloat offset= self.tableView.contentOffset.y;
    CGSize framesize = self.overlayView.frame.size;
    self.overlayView.frame = CGRectMake(0, offset, framesize.width, framesize.height);
    [self.overlayView setHidden:NO];
}

// Shows the autocorrect results, if text is inserted in the searchbar.
- (void) searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if([self.autocompleteView isHidden]){
        CGFloat offset= self.tableView.contentOffset.y;
        CGSize framesize = self.autocompleteView.frame.size;
        self.autocompleteView.frame = CGRectMake(0, offset, framesize.width, framesize.height);
        [self.autocompleteView setHidden:NO];
    }
    
    if([searchText length] >= 1){
        self.auto_recipes = [self.cachedDataHandler getRecipesContaining:searchText];
        self.maxsim_recipes = [self determineMaximumSimilarityInArray:self.auto_recipes forQuery:searchText];
        
        self.auto_ingredients = [self.cachedDataHandler getIngredientsContaining:searchText];
        self.maxsim_ingredients = [self determineMaximumSimilarityInArray:self.auto_ingredients forQuery:searchText];
        
        NSLog(@"num ingredients: %d", [self.auto_ingredients count]);
        [self.autocompleteView reloadData];
        self.tableView.scrollEnabled = NO;
    } else {
        [self.autocompleteView setHidden:YES];
    }
}


#pragma mark - Table view data source

// Returns the number of sections in the considered |tableView|
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(tableView==self.autocompleteView){
        NSInteger count=0;
        if ([self.auto_ingredients count]>0) {
            count += 1;
        }
        if ([self.auto_recipes count]>0) {
            count += 1;
        }
        
        return count;
    }
    return 1;
}

// Returns the title for the header in |section| of |tableView|
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if(tableView==self.autocompleteView){
        if([tableView numberOfSections] == 2){
            switch (section) {
                case 0:
                    if (self.maxsim_recipes>self.maxsim_ingredients) {
                        return @"Rezepte";
                    }
                    else if (self.maxsim_recipes<self.maxsim_ingredients){
                        return @"Zutaten";
                    } else {
                        return @"Rezepte";
                    }
                    break;
                case 1:
                    if (self.maxsim_recipes<self.maxsim_ingredients) {
                        return @"Rezepte";
                    }
                    else if (self.maxsim_recipes>self.maxsim_ingredients){
                        return @"Zutaten";
                    } 
                    else{
                        return @"Zutaten";
                    }
                    break;
                case 2:
                    return @"Stichwörter";
                    break;    
                default:
                    break;
            }
        }
        else {
            if ([self.auto_recipes count] >0) {
                return @"Rezepte";
            } if ([self.auto_ingredients count] >0) {
                return @"Zutaten";
            }
        }
    }
    
    return @"";
}

// Returns the number of Rows in |section| of |tableView|
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView==self.autocompleteView){
        
        NSString * sectioname = [self tableView:self.autocompleteView titleForHeaderInSection:section];
        if ([sectioname isEqualToString:@"Rezepte"]) {
            return [self.auto_recipes count];
        } else if ([sectioname isEqualToString:@"Zutaten"]) {
            return [self.auto_ingredients count];
        } else {
            return 0;
        }
    } else {
        return [self.results count];
    }
    return 0;
}

// Builds a Cell in |tableView| at position |indexPath|
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell * cell = nil;
    if(tableView==self.autocompleteView){
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil)
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        
        NSString * cellText = nil;
        NSString * sectioname = [self tableView:self.autocompleteView titleForHeaderInSection:indexPath.section];
        if ([sectioname isEqualToString:@"Rezepte"]) {
            cellText = [self.auto_recipes objectAtIndex:indexPath.row];
        } else if([sectioname isEqualToString:@"Zutaten"]) {
            cellText = [self.auto_ingredients objectAtIndex:indexPath.row];
        }
        cell.textLabel.text = cellText;
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
    } else {
        RecipeModel * recipe = [self.results objectAtIndex:indexPath.row];
        cell = (UITableViewCell*) [[RecipeResultCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier recipe:recipe];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        //cell.textLabel.text = recipe.name ;
    }
        
    return cell;
}

// Returns the height of |tableView| at position |indexPath|
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.tableView) {
        return 100;
    }
    else return 40;
}

- (UIView * ) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 30)];
    if (tableView == self.autocompleteView) {
        [headerView setBackgroundColor:[Utility getDarkGray]];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 3, tableView.bounds.size.width - 10, 18)];
        label.text = [tableView.dataSource tableView:tableView titleForHeaderInSection:section];
        label.textColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.75];
        label.backgroundColor = [UIColor clearColor];
        [headerView addSubview:label];
    }
    return headerView;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (tableView == self.autocompleteView) {
        return 25;
    }
    return 0;
}


#pragma mark - Table view delegate

// Closes the keyboard view, when the Autocomplete is scrolled
-(void) scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.searchBar resignFirstResponder];
}

// Is called, when a cell is selected. If a cell of the autocompleteView is selected a search is performed. If a recipe cell is selected the recipe is displayed.
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == self.autocompleteView){
        NSString * sectioname = [self tableView:self.autocompleteView titleForHeaderInSection:indexPath.section];
        if ([sectioname isEqualToString:@"Rezepte"]) {
            NSString * recipeName = [self.auto_recipes objectAtIndex:indexPath.row];
            [self.searchBar resignFirstResponder];
            [self performSegueWithIdentifier:@"showRecipeFromSearch" sender:indexPath];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"showRecipeNotification" object:recipeName];
        }
        if ([sectioname isEqualToString:@"Zutaten"]) {
            [self.autocompleteView setHidden:TRUE];
            [self.overlayView setHidden:TRUE];
            [self.searchBar resignFirstResponder];
            if(!self.filter_ingredients){
                self.filter_ingredients = [[NSMutableArray alloc] init];
            }
            [self.filter_ingredients addObject:[self.auto_ingredients objectAtIndex:indexPath.row]];
            [self searchFromFilter:nil animated:YES];
        }
    } else {
        RecipeModel * recipeModel = [self.results objectAtIndex:indexPath.row];
        [self performSegueWithIdentifier:@"showRecipeFromSearch" sender:indexPath];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"showRecipeNotification" object:recipeModel.name];
    }
        
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"showFilter"]){
        [segue.destinationViewController performSelector:@selector(setFilter_ingredients:)withObject:self.filter_ingredients];
    }
}

@end
