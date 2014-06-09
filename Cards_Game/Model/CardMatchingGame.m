//
//  CardMatchingGame.m
//  Cards_Game
//
//  Created by KEVIN on 05/04/2014.
//  Copyright (c) 2014 KEVIN. All rights reserved.
//

#import "CardMatchingGame.h"

@interface CardMatchingGame () // DO NOT FORGET THE PARENTHESES (the interface is already created but we need a private one)

@property (nonatomic, readwrite) int score; // We need to set the score in our implementation but anyone can't do it from the public API
@property (nonatomic, strong) NSMutableArray *cardToMatchWith;
@property (nonatomic, strong) NSMutableArray *cards; //of type Card
@property (nonatomic) int numberOfCardsMatched;

@end



@implementation CardMatchingGame



-(NSMutableArray *)cards { // lazy instanciation
    
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
    
    if (card.isChosen){
        
        card.chosen = NO;
        [self.cardToMatchWith removeObject:card];
        self.numberOfCardsLeftToMatch++;
    } else if(self.numberOfCardsLeftToMatch) {
        
        self.numberOfCardsLeftToMatch--;
        
        if( [self.cardToMatchWith count]== self.maxOfMatchingItems-1){
            // match with last card and calculate score
            
            if([card isKindOfClass:[PlayingCard class]]){
                card_id = (PlayingCard *)card;
                points = [card_id arrayResult_match:self.cardToMatchWith][0];
                matchScore =  [points isKindOfClass:[NSNumber class]] ? [points integerValue]: 0 ;
                
                
            }
            else
            {
                // it's another card game (not really implemented)
                matchScore = [card match:self.cardToMatchWith];
                
            }
            
            
            if(matchScore)
            {
                
                self.score += matchScore *MATCH_BONUS;
                for(Card *cardMatched in self.cardToMatchWith){
                    cardMatched.matched = YES;
                    if(self.numberOfCardsMatched < [self.cards count]) self.numberOfCardsMatched ++;
                    
                }
                card.matched = YES;
                self.numberOfCardsMatched ++;
                
                
                
                id result = [card_id arrayResult_match:self.cardToMatchWith][1];
                NSString *begin = [result isKindOfClass:[NSString class]] ? (NSString *)result : @"";
                
                resultOfchoice = [NSString stringWithFormat:@"%@\nYou get %ld %@",begin,matchScore*MATCH_BONUS,(matchScore*MATCH_BONUS)>1?@"points":@"point"];
                
                
            }
            else
            {
                
                // We impose a penalty if there's no match
                self.score -= MISMATCH_PENALTY;
                resultOfchoice = [NSString stringWithFormat:@"You get -%d points" ,MISMATCH_PENALTY];
            }
            
        }
        
        card.chosen =YES;
        self.score -= COST_TO_CHOOSE;
        
        
        
        
        
        if (card.isMatched) // if the card matched  all the x cards matched
            
        {
            [self.cardToMatchWith removeAllObjects ] ;// cleans up the array for next time
            self.numberOfCardsLeftToMatch = self.maxOfMatchingItems; //RESET
            
        }else if ([self.cardToMatchWith count]== self.maxOfMatchingItems-1 && !matchScore ){ // if the cards didn't match
            
            [self.cardToMatchWith removeAllObjects ] ;// cleans up the array for next time
            [self putBackEnabledCardsFaceUp]; // if a card is still face up we need it to match with other cards for next time
            
        }
        else
        {
            [self.cardToMatchWith addObject:card];
        }
    }
    else
    { // if they are already 2 cards chosen we can't choose another
        // here two choices : we erase the first ones and put this to match or we just do nothing
        
    }
    
    
    return  resultOfchoice;
    
}


-(Card *)cardAtIndex:(NSUInteger)index{
    
    Card * card = [self.cards objectAtIndex:index];
    return index < [self.cards count] ? card : nil;
}


// CONSTANTS :
//  1 : game end  winnig (positive score )
//  2 : game end losing (negative score)
//  3 : game not end
static const int JEUFG = 1;
static const int JEUFP = 2;
static const int JEUNF = 3;


-(int) endOfGame { // determine game's end
    int end = JEUNF;
    Card * card;
    Card * cardToMatchFirst;
    id card_id ;
    id points;
    NSMutableArray *restOfCards = [[NSMutableArray alloc]init];
    
    if (self.numberOfCardsMatched == [self.cards count] && self.score > 0) {
        end = JEUFG;
        NSLog(@"Gagné");
    }else if(self.numberOfCardsMatched == [self.cards count]){
        end = JEUFP;
        NSLog(@"Perdu");
        
    }
    if(self.numberOfCardsMatched == [self.cards count]-self.maxOfMatchingItems){
        
        for (card in self.cards) {
            if ( !card.isMatched) { // number of Enabled Cards FaceUp
                [restOfCards addObject:card];
            }
        }
        card = restOfCards.lastObject;
        [restOfCards removeLastObject]; // We'll compare card with the x others
        if ([restOfCards count] == self.maxOfMatchingItems-1){
            if([card isKindOfClass:[PlayingCard class]]){
                card_id = (PlayingCard *)card;
            }
            points = [card_id arrayResult_match:restOfCards][0] ;
            if (!([points isKindOfClass:[NSNumber class]] ? [points integerValue]: 0)){  // if the cards didn't match : end of the game
                if ( self.score > 0) {
                    end = JEUFG;
                    
                }else{
                    end = JEUFP;
                    
                }
            }
            
        }
        
        
        //MAKE THIS MORE GENERIC
    }/*else if (self.maxOfMatchingItems==2 && !self.numberOfCardsLeftToMatch){  //handle case with the four last
                                                                                //cards who don't match
        
        for (card in self.cards) {
            
            if ( !card.isMatched && !card.isChosen) {
                [restOfCards addObject:card];
            }
            
        }
        if(self.numberOfCardsMatched == [self.cards count]-2*self.maxOfMatchingItems && [restOfCards count]==2*self.maxOfMatchingItems){
        
        
        for( card in restOfCards){
            
            // repeat this to see for all last cards
            for (cardToMatchFirst in restOfCards){
                if([card isKindOfClass:[PlayingCard class]]){
                    card_id = (PlayingCard *)card;
                    
                    if(![cardToMatchFirst.contents isEqualToString: card.contents]){
                        points =[card_id arrayResult_match: [NSMutableArray arrayWithObject:cardToMatchFirst]][0];
                        if (([points isKindOfClass:[NSNumber class]] ? [points integerValue]: 0)){   // if 2 cards  matched it stops
                            return end;
                        }
                        
                    }
                }
            }
        }
        
        self.score > 0 ? (end = JEUFG): (end = JEUFP);
        }
        
    }*/
    
            
        
        
    
    
    
    
    
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
