//
//  Card.h
//  Cards_Game
//
//  Created by KEVIN on 04/04/2014.
//  Copyright (c) 2014 KEVIN. All rights reserved.
//

@import Foundation;

@interface Card : NSObject
@property (strong, nonatomic) NSString * contents;
@property (nonatomic,getter = isChosen)BOOL chosen;
@property (nonatomic,getter = isMatched)BOOL matched;
-(int) match:(NSArray *)otherCards; // returns 0 if ther's no match





@end
