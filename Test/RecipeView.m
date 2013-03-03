//
//  RecipeView.m
//  RecipeViewPrototype
//
//  Created by Maximilian Michel on 13.08.12.
//
//

#import "RecipeView.h"
#import "Utility.h"

@interface RecipeView ()

// Label for explaining the seasonal ingredients
@property (strong, nonatomic) UILabel * seasonalText;

@end

@implementation RecipeView


@synthesize titleLabel = _titleLabel;
@synthesize descriptionLabel = _descriptionLabel;
@synthesize authorLabel = _authorLabel;
@synthesize personsLabel = _personsLabel;

@synthesize ingredients = _ingredients;
@synthesize imageView = _imageView;
@synthesize scrollView = _scrollView;

@synthesize recipe = _recipe;
@synthesize persons = _persons;
@synthesize stepper = _stepper;

@synthesize seasonalText = _seasonalText;


// Override super's designated initializer. All views and labels are are initialized. At the end draw is called. 
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = frame;
        _imageView = [[UIImageView alloc] init];
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 300, 320)];
        _descriptionLabel = [[UILabel alloc]init];
        _personsLabel = [[UILabel alloc] init];
        _ingredients = [[UITableView alloc] initWithFrame:CGRectMake(0, 320, 320, 200) style:UITableViewStylePlain];
        _scrollView = [[UIScrollView alloc] init];
        _authorLabel = [[UILabel alloc] init];
        _stepper = [[UIStepper alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
        _seasonalText = [[UILabel alloc] init];
        
        self.backgroundColor = [UIColor colorWithRed:0.941 green:0 blue:0 alpha:1];
        
        [self addSubview:self.scrollView];
        //self.scrollView.frame = CGRectMake(0,0, 320, 367);
        self.scrollView.frame = CGRectMake(0,0, frame.size.width, frame.size.height);
        [self.scrollView addSubview:self.imageView];
        [self.scrollView addSubview:self.titleLabel];
        [self.scrollView addSubview:self.descriptionLabel];
        [self.scrollView addSubview:self.authorLabel];
        [self.scrollView addSubview:self.personsLabel];
        [self.scrollView addSubview:self.ingredients];
        [self.scrollView addSubview:self.stepper];
        [self.scrollView addSubview:self.seasonalText];
        
        [self draw];
    }
    return self;
}

// Completes the initialization process. For every view and label the right font and backgroundcolor is set. This setup is capsualted in an extra method for reasons of clarity and comprehensibility.
- (void) draw{ 
    self.scrollView.backgroundColor = [Utility getPaperGray] /*#f0efeb*/;
        
    [self.titleLabel setLineBreakMode:UILineBreakModeWordWrap];
    [self.titleLabel setNumberOfLines:0];
    self.titleLabel.font = [UIFont fontWithName:@"Palatino" size:24];
    self.titleLabel.backgroundColor = [Utility getPaperGray]; /*#f0efeb*/
    
    self.authorLabel.font = [UIFont fontWithName:@"Palatino-Italic" size:18];
    self.authorLabel.backgroundColor = [Utility getPaperGray]; /*#f0efeb*/
    
    self.descriptionLabel.font = [UIFont fontWithName:@"Palatino-Italic" size:14];
    self.descriptionLabel.textColor = [UIColor grayColor];
    self.descriptionLabel.backgroundColor = [Utility getPaperGray]; /*#f0efeb*/
    
    self.personsLabel.font = [UIFont fontWithName:@"Palatino-Italic" size:14];
    self.personsLabel.textColor = [UIColor grayColor];
    self.personsLabel.backgroundColor = [Utility getPaperGray]; /*#f0efeb*/
    
    self.seasonalText.font = [UIFont fontWithName:@"Palatino" size:14];
    self.seasonalText.text = @"Zutaten in grüner Schrift haben diesen Monat Saison in deiner Gegend!";
    self.seasonalText.textAlignment = UITextAlignmentCenter;
    self.seasonalText.textColor = [Utility getHighlightGreen];
    self.seasonalText.backgroundColor = [Utility getPaperGray];
}

