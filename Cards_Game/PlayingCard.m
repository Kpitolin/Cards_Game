//
//  PlayingCard.m
//  Cards_Game
//
//  Created by KEVIN on 04/04/2014.
//  Copyright (c) 2014 KEVIN. All rights reserved.
//

#import "PlayingCard.h"

@implementation PlayingCard

+ (NSArray *) provideRankStrings{
   return    @[@"?",@"A",@"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10", @"J", @"Q", @"K" ];
}


+(NSArray *) provideValidSuits{
    return @[@"♣️",@"♠️",@"♥️",@"♦️"];
}

+(NSUInteger) maxRank{
    return [[self provideRankStrings] count]-1 ;
}


-(NSString *)contents
{
  
   return  [[PlayingCard provideRankStrings ] [self.rank] stringByAppendingString: self.suit];
    
}


-(void)setRank:(NSUInteger)rank{
    
    if(rank <= [PlayingCard maxRank]){
        _rank = rank;
    }
    
}


@synthesize suit = _suit; // Because we provide getter AND setter

- (NSString *) suit {
    return _suit ? _suit :  @"?";
}

-(void)setSuit:(NSString *)suit{
 
    if([ [PlayingCard provideValidSuits] containsObject:suit]){
        _suit = suit;
    }

}



@end
