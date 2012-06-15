//
//  Score.m
//  SQLite
//
//  Created by Marian PAUL on 29/03/12.
//  Copyright (c) 2012 iPuP SARL. All rights reserved.
//

#import "Score.h"

@implementation Score
@synthesize primaryKey = _primaryKey, pseudo = _pseudo, resultat = _resultat;

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@ - key: %d - pseudo: %@ - result: %d", [super description], _primaryKey, _pseudo, _resultat];
}
- (id) initWithKey:(NSInteger)k pseudo:(NSString *)p resultat:(NSInteger)r
{
    self = [super init];
    if (self) {
        _primaryKey = k;
        self.pseudo = p;
        _resultat = r;
    }
    return self;
}
@end
