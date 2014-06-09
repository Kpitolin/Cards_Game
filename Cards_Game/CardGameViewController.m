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
#import "ScoreTableViewController.h"

@interface CardGameViewController ()
@property (strong, nonatomic) Deck * cardDeck;
@property (nonatomic, strong) CardMatchingGame* game;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentControlModeChooser;
@property (weak, nonatomic) IBOutlet UILabel *resultOfChoiceLabel;
@property (weak , nonatomic) UIImage *cardfront;
@property (weak , nonatomic) UIImage *cardback;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *distanceToBottomScoreLabelConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *distanceToLeftScoreLabelConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightScoreLabelConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widthScoreLabelConstraint;

@end

@implementation CardGameViewController


-(void) viewDidLoad
{
    [self resetUI];
}

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
        _cardback =  [UIImage imageNamed:[NSString stringWithFormat:@"cardback_%@",self.cardback_name]];
        
    }
    return _cardback;
}

-(UIImage *)cardfront {
    if(!_cardfront){
        _cardfront =  [UIImage imageNamed:@"cardfront"];
        
    }
    return _cardfront;
}


// Deprecated
static const int DEFAULTXSCORE = 92;
static const int DEFAULTYSCORE = 450;

-(void) resetUI{
    
    // Reset the score position, color and size
    CGPoint  point = CGPointMake(DEFAULTXSCORE, DEFAULTYSCORE);
    self.scoreLabel.text = [NSString stringWithFormat:@"Score : 0"];
    [self updateConstraintsOfUIElement:self.scoreLabel withNewCenter:point withTextAttributes:nil];
    
    
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

 // The swipe gesture start a new game from scratch
- (IBAction)swipeGesture:(UISwipeGestureRecognizer *)sender {
    
    [self resetUI];
    
}

- (IBAction)onChangeState:(UISegmentedControl *)sender {
    // you can set the match-mode, if a game started, it get erased

    
        if ([sender isEnabledForSegmentAtIndex:1]) {
            // if on it's a 3-card game
            
            self.game = [self createNewGameWithMaxMatching:3];
            
            
        }else if ([sender isEnabledForSegmentAtIndex:0]){
            // if off it's a 2-card game
            
            self.game = [self createNewGameWithMaxMatching:DEFAULT];
            
            
        }
    
    
    
}


// Deprecated
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
        [UIView animateWithDuration:0.75 delay:0.5 options:UIViewAnimationOptionTransitionFlipFromBottom animations:^{
            
            NSMutableAttributedString *title =
            [[NSMutableAttributedString alloc] initWithString: result];
            [title setAttributes:@{
                                   NSFontAttributeName: [UIFont systemFontOfSize:15]
                                   
                                   }
                           range:NSMakeRange(0, [title length])];
            
            self.resultOfChoiceLabel.attributedText = title;
            //self.resultOfChoiceLabel.center = self.resultOfChoiceLabel.superview.center;
            
            
        } completion:^(BOOL finished){
            
            // When the animation put the label back and verify end of game
            
            self.resultOfChoiceLabel.center =  CGPointMake(DEFAULTXRESULT, DEFAULTYRESULT);
            
            [self endOfGameAnimation];
            
        }];
        
    
        self.scoreLabel.text = [NSString stringWithFormat:@"Score : %ld",(long)self.game.score];
    
  
}

#define IDLABEL @"scoreLabel"

-(NSDictionary *) attributesForEndOfGame{
    return   @{ NSFontAttributeName: [UIFont systemFontOfSize:30],
                                    NSStrokeWidthAttributeName : @3,
                                    NSStrokeColorAttributeName : [UIColor whiteColor]};
}


-(void)updateConstraintsOfUIElement: (UIView*)view withNewCenter:(CGPoint )center withTextAttributes: (NSDictionary *) attributes
{
    
    
    if ([view isKindOfClass:[UILabel class]] ){
        
        //For the score Label
        
        UILabel * label = (UILabel *)view ;
        self.distanceToBottomScoreLabelConstraint.constant  = center.y - (label.bounds.size.height/2);
        self.distanceToLeftScoreLabelConstraint.constant = center.x - (label.bounds.size.height/2);
        
        // I look for the appropriated size for this label
        label.bounds = [self determinePerfectFrameForView:label withTextAttributes:attributes];
        [label setNeedsDisplay];

        
    }
}

// this is cool !! Need to store it in a completion block (or just don't forget it)

