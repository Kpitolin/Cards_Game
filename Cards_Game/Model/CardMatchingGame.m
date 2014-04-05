//
//  CardMatchingGame.m
//  Cards_Game
//
//  Created by KEVIN on 05/04/2014.
//  Copyright (c) 2014 KEVIN. All rights reserved.
//

#import "CardMatchingGame.h"

@interface CardMatchingGame () // DO NOT FORGET THE PARENTHESES (the interface is already created but we need a private one)

@property (nonatomic, readwrite) NSUInteger score; // We need to set the score in our implementation but anyone can't do it from the public API
@property (nonatomic, strong) NSMutableArray *cards; //of Card
@end



@implementation CardMatchingGame



-(NSMutableArray *)cards { // lazy instanciation : important
    
    if(!_cards){
        _cards = [[NSMutableArray alloc]init] ;
    }
    
    return _cards;
}



- (instancetype) initWithCardCount: (NSUInteger)count usingDeck:(Deck *)deck{
    self = [super init];
    
    
    // if NSObject could init, I can initialize
    if (self && count > 2){
        
        for (int i =0; i< count; i++) {
            Card * card = [deck drawRandomCard];
            if (card){
                [self.cards addObject:card];
                
            } else {
                self = nil;
                break;
            }
        }
        
    }
    
    return self;
    
}


/* If we just init the game without
 number of cards or anything, it couldn't start*/

- (instancetype) init{     return nil;
}

static const int MISMATCH_PENALTY = 2;
static const int MATCH_BONUS = 4;
static const int COST_TO_CHOOSE = 1;



-(NSString *) chooseCardAtIndex:(NSUInteger)index{
    NSString *resultOfchoice = @"";
    Card * card = [self.cards objectAtIndex:index];
    //  NSMutableArray *cardToMatchWith;
    
    if (!card.isMatched){
        
        if (card.isChosen){
            
            card.chosen = NO;
            
        } else {
            // match with another card
            
            
            for (Card * anotherCard in self.cards ) {
                if(anotherCard.isChosen && !anotherCard.isMatched){
                    int matchScore = [card match:@[anotherCard]];
                    
                    if(matchScore){
                        
                        self.score += matchScore *MATCH_BONUS;
                        card.matched = YES;
                        anotherCard.matched = YES;
                        resultOfchoice = [NSString stringWithFormat:@"%@ matches with %@ :\nYou get %d %@",card.contents,anotherCard.contents,matchScore,matchScore>1?@"points":@"point"];
                        
                    }else {
                        
                        // We impose a penalty if there's no match
                        self.score -= MISMATCH_PENALTY;
                        resultOfchoice = [NSString stringWithFormat:@"%@ doesn't match with %@ :\nYou get -%d points",card.contents,anotherCard.contents,MISMATCH_PENALTY];
                    }
                    
                    // [cardToMatchWith addObject:anotherCard];
                    break;
   
                }
                

            }
            
            
            card.chosen =YES;
            self.score -= COST_TO_CHOOSE;
            
            // We finally match with the ... cards
            //  [card match:cardToMatchWith];
 
        }
        
    }
    
    return  resultOfchoice;
   
}


-(Card *)cardAtIndex:(NSUInteger)index{
    
    Card * card = [self.cards objectAtIndex:index];
    return index < [self.cards count] ? card : nil;
}








@end
