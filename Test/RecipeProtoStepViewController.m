//
//  RecipeProtoStepViewController.m
//  RecipeViewPrototype
//
//  Created by Maximilian Michel on 13.05.12.
//  Copyright (c) 2012 anycook. All rights reserved.
//

#import "RecipeProtoStepViewController.h"
#import "StepView.h"
#import "Utility.h"
#import "CachedDataHandler.h"
#import "Recipe.h"

#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVAudioPlayer.h>


@interface RecipeProtoStepViewController ()

@property NSUInteger currentIndex;

// View containing all views for the timer functionalities
@property (strong, nonatomic) UIView * timerLayer;
// DatePicker interface for inserting the desired Time. It is placed in the timerLayer.
@property (strong, nonatomic) UIDatePicker *timePicker;

// ScrollView containing all StepViews. Each StepView represent one Step of the Recipe.
@property (weak, nonatomic) IBOutlet UIScrollView *stepCanvas;
// The |pageControl| element controls the position of the stepCanvas. This makes it easy that with a whipe gesture each step snaps in the right position
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;

@end

@implementation RecipeProtoStepViewController

@synthesize steps = _steps;

@synthesize stepCanvas = _stepCanvas;
@synthesize pageControl = _pageControl;
@synthesize timePicker = _timePicker;
@synthesize name = _name;


- (id)init
{
    self = [super init];
    if (self) {
        self.currentIndex = 0;
    }
    return self;
}

// Callback method, if a item in the |pageControl| is clicked. 
-(IBAction)clickPageControl:(id)sender
{
    int page=self.pageControl.currentPage;
    CGRect frame=self.stepCanvas.frame;
    frame.origin.x=frame.size.width=page;
    frame.origin.y=0;
    [self.stepCanvas scrollRectToVisible:frame animated:YES];
}

