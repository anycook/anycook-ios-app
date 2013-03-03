//
//  ResourceDelegate.m
//  RecipeViewPrototype
//
//  Created by Maximilian Michel on 09.05.12.
//  Copyright (c) 2012 anycook. All rights reserved.
//

#import "ResourceDelegate.h"

@interface ResourceDelegate()


@end


@implementation ResourceDelegate

@synthesize recievedData = _recievedData;

- (id)init{
    self.recievedData = [[NSMutableData alloc] init];
    return self;
}

- (void) setRecievedData:(NSMutableData *)recievedData{
    if(_recievedData == nil)
        _recievedData = [[NSMutableData alloc] init];
}

// Is called after first response of the connection
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [self.recievedData setLength:0];
}

// Is called, when data was received. This method can be called several times for just one request, if the resource, that shall be downloaded contains much data. The new part of the resource is then appended to the |receivedData|.
- (void) connection:(NSURLConnection *) connection didReceiveData:(NSData *)data{
    [self.recievedData appendData:data];
     NSLog(@"Resource: Succeeded! Received %d bytes of data",[data length]);
    
}

// Is called, if an error occurs
- (void)connection:(NSURLConnection *)connection
  didFailWithError:(NSError *)error
{
    NSLog(@"Connection failed! Error - %@ %@",
          [error localizedDescription],
          [[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]);
}


@end
