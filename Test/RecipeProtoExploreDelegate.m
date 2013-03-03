//
//  RecipeProtoExploreDelegate.m
//  RecipeViewPrototype
//
//  Created by Maximilian Michel on 09.05.12.
//  Copyright (c) 2012 anycook. All rights reserved.
//

#import "RecipeProtoExploreDelegate.h"
#import "RecipeProtoImageDelegate.h"

#import "SBJson.h"
#import "Utility.h"

#import "RecipeImageView.h"

@interface RecipeProtoExploreDelegate()

// Array holding all created views
@property (strong, nonatomic) NSMutableArray * exploreViews;

@end

@implementation RecipeProtoExploreDelegate

@synthesize exploreViews = _exploreViews;
@synthesize type = _type;

// Gets the recipe image for the |recipename| at the specified Point
- (void) addImageforRecipe:(NSString*)recipename atPointX:(CGFloat) x andY:(CGFloat)y{
    RecipeProtoImageDelegate * imageDelegate = [[RecipeProtoImageDelegate alloc] init];
    
    RecipeImageView * imgView = [[RecipeImageView alloc] initWithFrame:CGRectMake(x, y, 90, 90)];
    imgView.recipename = recipename;
    imageDelegate.imageView = imgView;
    
    NSString * imageUrl = [NSString stringWithFormat:@"http://graph.anycook.de/recipe/%@/image?appid=3", [recipename urlencode]];
    NSURLRequest * imageRequest = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:imageUrl]];
    NSURLConnection * imageConnection = [[NSURLConnection alloc] initWithRequest:imageRequest delegate:imageDelegate];
    imageConnection = imageConnection;
    
    imgView.userInteractionEnabled = YES;
    [self.exploreViews addObject:imgView];
}


// Callback function is called, when the resource is completly loaded. For every recipename in the resulting JSON string an ImageView is created.
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    self.exploreViews = [[NSMutableArray alloc] init];
    NSLog(@"Succeeded! Received %d bytes of data",[self.recievedData length]);
    NSString *jsonString = [[NSString alloc] initWithData:self.recievedData encoding:NSUTF8StringEncoding];
    
    NSString * exploretype;
    if(self.type == BELIEBT)
        exploretype = @"beliebte";
    else if(self.type == LECKERSTE)
        exploretype = @"leckerste";
    else if(self.type == SAISONAL){
        [self handleSeasonalRequestForJSONString:jsonString];
        return;
    }
    
    NSDictionary * results = [jsonString JSONValue];
    NSArray * recipes = [results objectForKey:exploretype];
    CGFloat x = 15;
    CGFloat y = 10;
    for(NSString * recipename in recipes){
        
        [self addImageforRecipe:recipename atPointX:x andY: y];
        
        if(x < 150) x += 100;
        else{
            x = 15;
            y += 100;
        }
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ExploreNotification" object:self.exploreViews];
}

// If a seasonal request occurs, the response has to be parsed in another way. For every recipename an ImageView is created.
- (void) handleSeasonalRequestForJSONString:(NSString*) jsonstring{
    NSArray * results = [jsonstring JSONValue];
    CGFloat x = 15;
    CGFloat y = 10;
    for(NSString * name in results){
        [self addImageforRecipe:name atPointX:x andY: y];
        
        if(x < 150) x += 100;
        else{
            x = 15;
            y += 100;
        }
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ExploreNotification" object:self.exploreViews];
}

@end
