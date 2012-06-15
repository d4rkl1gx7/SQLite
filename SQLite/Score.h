//
//  Score.h
//  SQLite
//
//  Created by Marian PAUL on 29/03/12.
//  Copyright (c) 2012 iPuP SARL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Score : NSObject
@property (nonatomic, assign, readonly) NSInteger primaryKey;
@property (nonatomic, strong) NSString *pseudo;
@property (nonatomic, assign, readonly) NSInteger resultat;

-(id)initWithKey:(NSInteger)k pseudo:(NSString *)p resultat:(NSInteger )r;

@end
