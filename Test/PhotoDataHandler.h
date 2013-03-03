//
//  PhotoDataHandler.h
//  RecipeViewPrototype
//
//  Created by Maximilian Michel on 04.07.12.
//  Copyright (c) 2012 anycook. All rights reserved.
//

#import <Foundation/Foundation.h>

// Class handling all database functionalities of the photo database
@interface PhotoDataHandler : NSObject

// Singleton Pattern: returns the current instance of the PhotoDataHandler or - if not initialized - creates a new instance
+ (PhotoDataHandler *) instance;
// Adds a photo |image| with the name |name| to the photo database
- (void) addPhoto:(UIImage*) image withName:(NSString*) name;
// Returns an array with all photos as UIImage, that are currently saved in the photo database
- (NSMutableArray*) getAllPhotos;
// Clears the photo database
- (void) clearPhotos;
// Send a PhotoDBReady notification
- (void) notify;
@end
