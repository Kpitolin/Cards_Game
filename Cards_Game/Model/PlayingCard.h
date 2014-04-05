//
//  PlayingCard.h
//  Cards_Game
//
//  Created by KEVIN on 04/04/2014.
//  Copyright (c) 2014 KEVIN. All rights reserved.
//

#import "Card.h"

@interface PlayingCard : Card
@property (strong, nonatomic) NSString *suit;
@property (nonatomic)int rank;



+(int) maxRank;

+(NSArray *) provideValidSuits;

@end
