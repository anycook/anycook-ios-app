//
//  RecipeProtoCameraViewController.m
//  RecipeViewPrototype
//
//  Created by Maximilian Michel on 10.06.12.
//  Copyright (c) 2012 anycook. All rights reserved.
//

#import "RecipeProtoCameraViewController.h"
#import "CameraTargetView.h"
#import "PhotoDataHandler.h"
#import "Utility.h"
@interface RecipeProtoCameraViewController ()

// Filtered camera view
@property (strong, nonatomic) XBFilteredCameraView * cameraView;
// Text field for entering the RecipeName
@property (strong, nonatomic) UITextField * nameField;
// Data handler for the photo database
@property (strong, nonatomic) PhotoDataHandler * photoDB;


@end

@implementation RecipeProtoCameraViewController

@synthesize photoDB = _photoDB;
@synthesize cameraView = _cameraView;
@synthesize nameField = _nameField;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

// Callback of photo button. The current state of the |cameraView| is saved to the Photo album and added to the photo database.
- (IBAction)takePhoto:(id)sender {
    UIImage * image = [self.cameraView takeScreenshot];
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    [self.photoDB addPhoto:image withName:self.name];
    /*[self.cameraView takeAPhotoWithCompletion:^(UIImage *image) {
        // Save image
        image = [Utility imageByCropping:image toRect:CGRectMake(0, 0, 600, 600)];
        UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
        [self.photoDB addPhoto:image withName:self.name];
    }];*/
}

// Callback method when the image saving process is finished.
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    UIAlertView *alert;
     
    if (error)
        alert = [[UIAlertView alloc] initWithTitle:@"Fehler" 
                                           message:@"" 
                                          delegate:self cancelButtonTitle:@"Ok" 
                                 otherButtonTitles:nil];
    else 
        alert = [[UIAlertView alloc] initWithTitle:@"Gespeichert" 
                                           message:@"Das Bild wurde im Fotoalbum gespeichert." 
                                          delegate:self cancelButtonTitle:@"Ok" 
                                 otherButtonTitles:nil];
    [alert show];
}

// Called if the cancel button is pressed. The current modal view is canceled.
- (IBAction)cancelModal:(id)sender {
    [self dismissModalViewControllerAnimated:true];
}

// Is called when the view did load. The backgroundcolor is set and the |cameraView| is initialized with the Lecker-Shader
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.photoDB = [PhotoDataHandler instance];
    self.view.backgroundColor = [UIColor colorWithRed:0.941 green:0.937 blue:0.922 alpha:1];
    
    self.cameraView = [[XBFilteredCameraView alloc] initWithFrame:CGRectMake(0, 0, 310, 310)];
    self.cameraView.center = CGPointMake(self.view.center.x, self.view.center.y-10);
    //[self.cameraView setPhotoOrientation:XBPhotoOrientationPortrait];
    
    NSString *shaderPath = [[NSBundle mainBundle] pathForResource:@"LeckerShader" ofType:@"glsl"];
    NSError *error = nil;
    if (![self.cameraView setFilterFragmentShaderPath:shaderPath error:&error]) {
        NSLog(@"Error setting shader: %@", [error localizedDescription]);
    }
    [self.view addSubview:self.cameraView];
    
    [self.cameraView startCapturing];
    
    self.nameField = [[UITextField alloc] initWithFrame:CGRectMake(5, 40, 310, 40)];
    [self.nameField setBackgroundColor:[UIColor whiteColor]];
    [self.nameField setTextAlignment:NSTextAlignmentCenter];
    [self.nameField setDelegate:self];
    [self.nameField setFont:[UIFont fontWithName:@"Palatino" size:30]];
    if(!self.name)
        self.name = @"";
    self.nameField.text = self.name;
    
    [self.nameField setBorderStyle:UITextBorderStyleRoundedRect];
    
    [self.view addSubview:self.nameField];
}



- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - UITextField delegate

- (void) textFieldDidBeginEditing:(UITextField *)textField{
    
}

- (void) textFieldDidEndEditing:(UITextField *)textField{
    self.name = textField.text;
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return NO;
}



@end
