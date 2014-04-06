//
//  ViewController.m
//  Cards_Game
//
//  Created by KEVIN on 04/04/2014.
//  Copyright (c) 2014 KEVIN. All rights reserved.
//
#import "PlayingCardDeck.h"
#import "CardGameViewController.h"
#import  "CardMatchingGame.h"
@interface CardGameViewController ()
@property (strong, nonatomic) Deck * cardDeck;
@property (nonatomic, strong) CardMatchingGame* game;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *resultOfChoiceLabel;
@end

@implementation CardGameViewController



-(Deck *)cardDeckCreate{
    
    _cardDeck =  [[PlayingCardDeck alloc]init];

    return _cardDeck;

}

-(CardMatchingGame*) game {
    if (!_game) {
        _game = [[CardMatchingGame alloc]initWithCardCount:[self.cardButtons count] usingDeck: [self cardDeckCreate]andMaxMatching:2] ;// MAKE IT (the magical 3) SELECTABLE BY USER
        
    }
    
    return _game;
}


-(void) updateUIwithResultofChoice:(NSString*)result{
    for (UIButton * cardButton in self.cardButtons) {
        NSUInteger index  = [self.cardButtons indexOfObject:cardButton];
        Card * card = [self.game cardAtIndex:index];
        [cardButton setTitle: [self titleForCard:card] forState:UIControlStateNormal];
        [cardButton setBackgroundImage:[self backgroundImageForCard:card] forState:UIControlStateNormal];
        cardButton.enabled = ! card.isMatched; 
    }
    
    self.resultOfChoiceLabel.text = result;
    self.scoreLabel.text = [NSString stringWithFormat:@"Score : %ld",(long)self.game.score];
}

-(NSString *)titleForCard:(Card *)card{
    return [card isChosen]? card.contents: @"" ;
}

-(UIImage *) backgroundImageForCard:(Card *)card {
    return  [UIImage imageNamed:[card isChosen]? @"cardfront":@"cardback_linux" ]  ; // pretty cool, uh ? 
}
    
- (IBAction)touchCardButton:(UIButton *)sender {

    NSUInteger cardIndex = [self.cardButtons indexOfObject:sender];
    
    if (self.game.maxOfMatchingItems ==0){
        self.game.maxOfMatchingItems = 2; //RESET
    }
    
    if([[self.game cardAtIndex:cardIndex] isChosen] ){
        [self updateUIwithResultofChoice:[self.game chooseCardAtIndex:cardIndex]];
        self.game.maxOfMatchingItems++;
        
    }
    
    else if(self.game.maxOfMatchingItems >0)
    
    {
        self.game.maxOfMatchingItems--;
        [self updateUIwithResultofChoice:[self.game chooseCardAtIndex:cardIndex]]; 

    }
    
    
    
}





@end
