//
//  Deck.m
//  Cards_Game
//
//  Created by KEVIN on 04/04/2014.
//  Copyright (c) 2014 KEVIN. All rights reserved.
//

#import "Deck.h"

@interface Deck()

@property (strong, nonatomic) NSMutableArray *cards ;
@end

@implementation Deck


-(NSMutableArray *)cards{
    
    
    //if the array doesn't exist yet create one
    
    if(!_cards){
     _cards=[[NSMutableArray alloc]init];
    }
    return _cards;
}

-(void)addCard:(Card *)card atTop: (BOOL) atTop{
    
    if(atTop){
        [self.cards insertObject:card atIndex:0];
    }else{
        [self.cards addObject:card];

    }
    
}

-(void)addCard:(Card *)card{
    
    [self addCard:card atTop:NO];
}

-(Card *)drawRandomCard{
    
    unsigned index;
    int size = [self.cards count];
    Card *randomCard = nil;
    index = arc4random()%size; //size of array is the max index
    
    if([self.cards count]){
        randomCard = [self.cards objectAtIndex:index];
        [self.cards removeObjectAtIndex:index];
    }
    
    
    
    return randomCard;
}
-(BOOL) estVide
{
    if (![self.cards count]) {
        return YES;
    }
    return NO;
}
@end
