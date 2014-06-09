//
//  ScoreTableViewController.m
//  Cards_Game
//
//  Created by KEVIN on 08/06/2014.
//  Copyright (c) 2014 KEVIN. All rights reserved.
//

#import "ScoreTableViewController.h"

@interface ScoreTableViewController ()

@end

@implementation ScoreTableViewController



- (IBAction)clearScores:(id)sender {
    [self.refreshControl beginRefreshing];

    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSMutableArray *games = [[defaults objectForKey:@"Scores"] mutableCopy];
    [games removeAllObjects];
    [defaults setObject:games forKey:@"Scores"];
    [defaults synchronize];
    self.gameTable = [[NSArray alloc] init] ;
    [self.tableView  reloadData];
    [self.refreshControl endRefreshing];

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}
#define GAMES @"Games"

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.gameTable count]; //

}





- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Game_Score" forIndexPath:indexPath];
    
    // Configure the cell...
    NSString * string ;
    if ([self.gameTable objectAtIndex:indexPath.row] == self.highscore ){
        cell.detailTextLabel.textColor = [UIColor redColor];
    
    } else if (cell.detailTextLabel.textColor == [UIColor redColor]){
        cell.detailTextLabel.textColor = [UIColor blackColor];

    }

    if([[self.gameTable objectAtIndex:indexPath.row] intValue ] > 0){
        cell.textLabel.text = @"Gagné !";
        string = @"Points";

    }else if ([[self.gameTable objectAtIndex:indexPath.row] intValue ]== 0){
       string = @"Point";
        cell.textLabel.text = @"Perdu !" ;
        
    }else{
        string = @"Points";
        cell.textLabel.text = @"Perdu !" ;
    }

    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ %@",[self.gameTable objectAtIndex:indexPath.row], string];
    
    


    return cell;
}











@end
