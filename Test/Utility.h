//
//  Utility.h
//  RecipeViewPrototype
//
//  Created by Maximilian Michel on 08.05.12.
//  Copyright (c) 2012 anycook. All rights reserved.
//

#import <Foundation/Foundation.h>

// Utility contains static methods, that are used by several View(Controller)s
@interface Utility : NSObject

// Creates a transparent image
+ (UIImage*) getTransparentImage;
// Creates a animated View from  |framenumber| frame images that are in the directory |base|  
+ (UIImageView *) animateViewFrameNumber:(int)framenumber baseName:(NSString*)base;
// Crops a the given image |imageToCrop| to a the size of |rect|
+ (UIImage *)imageByCropping:(UIImage *)imageToCrop toRect:(CGRect)rect;


//+  (void) incrementBadgeOfTabBarItem: (UITabBarItem*) kochbuch;
//+ (void) decrementBadgeOfTabBarItem: (UITabBarItem*) kochbuch;

// Returns the Jaccard similarity of the two strings |stringa| and |stringb|
+ (float) determineJaccardSimilarityofString:(NSString*) stringa andString: (NSString*) stringb;
// Gets the recipeimage from the recipe named |recipename| from the anycook API
+ (UIImage*) loadImageForName:(NSString*)recipename;
// Gets the thumbnail of recipeimage from the recipe named |recipename| from the anycook API
+ (UIImage*) loadThumbnailForName:(NSString*)recipename;
// Returns the general background gray color: rgb: 0.941 0.937 0.922
+ (UIColor*) getPaperGray;
// Returns the general highlight green color
+ (UIColor*) getHighlightGreen;
// Returns a dark grey shade
+ (UIColor*) getDarkGray;
// Returns the current month
+ (NSInteger) getCurrentMonth;
// Checks if a networkconnection is reachable
+ (BOOL) checkForNetworkConnection;
// Checks if a wificonnaction is reachable
+ (BOOL) checkForWifiConnection;

@end

// Extends NSString with a urlencoding method
@implementation NSString (NSString_Extended)

// URL encoding of the current string
- (NSString *)urlencode {
    NSMutableString *output = [NSMutableString string];
    const unsigned char *source = (const unsigned char *)[self UTF8String];
    int sourceLen = strlen((const char *)source);
    for (int i = 0; i < sourceLen; ++i) {
        const unsigned char thisChar = source[i];
        if (thisChar == ' '){
            [output appendString:@"%20"];
        } else if (thisChar == '.' || thisChar == '-' || thisChar == '_' || thisChar == '~' || 
                   (thisChar >= 'a' && thisChar <= 'z') ||
                   (thisChar >= 'A' && thisChar <= 'Z') ||
                   (thisChar >= '0' && thisChar <= '9')) {
            [output appendFormat:@"%c", thisChar];
        } else {
            [output appendFormat:@"%%%02X", thisChar];
        }
    }
    return output;
}
@end