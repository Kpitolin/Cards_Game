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
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentControlModeChooser;
@property (weak, nonatomic) IBOutlet UILabel *resultOfChoiceLabel;
@property (weak , nonatomic) UIImage *cardback;
@property (weak , nonatomic) UIImage *cardfront;

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




-(UIImage *)cardback {
    
    if(!_cardback){
        _cardback =  [UIImage imageNamed:@"cardback_linux"];
        
    }
    return _cardback;
}

-(UIImage *)cardfront {
    if(!_cardfront){
        _cardfront =  [UIImage imageNamed:@"cardfront"];
        
    }
    return _cardfront;
}

static const int DEFAULTXSCORE = 92;
static const int DEFAULTYSCORE = 450;

-(void) resetUI{
    
    // Reset the score position, color and size
    CGPoint  point = CGPointMake(DEFAULTXSCORE, DEFAULTYSCORE);
    self.scoreLabel.bounds = CGRectMake( self.scoreLabel.center.x, self.scoreLabel.center.y, 165, 21);
    self.scoreLabel.center = point ;
    self.scoreLabel.text = [NSString stringWithFormat:@"Score : 0"];
    
    
    // Reset the cards
    for (UIButton * cardButton in self.cardButtons) {
        cardButton.enabled = YES;
        [cardButton setTitle: @"" forState:UIControlStateNormal];
        [cardButton setBackgroundImage: self.cardback forState:UIControlStateNormal];
        cardButton.alpha = 1.0;
    }
    // delete the game
    self.game = nil;
    self.resultOfChoiceLabel.text = [NSString stringWithFormat:@""];
    self.scoreLabel.text = [NSString stringWithFormat:@"Score : 0"];
    [self.segmentControlModeChooser setSelectedSegmentIndex:0];
    
    
}

- (IBAction)swipeGesture:(UISwipeGestureRecognizer *)sender {
    
    [self resetUI];
    
}

- (IBAction)onChangeState:(UISegmentedControl *)sender {
    // you can set the match-mode, if a game started, it get erased
    // NSAlert here
    
        if ([sender isEnabledForSegmentAtIndex:1]) {
            // if on it's a 3-card game
            
            self.game = [self createNewGameWithMaxMatching:3];
            
            
        }else{
            // if off it's a 2-card game
            
            self.game = [self createNewGameWithMaxMatching:DEFAULT];
            
            
        }
    
    
    
}



static const int DEFAULTXRESULT = 160;
static const int DEFAULTYRESULT = 389;

-(void) updateUIwithResultofChoice:(NSString*)result{
    
        for (UIButton * cardButton in self.cardButtons) {
            NSUInteger index  = [self.cardButtons indexOfObject:cardButton];
            Card * card = [self.game cardAtIndex:index];
            [cardButton setTitle: [self titleForCard:card] forState:UIControlStateNormal];
            [cardButton setBackgroundImage:[self backgroundImageForCard:card] forState:UIControlStateNormal];
            cardButton.enabled = ! card.isMatched;
            
        }
        
        // Animation for result
        [UIView animateWithDuration:0.75 delay:0 options:UIViewAnimationOptionTransitionFlipFromBottom animations:^{
            
            NSMutableAttributedString *title =
            [[NSMutableAttributedString alloc] initWithString: result];
            [title setAttributes:@{
                                   NSFontAttributeName: [UIFont systemFontOfSize:15]
                                   
                                   }
                           range:NSMakeRange(0, [title length])];
            
            self.resultOfChoiceLabel.attributedText = title;
            self.resultOfChoiceLabel.center = self.resultOfChoiceLabel.superview.center;
            
            
        } completion:^(BOOL finished){
            
            // When the animation put the label back and verify end of game
            
            self.resultOfChoiceLabel.center =  CGPointMake(DEFAULTXRESULT, DEFAULTYRESULT);
            [self endOfGameAnimation];
            
        }];
        
        
        
        self.scoreLabel.text = [NSString stringWithFormat:@"Score : %ld",(long)self.game.score];
    
  
}

-(void)endOfGameAnimation{
    switch ([self.game endOfGame]) {
        case 1:
        {
            
            for (UIButton * button in self.cardButtons){
                button.enabled = NO;
                
            }
            // Animation for win
            [UIView animateWithDuration:3.0 delay:1.0 options:UIViewAnimationOptionTransitionCurlUp animations:^{
                for (UIButton * button in self.cardButtons){
                    button.alpha = 0.25;
                    button.enabled = NO;
                    
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
                // When the animation finished do something
                
                
            }] ;
        }
            break;
            
            
        case 2:
            // Animation for loose
            
            for (UIButton * button in self.cardButtons){
                button.enabled = NO;
                
            }
            [UIView animateWithDuration:1.0 delay:1.0 options:UIViewAnimationOptionTransitionCurlUp animations:^{
                for (UIButton * button in self.cardButtons){
                    button.alpha = 0.25;
                    button.enabled = NO;
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
                // When the animation finished do something
                
            }] ;
            break;
            
            
            
    }
}

-(NSString *)titleForCard:(Card *)card{
    return [card isChosen]? card.contents: @"" ;
}

-(UIImage *) backgroundImageForCard:(Card *)card {
    return  [card isChosen]? self.cardfront: self.cardback   ; // pretty cool, uh ?
}


- (IBAction)touchCardButton:(UIButton *)sender {
    
    
    
    
    NSUInteger cardIndex = [self.cardButtons indexOfObject:sender];

    [self updateUIwithResultofChoice:[self.game chooseCardAtIndex:cardIndex]];
    

    
}





@end
