 //
//  RecipeProtoFilterViewController.m
//  RecipeViewPrototype
//
//  Created by Maximilian Michel on 09.07.12.
//  Copyright (c) 2012 anycook. All rights reserved.
//

#import "RecipeProtoFilterViewController.h"

@interface RecipeProtoFilterViewController ()

@end


@implementation RecipeProtoFilterViewController


@synthesize filter_ingredients = _filter_ingredients;

// Callback function of cancel button
- (IBAction)cancelModal:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

// Returns number of sections: 1
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{  // Return the number of sections.
    return 1;
}

// Returns number of rows in the TableView: number of elements in |filter_ingredients|
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   // Return the number of rows in the section.
    return [self.filter_ingredients count];
}

// Builds cell for Row at position |index|. Based on the data source |filter_ingredients| each cell gets the matching ingredient name
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    
    cell.textLabel.text = [self.filter_ingredients objectAtIndex:indexPath.row];
    cell.textLabel.font = [UIFont fontWithName:@"Palatino-Italic" size:18];
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    [cell setAccessoryType:UITableViewCellEditingStyleDelete];
    return cell;
}



#pragma mark - Table view delegate

// If a cell is selected the Filter is removed from the view 
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * ingredientName = [self.filter_ingredients objectAtIndex:indexPath.row];
    [self.filter_ingredients removeObject:ingredientName];
    [self.tableView reloadData];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdatedFilterNotification" object:self.filter_ingredients];
    [self cancelModal:nil];
}



@end
