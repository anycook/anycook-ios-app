//
//  PhotoDataHandler.m
//  RecipeViewPrototype
//
//  Created by Maximilian Michel on 04.07.12.
//  Copyright (c) 2012 anycook. All rights reserved.
//

#import "PhotoDataHandler.h"
#import "Photo.h"

@interface PhotoDataHandler()
- (PhotoDataHandler*) init;

@property (strong, nonatomic) UIManagedDocument * photoDB;

@end

@implementation PhotoDataHandler

@synthesize photoDB = _photoDB;

- (void) notify{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"PhotoDBReadyNotification" object:NULL];
}

+ (PhotoDataHandler*) instance{
    static PhotoDataHandler * theHandler;
    
    @synchronized(self){
        if(!theHandler)
            theHandler = [[PhotoDataHandler alloc] init];
        else
            [theHandler notify];
        return theHandler;
    }
}


- (void) setPhotoDB:(UIManagedDocument *)photoDB{
    if(_photoDB != photoDB){
        _photoDB = photoDB;
        [self useDocument];
    }
}

- (PhotoDataHandler*) init{
    self = [super init];
    if(self){
        if(!self.photoDB){
            NSURL * url = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
            url = [url URLByAppendingPathComponent:@"Anycook Photo Database"]; // url is now "<Documents Directory>/Anycook Photo Database"
            self.photoDB = [[UIManagedDocument alloc] initWithFileURL:url];
        }
    }
    return self;
}

- (void) useDocument{
    if (![[NSFileManager defaultManager] fileExistsAtPath:[self.photoDB.fileURL path]]) {
        // does not exist --> create
        [self.photoDB saveToURL:self.photoDB.fileURL forSaveOperation:UIDocumentSaveForCreating completionHandler:^(BOOL success) {
            NSLog(@"photodb : does not exist --> create");
            [self notify];
        }];
    } else if(self.photoDB.documentState==UIDocumentStateClosed){
        NSLog(@"db is still closed!");
        [self.photoDB openWithCompletionHandler:^(BOOL success){
            NSLog(@"photodb : does exist --> open");
            [self notify];
        }];
    } else if (self.photoDB.documentState == UIDocumentStateNormal) {
        NSLog(@"photodb : ready");
        [self notify];
    }
    
}

- (void) addPhoto:(UIImage*) image withName:(NSString*) name{
    NSData *imageData = UIImagePNGRepresentation(image);
    
    Photo * photo = nil;
    photo = [NSEntityDescription insertNewObjectForEntityForName:@"Photo" inManagedObjectContext:self.photoDB.managedObjectContext];
    photo.photoData = imageData;
    photo.name = name;
    photo.date = [NSDate date];
    NSError * error = nil;
    [self.photoDB.managedObjectContext save:&error];
}

- (void) clearPhotos{
    NSFetchRequest * request = [NSFetchRequest fetchRequestWithEntityName:@"Photo"];
    NSError * error = nil;
    NSArray * array = [self.photoDB.managedObjectContext executeFetchRequest:request error:&error];
    if(array != nil){
        for (NSManagedObject * entity in array) {
            [self.photoDB.managedObjectContext performBlockAndWait:^{
                [self.photoDB.managedObjectContext deleteObject:entity];
                NSError * serror = nil;
                [self.photoDB.managedObjectContext save:&serror];
            }];
        }
        [self.photoDB saveToURL:self.photoDB.fileURL forSaveOperation:UIDocumentSaveForOverwriting completionHandler:NULL];
    }else {
        NSLog(@"error while fetching");
    }
    
}

- (NSMutableArray*) getAllPhotos{
    NSMutableArray * photos = [[NSMutableArray alloc] init];
    if(self.photoDB.documentState==UIDocumentStateClosed){
        NSLog(@"db is still closed!");
        return photos;
    } else {
        NSLog(@"getting data from db");
        NSSortDescriptor * sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO];
        NSFetchRequest * request = [NSFetchRequest fetchRequestWithEntityName:@"Photo"];
        [request setSortDescriptors:[NSArray arrayWithObject:sortDescriptor ]];
        NSError * error = nil;
        NSArray * array = [self.photoDB.managedObjectContext executeFetchRequest:request error:&error];
        if(array != nil){
            NSLog(@"%d", [array count]);
            for (Photo * photo in array) {
                [photos addObject:photo];
            }
        }else {
            NSLog(@"error while fetching");
        }
        return photos;
    }
}

@end
