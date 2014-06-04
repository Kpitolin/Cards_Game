//
//  Card.m
//  Cards_Game
//
//  Created by KEVIN on 04/04/2014.
//  Copyright (c) 2014 KEVIN. All rights reserved.
//




#import "Card.h"

@implementation Card

-(int) match:(NSArray *)otherCards
{
    
    int score = 0;
    Card * card;
    for (card in otherCards) {
        if([card.contents isEqualToString:self.contents]){
            score = 1;
        }
    }
    
    
    
    return score;
}

@end
