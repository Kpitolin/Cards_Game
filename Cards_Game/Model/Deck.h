//
//  Deck.h
//  Cards_Game
//
//  Created by KEVIN on 04/04/2014.
//  Copyright (c) 2014 KEVIN. All rights reserved.
//

/*
  A deck is a bunch of cards (it's extended like card to specific games)
 */
#import "Card.h"
#import <Foundation/Foundation.h>

@interface Deck : NSObject

-(void)addCard:(Card *)card atTop: (BOOL) atTop;
-(void)addCard:(Card *)card;

-(Card *)drawRandomCard; // return a random card

-(BOOL)isEmpty;
@end
