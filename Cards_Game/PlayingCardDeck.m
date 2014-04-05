//
//  PlayingCardDeck.m
//  Cards_Game
//
//  Created by KEVIN on 04/04/2014.
//  Copyright (c) 2014 KEVIN. All rights reserved.
//

#import "PlayingCardDeck.h"
#import "PlayingCard.h"

@implementation PlayingCardDeck

-(instancetype) init{
    self = [super init];
    
    if(self){
        
        for (NSString *suit in [PlayingCard provideValidSuits])
        {
            for (NSUInteger rank = 1 ; rank <= [PlayingCard maxRank]; rank++ )
            {
                
                PlayingCard * playingCard = [[PlayingCard alloc]init];
                playingCard.rank = rank;
                playingCard.suit = suit;
                [self addCard:playingCard];
            }
        }
  
        
    }
    
    return self;
}





@end
