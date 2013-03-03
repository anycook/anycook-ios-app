//
//  RecipeProtoExpolreViewController.m
//  RecipeViewPrototype
//
//  Created by Maximilian Michel on 09.05.12.
//  Copyright (c) 2012 anycook. All rights reserved.
//

#import "RecipeProtoExpolreViewController.h"
#import "RecipeProtoExploreDelegate.h"
#import "RecipeProtoViewController.h"
#import "Utility.h"

@interface RecipeProtoExpolreViewController ()

// ScrollView containing grid of all 
@property (strong, nonatomic) UIScrollView * scrollView;
// Layer containing the TableViews with the exploration mode selection
@property (strong, nonatomic) UIView * modelayer;
// TableView for choosing the exploration mode
@property (strong, nonatomic) UITableView * modeTable;
// Button for selecting the exploration mode
@property (strong, nonatomic) UIBarButtonItem * exploreButton;


@end

@implementation RecipeProtoExpolreViewController

@synthesize scrollView = _scrollView;
@synthesize exploreButton = _exploreButton;


// Is called, when the view did load. The |scrollView| is initialized and a button in the navigationbar is added for changing the ExploreView. The ExploreViewController subscribes for the ExploreNotification and ExploreTap-Notification
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:0.941 green:0.937 blue:0.922 alpha:1];
    
    CGRect viewrect = CGRectMake(0, 0, 320, self.view.frame.size.height-self.tabBarController.tabBar.frame.size.height - self.navigationController.navigationBar.frame.size.height);
    self.scrollView = [[UIScrollView alloc] initWithFrame:viewrect];
    
    
    self.scrollView.delegate = self;
    self.scrollView.scrollEnabled = YES;
    [self.view addSubview:self.scrollView];
    
    UIButton * exploreBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    exploreBtn.titleLabel.text = @"Beliebte Rezepte";
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addImageViews:) name:@"ExploreNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(performTap:) name:@"ExploreTap" object:nil];
    
    [self resizeScrollViewContent:4];
    [self handleSeasonal];
    
    self.exploreButton = [[UIBarButtonItem alloc] initWithTitle:@"Saisonal" style:UIBarButtonItemStyleBordered target:self action:@selector(toggleExplore:)];
    UIBarButtonItem *flexible = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    self.navigationItem.rightBarButtonItems = @[flexible, self.exploreButton, flexible];
    
    self.modelayer = [[UIView alloc] initWithFrame:self.view.frame];
    [self.modelayer setBackgroundColor:[UIColor clearColor]];
    [self.modelayer setHidden:YES];
    [self.view addSubview:self.modelayer];
    
    self.modeTable = [[UITableView alloc] initWithFrame:CGRectMake(60, 0, 200, 135) style:UITableViewStylePlain];
    self.modeTable.delegate = self;
    self.modeTable.dataSource = self;
    self.modeTable.backgroundColor = [Utility getPaperGray];
    [self.modeTable setHidden:YES];
    
    [self.view addSubview:self.modeTable];
    [self.modelayer addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toggleExplore:)]];
    
}

- (void) viewWillDisappear:(BOOL)animated{
    //[self.modelayer removeFromSuperview];
}

// Callback method of ExploreNotification. |notification| contains an Array of Views, that are added as a SubView of |scrollView|
- (void) addImageViews:(NSNotification*) notification{
    [self clearExploreView];
    NSMutableArray * views = [notification object];
    for(UIView * view in views){
        [self.scrollView addSubview:view];
    }
}

// Clears the |scrollView| from all SubViews
- (void) clearExploreView{
    for(UIView * view in [self.scrollView subviews]){
        [view removeFromSuperview];
    }
}


// Resizes the ScrollView for the numbers rows
- (void) resizeScrollViewContent:(NSInteger) numRows{
    CGFloat width = self.view.frame.size.width;
    CGFloat height = numRows*90+numRows*10+10;
    
    self.scrollView.contentSize = CGSizeMake(width, height);
}

// Callback method of the GestureRecognizer of the images in |scrollView|. A shoRecipeNotification is posted, and a segue is triggered.
- (void) performTap:(NSNotification*) notification{
    NSString * tappedrecipe = [notification object];
    [self performSegueWithIdentifier:@"showRecipe" sender:self];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"showRecipeNotification" object:tappedrecipe];
}

// Callback of Button in the NavigationBar
- (void) toggleExplore:(id) sender{
    //if(sender == self.modelayer || sender == self.exploreButton){
    [self.modelayer setHidden:([self.modelayer isHidden] == NO)];
    [self.modeTable setHidden:([self.modeTable isHidden] == NO)];
    //}

}

// Handles the data for a seasonal explore view
- (void) handleSeasonal{
    NSInteger month = [Utility getCurrentMonth];
    
    RecipeProtoExploreDelegate * delegate = [[RecipeProtoExploreDelegate alloc] init];
    delegate.type = SAISONAL;
    self.view.userInteractionEnabled = YES;
    NSString * url = [NSString stringWithFormat:@"http://webis6.medien.uni-weimar.de:8080/seasonal/recipes?month=%d&num=12", month ];
    NSURLRequest * request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    NSURLConnection * connection = [[NSURLConnection alloc] initWithRequest:request delegate:delegate];
    if(!connection)
        NSLog(@"No Connection!");
}

// Handles the data for an explore view with most delicious or most popular recipes
- (void) handleViewForType:(enum ExploreType) type{
    if(type == SAISONAL)
        [self handleSeasonal];
    else{
        RecipeProtoExploreDelegate * delegate = [[RecipeProtoExploreDelegate alloc] init];
         delegate.type = type;
         self.view.userInteractionEnabled = YES;
         NSString * url = @"http://graph.anycook.de/discover?recipenum=21&appid=3";
         NSURLRequest * request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
         NSURLConnection * connection = [[NSURLConnection alloc] initWithRequest:request delegate:delegate];
         if(!connection)
         NSLog(@"No Connection!");
    }
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

#pragma mark - Table view data source delegate
// Return the number of sections: 1.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

// Return the number of rows in the section |section|: 3
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

// Builds a cell for each row at position |indexPath|.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    
    cell.backgroundColor = [Utility getPaperGray];
    
    NSString * celltext = @"";
    switch (indexPath.row) {
        case 0:
            celltext = @"Saisonal";
            break;
        case 1:
            celltext = @"Beliebte";
            break;
        case 2:
            celltext = @"Leckerste";
            break;
        default:
            break;
    }
    
    cell.textLabel.text = celltext;
    cell.textLabel.font = [UIFont fontWithName:@"Georgia-Italic" size:18];
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    return cell;
}



#pragma mark - Table view delegate

// Callback, if a cell is selected.
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
            [self handleViewForType:SAISONAL];
            self.exploreButton.title = @"Saisonal";
            [self resizeScrollViewContent:4];
            break;
        case 1:
            [self handleViewForType:BELIEBT];
            self.exploreButton.title = @"Beliebt";
            [self resizeScrollViewContent:7];
            break;
        case 2:
            [self handleViewForType:LECKERSTE];
            self.exploreButton.title = @"Leckerste";
            [self resizeScrollViewContent:7];
            break;
        default:
            break;
    }
    
    [self.modelayer setHidden:YES];
    [self.modeTable setHidden:YES];
}


@end
