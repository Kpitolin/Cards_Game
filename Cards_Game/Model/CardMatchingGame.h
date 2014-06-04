//
//  CardMatchingGame.h
//  Cards_Game
//
//  Created by KEVIN on 05/04/2014.
//  Copyright (c) 2014 KEVIN. All rights reserved.
//

@import Foundation;
#include "PlayingCardDeck.h"

@interface CardMatchingGame : NSObject



// designated initializer
- (instancetype) initWithCardCount: (NSUInteger)count usingDeck:(Deck *)deck andMaxMatching:(int)max;


/* it determines what to do when a card is chosen and return the local score to display (probably don't respect MVC)
 
 */
-(NSString *) chooseCardAtIndex:(NSUInteger)index;
//return the chosen card
-(Card *)cardAtIndex:(NSUInteger)index;

// CONSTANTES :
//  1 : jeu fini et gagnant (score positif)
//  2 : jeu fini et perdant (score négatif)
//  3 : jeu non fini
-(int) endOfGame;  // determine si le jeu est fini ou pas




@property (nonatomic, readonly) NSInteger score;
@property (nonatomic) int maxOfMatchingItems;
@property (nonatomic) int numberOfCardsLeftToMatch;





@end
