//
//  PlayingCard.h
//  Cards_Game
//
//  Created by KEVIN on 04/04/2014.
//  Copyright (c) 2014 KEVIN. All rights reserved.
//
/*
 A Playing card is a card that you can match with with 1 or 2 other cards 
 you match it with rank or suit (it's impossible to have both identical)
 */
#import "Card.h"

static const int POINTS_RANK_PAIR = 4;
static const int POINTS_SUIT_PAIR = 1;
static const int POINTS_SUIT_TRIO= 3;
static const int POINTS_RANK_TRIO= 20;
static const int POINTS_MIXED_PAIR = 10;

@interface PlayingCard : Card
@property (strong, nonatomic) NSString *suit;
@property (nonatomic)int rank;

/* a card can match with 1 or 2 other cards (depending on the size of the array)
 returns an array with local score then explanation sentence
*/
-(NSArray*) arrayResult_match:(NSMutableArray *)otherCards;


+(int) maxRank;

+(NSArray *) provideValidSuits;

@end
