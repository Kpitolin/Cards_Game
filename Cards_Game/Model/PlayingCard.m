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


+(int) maxRank{
    return [[self provideRankStrings] count]-1.0 ;
}


-(NSString *)contents
{
    super.contents =  [[PlayingCard provideRankStrings ] [self.rank] stringByAppendingString: self.suit];
    return super.contents;
    
}


-(void)setRank:(int)rank{
    
    if(rank <= [PlayingCard maxRank]){
        _rank = rank;
    }
    
}




-(NSArray *) arrayResult_match:(NSMutableArray *)otherCards{
    
    NSInteger score = 0;
    id card ;
    id card2;
    NSString * result;
    switch ([otherCards count]) {
        case 1:
            card = [otherCards firstObject];
            if ([card isKindOfClass:[PlayingCard class]]){
                PlayingCard *otherCard =  (PlayingCard *)card;
                if([self.suit isEqualToString: otherCard.suit]){
                    score = POINTS_SUIT_PAIR;
                    result =  [NSString stringWithFormat:@"%@ matches with %@",self.contents,otherCard.contents] ;
                   // otherCard.matched = YES;
                    
                }else if(self.rank ==otherCard.rank){
                    score = POINTS_RANK_PAIR;
                    result =  [NSString stringWithFormat:@"%@ matches with %@",self.contents,otherCard.contents] ;
                 //   otherCard.matched = YES;
                    
                } else {
                    result = [NSString stringWithFormat:@"%@ doesn't match with %@" ,self.contents,otherCard.contents] ;
                }
            }
            
            
            
            
            
            
            break;
        case 2:
            // IMPROVE THIS : MAKE IT GENERIC
            card = [otherCards firstObject];
            card2 = [otherCards lastObject];
            if ([card isKindOfClass:[PlayingCard class]] &&[card2 isKindOfClass:[PlayingCard class]] ){
                PlayingCard *otherCard =  (PlayingCard *)card;
                PlayingCard *otherCard2 =  (PlayingCard *)card2;
                
                
                if([self.suit isEqualToString: otherCard2.suit] && [self.suit isEqualToString: otherCard.suit])
                {
                    
                    score  = POINTS_SUIT_TRIO;
                    result = [NSString stringWithFormat:@"%@  matches with %@ and %@" ,self.contents,otherCard.contents,otherCard2.contents] ;
                    
                }else  if (([self.suit isEqualToString: otherCard.suit] || [self.suit isEqualToString: otherCard2.suit]|| [otherCard2.suit isEqualToString: otherCard.suit])
                           
                           &&
                           (self.rank ==otherCard.rank  || self.rank ==otherCard2.rank  || otherCard.rank ==otherCard2.rank) )
                    
                {
                    score = POINTS_MIXED_PAIR;
                    result = [NSString stringWithFormat:@" Between %@, %@ and %@\nthere's a mixed pair in the air" ,self.contents,otherCard.contents,otherCard2.contents] ;
                }else if (self.rank ==otherCard.rank && self.rank ==otherCard2.rank)
                    
                {
                    score = POINTS_RANK_TRIO;
                    result = [NSString stringWithFormat:@"%@  matches with %@ and %@" ,self.contents,otherCard.contents,otherCard2.contents] ;
                    
                }else if([self.suit isEqualToString: otherCard.suit] || [self.suit isEqualToString: otherCard2.suit]|| [otherCard2.suit isEqualToString: otherCard.suit])
                    
                {
                    score = POINTS_SUIT_PAIR;
                    result = [NSString stringWithFormat:@" Between %@, %@ and %@\nthere's a suit pair in the air" ,self.contents,otherCard.contents,otherCard2.contents] ;
                    
                }else if (self.rank ==otherCard.rank || self.rank ==otherCard2.rank || otherCard2.rank ==otherCard.rank)
                {
                    
                    score = POINTS_RANK_PAIR;
                    result = [NSString stringWithFormat:@" Between %@, %@ and %@\nthere's a rank pair in the air" ,self.contents,otherCard.contents,otherCard2.contents] ;
                    
                }else {
                    result = [NSString stringWithFormat:@"%@ doesn't match with %@ or %@" ,self.contents,otherCard.contents,otherCard2.contents] ;
                }
            }
            
            
            break;
            
    }
    
    
    
    return @[ @(score) , result];
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
