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
        _game = [[CardMatchingGame alloc]initWithCardCount:[self.cardButtons count] usingDeck: [self cardDeckCreate]] ;
    }
    
    return _game;
}


-(void) updateUIwithResultofChoice:(NSString*)result{
    for (UIButton * cardButton in self.cardButtons) {
        int index  = [self.cardButtons indexOfObject:cardButton];
        Card * card = [self.game cardAtIndex:index];
        [cardButton setTitle: [self titleForCard:card] forState:UIControlStateNormal];
        [cardButton setBackgroundImage:[self backgroundImageForCard:card] forState:UIControlStateNormal];
        cardButton.enabled = ! card.isMatched;
    }
    
    self.resultOfChoiceLabel.text = result;
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d",self.game.score];
}

-(NSString *)titleForCard:(Card *)card{
    return [card isChosen]? card.contents: @"" ;
}

-(UIImage *) backgroundImageForCard:(Card *)card {
    return  [UIImage imageNamed:[card isChosen]? @"cardfront":@"cardback_red" ]  ; // pretty cool, uh ? 
}
    
- (IBAction)touchCardButton:(UIButton *)sender {

    int cardIndex = [self.cardButtons indexOfObject:sender];
    [self updateUIwithResultofChoice:[self.game chooseCardAtIndex:cardIndex]];
    
    
}





@end