// Is called, when the view did Load. All views are inatialized. For every step in the |steps| container a new StepView is intialized and added as a SubView of the |stepCanvas|. In the |timerLayer| the |timePicker| such as a button for starting and canceling the timer are added as SubViews.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIColor * papergray = [UIColor colorWithRed:0.941 green:0.937 blue:0.922 alpha:1];
    NSInteger stepnumber = [self.steps count];
    
    //self.stepCanvas.frame = self.view.frame;
    self.stepCanvas.delegate = self;
    self.stepCanvas.contentSize = CGSizeMake((stepnumber+1) * self.view.frame.size.width, self.view.frame.size.height);
    NSLog(@"Step canvas widht: %f", self.stepCanvas.contentSize.width);
    NSLog(@"Step frame widht: %f", self.stepCanvas.frame.size.width);
    self.stepCanvas.pagingEnabled = YES;
    [self.stepCanvas setShowsHorizontalScrollIndicator:NO];
    [self.stepCanvas setShowsVerticalScrollIndicator:NO];
    
    self.pageControl.numberOfPages=stepnumber;
    self.pageControl.currentPage=0;

    UIBarButtonItem * timerButton = [[UIBarButtonItem alloc] initWithTitle:@"Timer" style:UIBarButtonItemStyleBordered target:self action:@selector(toggleTimerMenu)];
    
    self.navigationItem.rightBarButtonItem = timerButton;
    
    self.timerLayer = [[UIView alloc] initWithFrame:self.view.frame];
    self.timerLayer.backgroundColor = [UIColor grayColor];
    self.timePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
    self.timePicker.datePickerMode = UIDatePickerModeCountDownTimer;
    
    UIButton * timerStartButton = [[UIButton alloc] initWithFrame:CGRectMake(0,220,320,30)];
    [timerStartButton setTitle:@"Timer starten" forState:UIControlStateNormal];
    [timerStartButton addTarget:self action:@selector(startTimer) forControlEvents:UIControlEventTouchUpInside];
    
    [self.timerLayer addSubview:self.timePicker];
    [self.timerLayer addSubview:timerStartButton];
    [self.view addSubview:self.timerLayer];
    [self.timerLayer addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeTimerMenu)]];
    
    [self.timerLayer setHidden:YES];
    NSInteger i = 0;
    for(i = 0; i<stepnumber; ++i){
        StepView * stepView = [[StepView alloc] initWithFrame:self.view.frame];
        stepView.backgroundColor = papergray;
        stepView.frame = CGRectMake(i*320, 0, self.view.frame.size.width, self.view.frame.size.height);
        stepView.maxSteps = stepnumber;
        [stepView setText:[self.steps objectAtIndex:i]];
        [stepView setStepNumber:i+1];
        [self.stepCanvas addSubview:stepView];
        NSLog(@"%d", i);
    }
    
    UIView * lastpage = [[UIView alloc] initWithFrame:CGRectMake(i*self.view.frame.size.width, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [lastpage setBackgroundColor:[Utility getPaperGray]];
    [self.stepCanvas addSubview:lastpage];
    
    UIButton * favoriteBtn = [[UIButton alloc] initWithFrame:CGRectMake(5, 40, 310, 40)];
    [favoriteBtn setTitle:@"Rezept zu Favoriten hinzufügen" forState:UIControlStateNormal];
    [favoriteBtn addTarget:self action:@selector(favoriteRecipe) forControlEvents:UIControlEventTouchUpInside];
    UIButton * cameraBtn = [[UIButton alloc] initWithFrame:CGRectMake(5, 100, 310, 40)];
    [cameraBtn setTitle:@"Kamera öffnen" forState:UIControlStateNormal];
    [cameraBtn addTarget:self action:@selector(shootRecipe) forControlEvents:UIControlEventTouchUpInside];
    
    [favoriteBtn.titleLabel setFont:[UIFont fontWithName:@"Palatino" size:20]];
    [favoriteBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [cameraBtn.titleLabel setFont:[UIFont fontWithName:@"Palatino" size:20]];
    [cameraBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    
    
    [lastpage addSubview:favoriteBtn];
    [lastpage addSubview:cameraBtn];
    
    [self.stepCanvas setAlwaysBounceHorizontal:NO];
    [self.stepCanvas setAlwaysBounceVertical:NO];

}

// Callback method, if the timerButton is pressed. The |timerLayer| is toggled.
- (void) toggleTimerMenu{
    [self.timerLayer setHidden:([self.timerLayer isHidden] == NO)];
}

// Callback method, if the timerButton is pressed. The |timerLayer| is shwon.
- (void) openTimerMenu{
    [self.timerLayer setHidden:NO];
}

// Callback method, if the cancel button in the |timerLayer| is pressed. The timerLayer is hidden.
- (void) closeTimerMenu{
    [self.timerLayer setHidden:YES];
}

// Callback method, if the start button in the |timerLayer| is pressed. The current selected time of the |timePicker| is determined and converted in seconds. A NSTimer is started with the determined expiration-time. The callback selector is @alertTimer
- (void) startTimer{
    NSDate * date = [self.timePicker date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSHourCalendarUnit | NSMinuteCalendarUnit) fromDate:date];
    NSInteger hour = [components hour];
    NSInteger minute = [components minute];
        
    NSTimeInterval timeinterval = hour*60*60+minute*60;
    NSTimer * timer;
    timer = [NSTimer scheduledTimerWithTimeInterval: timeinterval
                                            target: self
                                            selector: @selector(alertTimer)
                                            userInfo: nil
                                            repeats: NO];
    
    [self.timerLayer setHidden:YES];

}

// Callback method, that is called, when the timer is expired. An alarmsound is played and a Alert/Push Notification is displayed.
- (void) alertTimer{
    SystemSoundID audioEffect = 1234;
    AudioServicesDisposeSystemSoundID(audioEffect);
    
    NSString * path = [[NSBundle mainBundle] pathForResource:@"alarmsound" ofType:@"wav"];
   
    NSURL *pathURL = [NSURL fileURLWithPath : path];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef) pathURL, &audioEffect);
    AudioServicesPlaySystemSound(audioEffect);
    
    
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Timer abgelaufen!"
                                                     message:@""
                                                    delegate:self cancelButtonTitle:@"Ok"
                                           otherButtonTitles:nil];
    [alert show];
    //AudioServicesDisposeSystemSoundID(audioEffect);    
}

// Callback method of favorite button. The recipe is saved to the favorites.
- (IBAction)favoriteRecipe {
    CachedDataHandler * cacheHandler = [CachedDataHandler instance];
    Recipe * recipe = [cacheHandler getRecipeFromCacheWithName:self.name];
    recipe.favorite = [NSNumber numberWithInt:1];
    [cacheHandler explicitSave];
    
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Gespeichert!"
                                                     message:@"Das Gericht wurde zu deinen Lieblingsrezepten hinzugefügt."
                                                    delegate:self cancelButtonTitle:@"Ok"
                                           otherButtonTitles:nil];
    [alert show];
}

// Callback method of the camera button. The segue to the camera view is activated.
- (void) shootRecipe{
    [self performSegueWithIdentifier:@"StartCamera" sender:self];
}


- (void)viewDidUnload
{
    [self setStepCanvas:nil];
    [self setPageControl:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    [segue.destinationViewController setName:self.name];
}

#pragma mark - Scroll View Delegate

// Delegation of the |stepCanvas|. This Callback method is called, when a whipe gesture is finished. With the help of the current position of the |scrollView| it can be determined, which step (|page|) is currently displayed. The |pageControl| property now let the stepCanvas snap to the right psoition
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int page = scrollView.contentOffset.x/scrollView.frame.size.width;
    self.pageControl.currentPage=page;
}

// Delegation of |stepCanvas|. This Callback method prevent the |stepCanvas| from scrolling vertically.
- (void) scrollViewDidScroll:(UIScrollView *)scrollView{
    [scrollView setContentOffset:CGPointMake(scrollView.contentOffset.x, 0)];
}

@end
