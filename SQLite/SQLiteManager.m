//
//  SQLiteManager.m
//  SQLite
//
//  Created by Marian PAUL on 29/03/12.
//  Copyright (c) 2012 iPuP SARL. All rights reserved.
//

#import "SQLiteManager.h"
#import "Score.h"
#import <sqlite3.h>

@implementation SQLiteManager
@synthesize scores = _scores;


- (void) initDatabase
{
    //On définit le nom de la base de données
    _databaseName = @"database.sql";
    
    // On récupère le chemin
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDir = [documentPaths objectAtIndex:0];
    _databasePath = [documentsDir stringByAppendingPathComponent:_databaseName];
    
    // On vérifie si la BDD a déjà été sauvegardée dans l'iPhone de l'utilisateur
    BOOL success;
    
    // Crée un objet FileManager qui va servir à vérifer le statut
    // de la base de données et de la copier si nécessaire
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    // Vérifie si la BDD a déjà été créée  dans les fichiers systèmes de l'utilisateur
    success = [fileManager fileExistsAtPath:_databasePath];
    
    // Si la BDD existe déjà on ne fait pas la suite
    if(!success)
    {
        // Si ce n'est pas le cas alors on copie la BDD de l'application vers les fichiers systèmes de l'utilisateur
        
        // On récupère le chemin vers la BDD dans l'application
        NSString *databasePathFromApp = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:_databaseName];
        
        // On copie la BDD de l'application vers le fichier système de l'application
        NSError *error = nil;
        [fileManager copyItemAtPath:databasePathFromApp toPath:_databasePath error:&error];
        NSLog(@"%@", error);
    }
}

- (id) init 
{
    self = [super init];
    
    if (self) 
    {
        [self initDatabase];   
    }
    return self;
}

- (void)readScoresFromDatabase 
{
    // Déclaration de l'objet database
    sqlite3 *database;
    
    // Initialisation du tableau de score [1]
    if(self.scores == nil)
        self.scores = [[NSMutableArray alloc] init];
    else
        [self.scores removeAllObjects];
    
    // On ouvre la BDD à partir des fichiers système
    if(sqlite3_open([_databasePath UTF8String], &database) == SQLITE_OK) // [2]
    {
        // Préparation de la requête SQL qui va permettre de récupérer les objets score de la BDD
        //en triant les scores dans l'ordre décroissant 
        const char *sqlStatement = "select * from score ORDER BY resultat DESC";
        
        //création d'un objet permettant de connaître le status de l'exécution de la requête
        sqlite3_stmt *compiledStatement;
        
        if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK) //[3]
        {
            // On boucle tant que l'on trouve des objets dans la BDD
            while(sqlite3_step(compiledStatement) == SQLITE_ROW) //[4]
            {
                // On lit les données stockées dans le fichier sql
                // Dans la première colonne on trouve du texte que l'on place dans un NSString
                NSInteger key = sqlite3_column_int(compiledStatement, 0);
                NSString *pseudo = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 1)];
                // Dans la deuxième colonne on récupère le score dans un NSInteger
                NSInteger resultat = sqlite3_column_int(compiledStatement, 2);
                
                // On crée un objet Score avec les pramètres récupérés dans la BDD
                Score *score = [[Score alloc] initWithKey:key pseudo:pseudo resultat:resultat]; // [5]
                
                // On ajoute le score au tableau
                [self.scores addObject:score];
            }
        }
        // On libère le compiledStamenent de la mémoire
        sqlite3_finalize(compiledStatement);
    }
    //On ferme la bdd
    sqlite3_close(database);
}

- (void)insertScoreIntoDatabase:(Score*)newScore 
{    
    // Déclaration de l'objet database
    sqlite3 *database;
    // On ouvre la BDD à partir des fichiers système
    if(sqlite3_open([_databasePath UTF8String], &database) == SQLITE_OK) {
        // Préparation de la requête SQL qui va permettre d'ajouter un score à la BDD       
        NSString *sqlStat = [NSString stringWithFormat:@"INSERT INTO score (pseudo, resultat) VALUES ('%@', %d);", newScore.pseudo, newScore.resultat];
        //conversion en char *
        const char *sqlStatement = [sqlStat UTF8String];
        //On utilise sqlite3_exec qui permet très simplement d'exécuter une requête sur la BDD
        sqlite3_exec(database, sqlStatement,NULL,NULL,NULL); // [1]
        [self.scores addObject:newScore];
        
        [self.scores sortUsingDescriptors:[NSArray arrayWithObject:[[NSSortDescriptor alloc] initWithKey:@"resultat" ascending:NO]]]; // [2]
    }
    sqlite3_close(database);
}

- (void)deleteScoreFromDatabase:(Score*)oldScore 
{
    
    // Déclaration de l'objet database
    sqlite3 *database;
    // On ouvre la BDD à partir des fichiers système
    if(sqlite3_open([_databasePath UTF8String], &database) == SQLITE_OK) {
        // Préparation de la requête SQL qui va permettre de supprimer un score à la BDD       
        NSString *sqlStat = [NSString stringWithFormat:@"DELETE FROM score WHERE id = %d;", oldScore.primaryKey];
        //conversion en char *
        const char *sqlStatement = [sqlStat UTF8String];
        //On utilise sqlite3_exec qui permet très simplement d'exécuter une requète sur la BDD
        sqlite3_exec(database, sqlStatement,NULL,NULL,NULL);
    
        [self.scores removeObject:oldScore];
    }
    sqlite3_close(database);
}



#pragma mark - singleton
+ (SQLiteManager*)shared
{
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init];
    });
    return _sharedObject;
}
@end
