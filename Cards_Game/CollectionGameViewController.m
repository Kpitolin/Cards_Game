//
//  CollectionGameViewController.m
//  Cards Game
//
//  Created by KEVIN on 27/07/2014.
//  Copyright (c) 2014 KEVIN. All rights reserved.
//

#import "CollectionGameViewController.h"

@interface CollectionGameViewController ()<UICollectionViewDataSource>
@property (strong,nonatomic) NSArray * datasource;

@end

@implementation CollectionGameViewController




- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section;

{
    return [self.datasource count];
}

-(NSString *)titleForCard:(Card *)card{
    return [card isChosen]? card.contents: @"" ;
}

-(UIImage *) backgroundImageForCard:(Card *)card {
    return  [card isChosen]? self.cardfront: self.cardback   ; // pretty cool, uh ?
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath;
{
        CardGameCell* cell;
    
        
        [cell.button setTitle:[self titleForCard:[self.datasource objectAtIndex:indexPath.item]] forState:UIControlStateNormal] ;
        [cell.button setBackgroundImage:[self backgroundImageForCard:[self.datasource objectAtIndex:indexPath.item]] forState:UIControlStateNormal] ;
   
    
    
    return cell;
}

-(NSMutableArray *)exchangesForGameWithMax:(int)max

{
    
    
    NSMutableArray * arrayOfexchanges;
    
   
    for (int i = 1; i < max+1; i++) {
        NSMutableArray * array  = [[NSMutableArray alloc ] init];

        do {
            
            int index = arc4random()%[self.datasource count];
            
            [array addObject: @(index)];
            int secondIndex = arc4random()%[self.datasource count];
            while ( index == secondIndex) {
                secondIndex = arc4random()%[self.datasource count];
            }
            
            [array addObject: @(secondIndex)];
        } while ([arrayOfexchanges containsObject:array]);
        [arrayOfexchanges addObject:array];
        
    }
    

    
    return arrayOfexchanges;
    
    
}

-(void)performExchangeFromArray:(NSArray *) array
{
        [self.collectionView moveItemAtIndexPath:
         [NSIndexPath indexPathForRow:[[array objectAtIndex:0] intValue]inSection:0 ]
                                     toIndexPath:
         [NSIndexPath indexPathForRow:[[array objectAtIndex:1] intValue] inSection:0 ]
         
         ];
    
}
@end
