//
//  Utility.m
//  RecipeViewPrototype
//
//  Created by Maximilian Michel on 08.05.12.
//  Copyright (c) 2012 anycook. All rights reserved.
//

#import "Utility.h"
#import "Reachability.h"

@implementation Utility

+ (UIImage*) getTransparentImage{
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [[UIColor clearColor] CGColor]);
    CGContextFillRect(context, rect);
    UIImage *transparentImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return transparentImage;
}

+ (UIImageView *) animateViewFrameNumber:(int)framenumber baseName:(NSString*)base {
    NSMutableArray *imagesArray = [NSMutableArray arrayWithCapacity:framenumber];
    for (int i=1; framenumber > i; ++i)
    {
        [imagesArray addObject:[UIImage imageNamed:
                                [NSString stringWithFormat:@"%@%d.tiff", base, i]]];
    }
    
    
    UIImageView *anImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,31,31)];
    anImageView.animationImages = imagesArray; 
    anImageView.animationDuration = 1;
    [anImageView startAnimating];
    return anImageView;
}


+ (UIColor*) getPaperGray{
    return [UIColor colorWithRed:0.941 green:0.937 blue:0.922 alpha:1];
}

+ (UIColor*) getHighlightGreen{
    return [UIColor colorWithRed:0.627 green:0.745 blue:0.314 alpha:1]; /*#a0be50*/
}

+ (UIColor*) getDarkGray{
    return [UIColor colorWithRed:0.376 green:0.376 blue:0.373 alpha:1]; /*#60605f*/
}

+ (UIImage *)imageByCropping:(UIImage *)imageToCrop toRect:(CGRect)rect
{
    if([UIScreen mainScreen].scale > 1.0f){
        rect.size.width *= 2;
        rect.size.height *= 2;
    }
    
    CGImageRef imageRef = CGImageCreateWithImageInRect([imageToCrop CGImage], rect);
    NSLog(@"scale: %f", imageToCrop.scale);
    UIImage *cropped = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    
    return cropped;
}

+ (BOOL) checkForNetworkConnection{
    Reachability * reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus internetStatus = [reachability currentReachabilityStatus];
    
    return (internetStatus == ReachableViaWiFi || internetStatus == ReachableViaWWAN);
}

+ (BOOL) checkForWifiConnection{
    Reachability * reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus internetStatus = [reachability currentReachabilityStatus];
    
    return (internetStatus == ReachableViaWiFi);
}


+ (NSMutableSet*) characterThreeGramsfromString:(NSString*)thestring{
    NSMutableSet * theSet = [[NSMutableSet alloc] init];
    if(thestring.length < 3)
        return theSet;
    else{
        for(int i =0 ; i< thestring.length-3; ++i){
            NSString * substring = @"";
            substring = [substring stringByAppendingFormat:@"%c%c%c", [thestring characterAtIndex:i],[thestring characterAtIndex:i+1],[thestring characterAtIndex:i+2]];
            [theSet addObject:substring];
        }   
    }
    
    return theSet;
}

+ (float) determineJaccardSimilarityofString:(NSString*) stringa andString: (NSString*) stringb{
    if(stringa.length <3 || stringb.length < 3)
        return 0.0f;
    stringa = [stringa lowercaseString];
    stringb = [stringb lowercaseString];
    NSMutableSet * agrams = [self characterThreeGramsfromString:stringa];
    NSMutableSet * bgrams = [self characterThreeGramsfromString:stringb];
    NSSet * summationset = [agrams setByAddingObjectsFromSet:bgrams];
    float summation = [summationset count];
    [agrams intersectSet:bgrams];
    float intersection = [agrams count];
    
    return intersection / summation;
}

+ (UIImage*) loadImageForName:(NSString*)recipename{
    
    NSString * urlvalues = [recipename stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString * urlString = [NSString stringWithFormat:@"http://graph.anycook.de/recipe/%@/image?appid=3&type=large", urlvalues];
    NSURL * url = [NSURL URLWithString:urlString];
    return [UIImage imageWithData: [NSData dataWithContentsOfURL:url]];
}

+ (UIImage*) loadThumbnailForName:(NSString*)recipename{
    
    NSString * urlvalues = [recipename stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString * urlString = [NSString stringWithFormat:@"http://graph.anycook.de/recipe/%@/image?appid=3&type=small", urlvalues];
    NSURL * url = [NSURL URLWithString:urlString];
    return [UIImage imageWithData: [NSData dataWithContentsOfURL:url]];
}

+ (NSInteger) getCurrentMonth{
    NSCalendar * calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate * date = [NSDate date];
    unsigned int unitFlags = NSMonthCalendarUnit | NSDayCalendarUnit;
    NSInteger month = [[calendar components:unitFlags fromDate:date] month];
    return month;
}


@end
