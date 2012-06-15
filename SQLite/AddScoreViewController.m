//
//  AddScoreViewController.m
//  SQLite
//
//  Created by Marian PAUL on 29/03/12.
//  Copyright (c) 2012 iPuP SARL. All rights reserved.
//

#import "AddScoreViewController.h"
#import "Score.h"
#import "SQLiteManager.h"

@interface AddScoreViewController ()

@end

@implementation AddScoreViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    //Création d'un UITexField pour entrer le pseudo
    _pseudo = [[UITextField alloc] initWithFrame:CGRectMake(100, 60, 120, 20)];
    _pseudo.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1.0];
    _pseudo.textAlignment = UITextAlignmentCenter;
    //on fait apparaître tout de suite le clavier
    [_pseudo becomeFirstResponder];
    _pseudo.placeholder = @"Pseudo";
    [self.view addSubview:_pseudo];
    
    //Création d'un UITexfield pour le score
    _score = [[UITextField alloc] initWithFrame:CGRectMake(100, 100, 120, 20)];
    _score.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1.0];
    _score.textAlignment = UITextAlignmentCenter;
    //On utilise un clavier numérique
    _score.keyboardType = UIKeyboardTypeNumberPad;
    _score.placeholder = @"Résultat";
    [self.view addSubview:_score];
    
    //Création d'un bouton pour réaliser l'ajout
    UIButton *bouton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [bouton setTitle:@"ajouter" forState:UIControlStateNormal];
    [bouton addTarget:self action:@selector(addScore) forControlEvents:UIControlEventTouchUpInside];
    bouton.frame = CGRectMake(100, 140, 120, 30);
    [self.view addSubview:bouton];
}

//méthode de validation
-(void)addScore
{
    //Création d'un object Score à partir des informations entrées
    Score *newScore = [[Score alloc] initWithKey:-1 pseudo:_pseudo.text resultat:[_score.text intValue]];
    //insertion du score
    [[SQLiteManager shared] insertScoreIntoDatabase:newScore];
    
    [self.navigationController popViewControllerAnimated:YES];
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

@end
