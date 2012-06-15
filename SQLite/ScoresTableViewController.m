//
//  ScoreTableViewController.m
//  SQLite
//
//  Created by Marian PAUL on 29/03/12.
//  Copyright (c) 2012 iPuP SARL. All rights reserved.
//

#import "ScoresTableViewController.h"
#import "AddScoreViewController.h"

#import "SQLiteManager.h"
#import "Score.h"

@implementation ScoresTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = @"Liste des Scores";     

    [[SQLiteManager shared] readScoresFromDatabase];
    
    //création d'un bouton pour l'ajout
    UIBarButtonItem *add = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addScore)];
    self.navigationItem.rightBarButtonItem = add;
}

- (void)viewWillAppear:(BOOL)animated 
{
    [super viewWillAppear:animated];
    //on recharge la liste au retour après ajout
    [self.tableView reloadData];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void) addScore
{
    AddScoreViewController *addScoreViewController = [[AddScoreViewController alloc] initWithNibName:@"AddScoreViewController" bundle:nil];
    [self.navigationController pushViewController:addScoreViewController animated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[SQLiteManager shared] scores].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier]; // [1]
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }

    SQLiteManager *manager = [SQLiteManager shared];
    Score *score = [manager.scores objectAtIndex:indexPath.row];
    cell.textLabel.text = score.pseudo;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%d",score.resultat];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath 
{
    if (editingStyle == UITableViewCellEditingStyleDelete) 
    {
        [[SQLiteManager shared] deleteScoreFromDatabase:[[SQLiteManager shared].scores objectAtIndex:indexPath.row]]; // [1]
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES]; // [2]
    }   
}

@end
