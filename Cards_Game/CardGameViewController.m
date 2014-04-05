//
//  ViewController.m
//  Cards_Game
//
//  Created by KEVIN on 04/04/2014.
//  Copyright (c) 2014 KEVIN. All rights reserved.
//
#import "PlayingCardDeck.h"
#import "CardGameViewController.h"

@interface CardGameViewController ()
@property (strong, nonatomic) PlayingCardDeck * cardDeck;
@property (weak, nonatomic) IBOutlet UILabel *flipsLabel;
@property (nonatomic) int flipCount;
@end

@implementation CardGameViewController

-(void) setFlipCount:(int)flipCount{
     _flipCount = flipCount;
    self.flipsLabel.text = [NSString stringWithFormat:@"Flips: %d",self.flipCount] ;
}

- (IBAction)touchCardButton:(UIButton *)sender {
    
    self.flipCount++;

    if(! self.cardDeck){
    self.cardDeck =  [[PlayingCardDeck alloc]init];
}
    
    
    if (self.flipCount%2==1){
        [sender setBackgroundImage:[UIImage imageNamed:@"cardback"] forState:UIControlStateNormal];
        [sender setTitle:@"" forState:UIControlStateNormal];
    }else{
        
  
        [sender setBackgroundImage:[UIImage imageNamed:@"cardfront"] forState:UIControlStateNormal];
        if (![self.cardDeck estVide]) {
             [sender setTitle:[[self.cardDeck drawRandomCard] contents] forState:UIControlStateNormal];
        }else {
             [sender setTitle:@"Plus de cartes" forState:UIControlStateNormal];
        }
       
    }
    
}





@end