// Is called after the recipe model is called. The |contentsize| of the |scrollView| property is updated.
- (void) recalculateViewSize{
    CGFloat yoffset = self.seasonalText.frame.origin.y + self.seasonalText.frame.size.height + 20;
    
    [self.scrollView sizeToFit];
    self.scrollView.contentSize  = CGSizeMake(320, yoffset);
    
    NSLog(@"view size %f %f", self.frame.size.height, self.frame.size.width);
    self.scrollView.frame = self.frame;
    NSLog(@"scrollview size %f %f", self.scrollView.frame.size.height, self.scrollView.frame.size.width);
    
    NSLog(@"content size %f %f ", self.scrollView.contentSize.height, self.scrollView.contentSize.width);
}

// Updates the recipe model |recipe| of this view. All label texts are updated and their positions are rearranged.
- (void)setRecipe:(RecipeModel *)recipe{
    _recipe = recipe;
    
    UIImage * image = [Utility loadImageForName:self.recipe.name];
    image = [UIImage imageWithCGImage:image.CGImage scale:1.5 orientation:image.imageOrientation];
    self.imageView.image = image;
    [self.imageView sizeToFit];
    
    self.titleLabel.text = self.recipe.name;
    [self.titleLabel sizeToFit];
    NSLog(@"title: %@", self.titleLabel.text);
    
    self.authorLabel.frame = CGRectMake(10, 5+self.titleLabel.frame.size.height, 0, 0);
    self.authorLabel.text = self.recipe.author;
    [self.authorLabel sizeToFit];
        
    CGFloat yoffset = self.authorLabel.frame.origin.y + self.authorLabel.frame.size.height+20;
    self.imageView.frame = CGRectMake(10, yoffset, self.imageView.frame.size.width, self.imageView.frame.size.height);
    
    yoffset = yoffset + self.imageView.frame.size.height + 20;
    
    self.descriptionLabel.frame = CGRectMake(10, yoffset, 300, 1000);
    self.descriptionLabel.text = self.recipe.description;
    [self.descriptionLabel setLineBreakMode:UILineBreakModeWordWrap];
    [self.descriptionLabel setNumberOfLines:0];
    [self.descriptionLabel sizeToFit];
    
    yoffset = yoffset + self.descriptionLabel.frame.size.height + 40;
    
    self.personsLabel.frame = CGRectMake(10, yoffset, 300, 1000);
    self.personsLabel.text = [NSString stringWithFormat:@"Zutaten für %d Personen:", [self.recipe.persons intValue]];
    [self.personsLabel setLineBreakMode:UILineBreakModeWordWrap];
    [self.personsLabel setNumberOfLines:0];
    [self.personsLabel sizeToFit];
    
    self.stepper.frame = CGRectMake(215, yoffset, 100, 100);
    
    [self.ingredients reloadData];
    
    yoffset = self.personsLabel.frame.origin.y + self.personsLabel.frame.size.height + 20;
    CGFloat height = [self.recipe.ingredients count] * 30;
    self.ingredients.frame = CGRectMake(10, yoffset, 300, height);
    
    yoffset = yoffset + height + 20;
    
    self.seasonalText.frame = CGRectMake(15, yoffset, 290, 1000);
    [self.seasonalText setLineBreakMode:UILineBreakModeWordWrap];
    [self.seasonalText setNumberOfLines:0];
    [self.seasonalText sizeToFit];
    
    [self recalculateViewSize];
}

- (void) setPersons:(NSInteger) persons{
    _persons = persons;
    self.personsLabel.text = [NSString stringWithFormat:@"Zutaten für %d Personen:", self.persons];
    self.personsLabel.frame = CGRectMake(10, self.personsLabel.frame.origin.y, 300, 1000);
    [self.personsLabel sizeToFit];
}





@end
