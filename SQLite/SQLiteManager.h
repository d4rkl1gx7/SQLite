//
//  SQLiteManager.h
//  SQLite
//
//  Created by Marian PAUL on 29/03/12.
//  Copyright (c) 2012 iPuP SARL. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Score;

@interface SQLiteManager : NSObject
{
    // Variables de la Base de Données
    NSString *_databaseName;
    NSString *_databasePath;
}

@property (nonatomic, retain) NSMutableArray *scores; // Tableau de scores

+ (SQLiteManager*)shared;
- (void)readScoresFromDatabase;
- (void)insertScoreIntoDatabase:(Score*)newScore;
- (void)deleteScoreFromDatabase:(Score*)oldScore;

@end