-(CGRect) determinePerfectFrameForView:(UIView *)view withTextAttributes:(NSDictionary *)attributes{
    CGSize perfetSize;
    CGRect perfectFrame;
    if ([view isKindOfClass:[UILabel class]]){
        UILabel * label = (UILabel *)view ;
        perfetSize = [label.text sizeWithAttributes:attributes];
        perfectFrame = CGRectMake(label.center.x, label.center.y, perfetSize.width, perfetSize.height);
    }
    return perfectFrame;
}

-(void)endOfGameConfigurationWinning:(BOOL)win
{
    [self saveScore];
    
    
    for (UIButton * button in self.cardButtons){
        button.enabled = NO;
        
    }
    // Animation for winning/losing
    NSString * endWord ;
    win ? (endWord = @"WIN"): (endWord = @"LOSE") ;
    [UIView animateWithDuration:1.0 delay:1.0 options:UIViewAnimationOptionTransitionCurlUp animations:^{
        
        
        for (UIButton * button in self.cardButtons){
            button.alpha = 0.25;
            NSUInteger index  = [self.cardButtons indexOfObject:button]; // We want to see the last cards
            Card * card = [self.game cardAtIndex:index];
            card.chosen = YES;
            [button setTitle: [self titleForCard:card] forState:UIControlStateNormal];
            [button setBackgroundImage:[self backgroundImageForCard:card] forState:UIControlStateNormal];
            button.enabled = NO;
            
        }

        [self updateConstraintsOfUIElement:self.scoreLabel
                             withNewCenter:self.view.center
                        withTextAttributes:[self attributesForEndOfGame]];
        NSMutableAttributedString *title =
        [[NSMutableAttributedString alloc] initWithString: [NSString stringWithFormat:@"YOU %@\n%i points",endWord,self.game.score]];
        [title setAttributes:[self attributesForEndOfGame]
                       range:NSMakeRange(0, [title length])];
        self.scoreLabel.attributedText = title;
       
        
        
    } completion:^(BOOL finished){
        // When the animation finished do something
       
        
    }] ;
}




-(void)endOfGameAnimation{

    switch ([self.game endOfGame]) {
        case 1:
        
           
            // Animation for win
            [self endOfGameConfigurationWinning:YES];
            break;
            
            
        case 2:
            
            
            // Animation for loose
            [self endOfGameConfigurationWinning:NO];

            
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
#define MAXOFRECENTGAMES 20

#define SCORES @"Scores"
#define HIGHSCORE @"HIGHSCORE"

//For saving the photos in the NSUserDefaults
- (void)saveScore{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    
    NSMutableArray *games = [[defaults objectForKey:SCORES] mutableCopy];
    
    //if it's the first game the dictionnary doesn't exist yet
    if (!games) games = [[NSMutableArray alloc] init];
    if(![games containsObject:[NSNumber numberWithInt:self.game.score]])
    {
        [games addObject: [NSNumber numberWithInt:self.game.score]];
    }
    while ([games count] > MAXOFRECENTGAMES){
        [games removeLastObject];
    }
    
    
    [defaults setObject:games forKey:SCORES];
    [defaults synchronize];
}

-(void)findHighScore{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSNumber *hs = [[NSNumber alloc]init];
    hs =[defaults objectForKey:HIGHSCORE] ;

    NSNumber * highscore =  [[NSNumber alloc]init];
                             highscore = hs;
    
    NSArray* scoreArray = [[[NSUserDefaults standardUserDefaults] objectForKey:SCORES] sortedArrayUsingSelector:@selector(intValue)];
   ( highscore > [scoreArray lastObject]) ? ( highscore = [scoreArray lastObject]): (highscore =[defaults objectForKey:HIGHSCORE]) ;
    
    
    //if it's the first game the dictionnary doesn't exist yet
    [defaults setObject:highscore forKey:HIGHSCORE];
    [defaults synchronize];
    
}

//In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Display_score" ]  ) {
        if ([segue.destinationViewController isKindOfClass:[ScoreTableViewController class]]){
            ((ScoreTableViewController *)segue.destinationViewController).gameTable = [[NSUserDefaults standardUserDefaults] objectForKey:SCORES];
            [self findHighScore];
            ((ScoreTableViewController *)segue.destinationViewController).highscore =[[NSUserDefaults standardUserDefaults] objectForKey:@"HIGHSCORE"];

        }
    }
    
    
    
        
}
    
    





@end
