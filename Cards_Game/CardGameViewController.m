//
//  ViewController.m
//  Cards_Game
//
//  Created by KEVIN on 04/04/2014.
//  Copyright (c) 2014 KEVIN. All rights reserved.
//
#import "Do.h"
#import "PlayingCardDeck.h"
#import "CardGameViewController.h"
#import  "CardMatchingGame.h"
@interface CardGameViewController ()
@property (strong, nonatomic) Deck * cardDeck;
@property (nonatomic, strong) CardMatchingGame* game;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentControlModeChooser;
@property (weak, nonatomic) IBOutlet UILabel *resultOfChoiceLabel;
@end

@implementation CardGameViewController



-(Deck *)cardDeckCreate{
    
    _cardDeck =  [[PlayingCardDeck alloc]init];
    
    return _cardDeck;
    
}
static const int DEFAULT = 2;
-(CardMatchingGame*) game {
    if (!_game) {
        _game =  [[CardMatchingGame alloc]initWithCardCount:[self.cardButtons count] usingDeck: [self cardDeckCreate]andMaxMatching:DEFAULT];
        
    }
    
    return _game;
}

- (CardMatchingGame *)createNewGameWithMaxMatching:(int)max{
    return [[CardMatchingGame alloc]initWithCardCount:[self.cardButtons count] usingDeck: [self cardDeckCreate]andMaxMatching:max];
}

static const int DEFAULTX = 92;
static const int DEFAULTY = 450;

-(void) resetUI{
    
    // Reset the score position, color and size
    CGPoint  point = CGPointMake(DEFAULTX, DEFAULTY);
    self.scoreLabel.bounds = CGRectMake( self.scoreLabel.center.x, self.scoreLabel.center.y, 165, 21);
    self.scoreLabel.center = point ;
    self.scoreLabel.text = [NSString stringWithFormat:@"Score : 0"];

    
    // Reset the cards
    for (UIButton * cardButton in self.cardButtons) {
        cardButton.enabled = YES;
        [cardButton setTitle: @"" forState:UIControlStateNormal];
        [cardButton setBackgroundImage:[UIImage imageNamed: @"cardback_linux"]forState:UIControlStateNormal];
        cardButton.alpha = 1.0;
    }
    // delete the game
    self.game = nil;
    self.resultOfChoiceLabel.text = [NSString stringWithFormat:@""];
    self.scoreLabel.text = [NSString stringWithFormat:@"Score : 0"];
    [self.segmentControlModeChooser setSelectedSegmentIndex:0];
    
    
}

- (IBAction)swipeGesture:(UISwipeGestureRecognizer *)sender {
    [sender setDirection: UISwipeGestureRecognizerDirectionLeft];
    [self resetUI];
    
}

- (IBAction)onChangeState:(UISegmentedControl *)sender {
    // if the game did not start yet, you can set the match-mode
    
    if (!_game) { // check the actual state of game
        if ([sender isEnabledForSegmentAtIndex:1]) {
            // if on it's a 3-card game
            self.game = [self createNewGameWithMaxMatching:3];
            
            
        }else{
            // if off it's a 2-card game
            [sender setEnabled:YES forSegmentAtIndex:0];
            
            self.game = [self createNewGameWithMaxMatching:DEFAULT];
            
            
        }
    }
    
    
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
    
    
    switch ([self.game endOfGame]) {
        case 1:
        {
            [UIView animateWithDuration:3.0 delay:1.0 options:UIViewAnimationOptionTransitionCurlUp animations:^{
                for (UIButton * button in self.cardButtons){
                    button.alpha = 0.5;
                }
                self.scoreLabel.center = self.scoreLabel.superview.center;
                self.scoreLabel.bounds = CGRectMake( self.scoreLabel.center.x, self.scoreLabel.center.y, 165, 165);
                
               NSMutableAttributedString *title =
                [[NSMutableAttributedString alloc] initWithString: [NSString stringWithFormat:@"YOU WIN\n%ld points",(long)self.game.score]];
                [title setAttributes:@{
                                       NSFontAttributeName: [UIFont systemFontOfSize:30],
                                       NSStrokeWidthAttributeName : @3,
                                       NSStrokeColorAttributeName : [UIColor redColor] }
                               range:NSMakeRange(0, [title length])];
                self.scoreLabel.attributedText = title;
                
                
            } completion:^(BOOL finished){
                if (finished){
                    
                    
                    [self resetUI];
                    
                }
            }] ;
        }
            break;
            
            
        case 2:
            
            [UIView animateWithDuration:3.0 delay:1.0 options:UIViewAnimationOptionTransitionCurlUp animations:^{
                for (UIButton * button in self.cardButtons){
                    button.alpha = 0.5;
                }
                self.scoreLabel.center = self.scoreLabel.superview.center;
                self.scoreLabel.bounds = CGRectMake( self.scoreLabel.center.x, self.scoreLabel.center.y, 165, 165);
                NSMutableAttributedString *title =
                [[NSMutableAttributedString alloc] initWithString: [NSString stringWithFormat:@"YOU LOSE\n%ld points",(long)self.game.score]];
                [title setAttributes:@{
                                       NSFontAttributeName: [UIFont systemFontOfSize:30],
                                       NSStrokeWidthAttributeName : @3,
                                       NSStrokeColorAttributeName : [UIColor redColor] }
                               range:NSMakeRange(0, [title length])];
                self.scoreLabel.attributedText = title;
                
            } completion:^(BOOL finished){
                if (finished){
                    
                    
                    [self resetUI];
                    
                }
            }] ;
            break;
       
            
            
    }
    
}

-(NSString *)titleForCard:(Card *)card{
    return [card isChosen]? card.contents: @"" ;
}

-(UIImage *) backgroundImageForCard:(Card *)card {
    return  [UIImage imageNamed:[card isChosen]? @"cardfront":@"cardback_linux" ]  ; // pretty cool, uh ?
}

- (IBAction)touchCardButton:(UIButton *)sender {
    
    NSUInteger cardIndex = [self.cardButtons indexOfObject:sender];
    
    [self updateUIwithResultofChoice:[self.game chooseCardAtIndex:cardIndex]];
    
    
    
}





@end
