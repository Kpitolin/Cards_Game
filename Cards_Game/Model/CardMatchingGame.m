//
//  CardMatchingGame.m
//  Cards_Game
//
//  Created by KEVIN on 05/04/2014.
//  Copyright (c) 2014 KEVIN. All rights reserved.
//

#import "CardMatchingGame.h"

@interface CardMatchingGame () // DO NOT FORGET THE PARENTHESES (the interface is already created but we need a private one)

@property (nonatomic, readwrite) NSInteger score; // We need to set the score in our implementation but anyone can't do it from the public API
@property (nonatomic) int numberOfCardsLeftToMatch;
@property (nonatomic, strong) NSMutableArray *cardToMatchWith;
@property (nonatomic, strong) NSMutableArray *cards; //of type Card
@property (nonatomic) int numberOfCardsMatched;

@end



@implementation CardMatchingGame



-(NSMutableArray *)cards { // lazy instanciation : important
    
    if(!_cards){
        _cards = [[NSMutableArray alloc]init] ;
    }
    
    return _cards;
}

-(NSMutableArray *)cardToMatchWith{
    
    
    //if the array doesn't exist yet create one
    
    if(!_cardToMatchWith ){
        _cardToMatchWith=[[NSMutableArray alloc]init];
    }
    return _cardToMatchWith;
}


- (instancetype) initWithCardCount: (NSUInteger)count usingDeck:(Deck *)deck andMaxMatching:(int)max{
    self = [super init];
    
    
    // if NSObject could init, I can initialize
    if (self && count > 2){
        
        _maxOfMatchingItems = max;
        _numberOfCardsLeftToMatch = max;
        
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

- (instancetype) init{
    return nil;
}

static const int MISMATCH_PENALTY = 2;
static const int MATCH_BONUS = 4;
static const int COST_TO_CHOOSE = 1;


-(NSString *) chooseCardAtIndex:(NSUInteger)index{
    NSString *resultOfchoice = @"";
    Card * card = [self.cards objectAtIndex:index];
    id card_id ;
    id points;
    NSInteger matchScore = 0;
    if (!card.isMatched){
        
        if (card.isChosen){
            
            card.chosen = NO;
            [self.cardToMatchWith removeObject:card];
            self.numberOfCardsLeftToMatch++;
        } else {
            
            self.numberOfCardsLeftToMatch--;
            
            if( [self.cardToMatchWith count]){
                // match with another card
                
                if([card isKindOfClass:[PlayingCard class]]){
                    card_id = (PlayingCard *)card;
                    points = [card_id arrayResult_match:self.cardToMatchWith][0];
                    matchScore = [points isKindOfClass:[NSNumber class]] ? [points integerValue] : 0;
                    
                    if (matchScore) {
                        for(Card *cardMatched in self.cardToMatchWith){
                            cardMatched.matched = YES;
                            self.numberOfCardsMatched ++;
                        }
                        card.matched = YES ;
                        self.numberOfCardsMatched ++;

                        
                    }
                    
                }else {
                    matchScore = [card match:self.cardToMatchWith];
                    
                }
                
                
                if(matchScore && [self.cardToMatchWith count]== self.maxOfMatchingItems-1){
                    
                    self.score += matchScore *MATCH_BONUS;
                    card.matched = YES;
                    
                    
                    id result = [card_id arrayResult_match:self.cardToMatchWith][1];
                    NSString *begin = [result isKindOfClass:[NSString class]] ? (NSString *)result : @"";
                    
                    resultOfchoice = [NSString stringWithFormat:@"%@\nYou get %d %@",begin,matchScore*MATCH_BONUS,(matchScore*MATCH_BONUS)>1?@"points":@"point"];
                    [self.cardToMatchWith removeAllObjects ] ;// cleans up the array for next time
                    
                    
                }else if ([self.cardToMatchWith count]== self.maxOfMatchingItems-1){
                    
                    // We impose a penalty if there's no match
                    self.score -= MISMATCH_PENALTY;
                    resultOfchoice = [NSString stringWithFormat:@"You get -%d points" ,MISMATCH_PENALTY];
                    [self.cardToMatchWith removeAllObjects ];// cleans up the array for next time
                    [self putBackEnabledCardsFaceUp];
                }
                
            }
            
            card.chosen =YES;
            self.score -= COST_TO_CHOOSE;
            
            if (self.numberOfCardsLeftToMatch) {
                
                [self.cardToMatchWith addObject:card];
                
            } else if (card.isMatched){ // if the player wins he can't turn over the cards
                
                self.numberOfCardsLeftToMatch = self.maxOfMatchingItems; //RESET
                
            }
        }
        
    }

    return  resultOfchoice;
    
}


-(Card *)cardAtIndex:(NSUInteger)index{
    
    Card * card = [self.cards objectAtIndex:index];
    return index < [self.cards count] ? card : nil;
}


// CONSTANTES :
//  1 : jeu fini et gagnant (score positif)
//  2 : jeu fini et perdant (score négatif)
//  3 : jeu non fini
static const int JEUFG = 1;
static const int JEUFP = 2;
static const int JEUNF = 3;


-(int) endOfGame { // determine si le jeu est fini ou pas
    int end = JEUNF;
    Card * card;
    NSMutableArray *restOfCards = [[NSMutableArray alloc]init];
    if (self.numberOfCardsMatched == [self.cards count] && self.score ) {
        end = JEUFG;
    }else if(self.numberOfCardsMatched == [self.cards count]){
        end = JEUFP;
    }else if(self.numberOfCardsMatched == [self.cards count]-self.maxOfMatchingItems){
        
        for (card in self.cards) {
            if ( !card.isMatched) { // number of Enabled Cards FaceUp
                [restOfCards addObject:card];
            }
        }
        card = restOfCards.lastObject;
        [restOfCards removeLastObject]; // We'll compare card with the 2 others
        if ([restOfCards count] == self.maxOfMatchingItems-1){
            if (![card match:restOfCards]){  // if the cards didn't match : end of the game
                if ( self.score) {
                    end = JEUFG;
                }else{
                    end = JEUFP;
                }
            }
            
        }
        
    }

    
    return end;
}

-(void) putBackEnabledCardsFaceUp{
    Card * card;
    for (card in self.cards) {
        if (card.isChosen && !card.isMatched) {
            [self.cardToMatchWith addObject:card];
        }
    }
}




@end
