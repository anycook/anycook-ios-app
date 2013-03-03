//
//  RecipeProtoGalleryViewController.m
//  RecipeViewPrototype
//
//  Created by Maximilian Michel on 05.07.12.
//  Copyright (c) 2012 anycook. All rights reserved.
//

#import "RecipeProtoGalleryViewController.h"
#import "PhotoDataHandler.h"
#import "Photo.h"
#import "PhotoThumbnail.h"
#import "Utility.h"



@interface RecipeProtoGalleryViewController ()

// Array of UIImage containing all taken photos
@property (strong, nonatomic) NSMutableArray * photos;
// Instance of PhotoDataHandler for getting all saved photos from the database
@property (strong, nonatomic) PhotoDataHandler * photoDB;
// Scroll view containing the photo thumbnails
@property (strong, nonatomic) UIScrollView * scrollView;
// Photo preview overlay
@property (strong, nonatomic) UIView * photoOverlay;
// Photo in preview
@property (strong, nonatomic) UIImageView * previewPhoto;

@end

@implementation RecipeProtoGalleryViewController

@synthesize cancelModal = _cancelModal;
@synthesize photos = _photos;
@synthesize photoDB = _photoDB;
@synthesize scrollView = _scrollView;
@synthesize photoOverlay = _photoOverlay;
@synthesize previewPhoto = _previewPhoto;

// Callback of the cancel button in the navigation bar. The current view (shown as modal) is canceled.
- (IBAction)done:(id)sender {
    [self dismissModalViewControllerAnimated:true];
}

// Hides overlay
- (void) hideOverlay{
    [self.photoOverlay setHidden:YES];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

// Callback method of the PhotoDBReadyNotification. All photos are added to the |scrollView].
- (void) showAllPhotos{
    self.photos = [self.photoDB getAllPhotos];  // get all photos
    float x = 5;
    float y = 5;
    for(Photo * photo in self.photos){    // add photos to canvas
        PhotoThumbnail * thumbnail = [[PhotoThumbnail alloc] initWithFrame:CGRectMake(x, y, 150, 150)];
        UIImage * image = [[UIImage alloc] initWithData:photo.photoData];
        image = [[UIImage alloc] initWithCGImage: image.CGImage scale:2.0 orientation: UIImageOrientationDownMirrored];
        [thumbnail setImage:image];
        [thumbnail setLabelText:photo.name];
        [self.scrollView addSubview:thumbnail];

        UIGestureRecognizer * tapHandler = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(photoTapped:)];
        [thumbnail addGestureRecognizer:tapHandler];
        
        if(x >= 160){
            x=5;
            y+=175;
        } else{
            x += 155;
        }
    }
    self.scrollView.contentSize  = CGSizeMake(self.view.frame.size.width, y+45); // resize content
}

// Callback method of TapGestureRecognizers of the photo thumbnails
- (void) photoTapped:(UITapGestureRecognizer*) sender{
    PhotoThumbnail * thumbnail = (PhotoThumbnail*) sender.view;
    self.previewPhoto.image = thumbnail.imageView.image;
    [self.photoOverlay setHidden:NO];
    
}

// Is called when the view did load. The background color is set.
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[Utility getPaperGray]];
    
    CGRect frame = CGRectMake(0, 44, self.view.frame.size.width, self.view.frame.size.height);
    self.scrollView = [[UIScrollView alloc] initWithFrame:frame];
    [self.scrollView setBackgroundColor:[Utility getPaperGray]];
    [self.view addSubview:self.scrollView];
    
    self.photoOverlay = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [self.photoOverlay setBackgroundColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.9]];
    self.previewPhoto = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 300, 300)];
    self.previewPhoto.center = self.view.center;
    
    [self.photoOverlay addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideOverlay)]];
    
    [self.photoOverlay addSubview:self.previewPhoto];
    [self.view addSubview:self.photoOverlay];
    [self.photoOverlay setHidden:YES];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

// Is called, when the view did appear.
- (void) viewDidAppear:(BOOL)animated
{
    if(self.photoDB != nil)
        [self showAllPhotos];
    else {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showAllPhotos) name:@"PhotoDBReadyNotification" object:nil];
        self.photoDB = [PhotoDataHandler instance];
    }
}

// Is called when the view will appear. The |photoDB| is initialized and the ViewController subscribes the PhotoDBReadyNotification.
- (void) viewWillAppear:(BOOL)animated{
    if(self.photoDB != nil)
        [self showAllPhotos];
    else {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showAllPhotos) name:@"PhotoDBReadyNotification" object:nil];
        self.photoDB = [PhotoDataHandler instance];
    }  
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
