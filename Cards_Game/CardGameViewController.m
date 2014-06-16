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

#define WIN_STATE @"WIN"
#define NORMAL_STATE @"NORMAL"
#define CONSTRAINT_FOR_NORMAL_STATE_LEFT_IPHONE 38
#define CONSTRAINT_FOR_NORMAL_STATE_BOTTOM_IPHONE 19
#define CONSTRAINT_FOR_NORMAL_STATE_LEFT_IPAD 47
#define CONSTRAINT_FOR_NORMAL_STATE_BOTTOM_IPAD 67
-(void) viewDidLoad
{
    [self resetUI];
}

-(Deck *)cardDeckCreate{
    
    _cardDeck =  [[PlayingCardDeck alloc]init];
    
    return _cardDeck;
    
}

//  mode de jeu par défaut

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
static const int DEFAULTXSCORE = 94;
static const int DEFAULTYSCORE = 452;

-(void) resetUI{
    
    // Reset the score position, color and size and text
    CGPoint  point = CGPointMake(DEFAULTXSCORE, DEFAULTYSCORE);
    NSMutableAttributedString *attributedText =
    [[NSMutableAttributedString alloc] initWithString: @"Score : 0"];
    self.scoreLabel.attributedText = attributedText;
    
    [self updateConstraintsOfUIElement:self.scoreLabel forState:NORMAL_STATE withNewCenter:point];
    [self.scoreLabel setNeedsDisplay];
    
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



-(void) updateUIwithResultofChoice:(NSString*)result{
    
    for (UIButton * cardButton in self.cardButtons) { // when you come back from the verification the four cards become chosen
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
        
        //self.resultOfChoiceLabel.center =  CGPointMake(DEFAULTXRESULT, DEFAULTYRESULT);
        
        [self endOfGameAnimation];
        
    }];
    
    
    self.scoreLabel.text = [NSString stringWithFormat:@"Score : %ld",(long)self.game.score];
    
    
}

#define IDLABEL @"scoreLabel"
#define NORMAL_HEIGHT 19
#define NORMAL_WIDTH 112
#define WIDTH_IPHONE 320
-(NSDictionary *) attributesForEndOfGame{
    return self.view.bounds.size.width > WIDTH_IPHONE ? @{ NSFontAttributeName: [UIFont systemFontOfSize:45],
                                                           NSStrokeWidthAttributeName : @3,
                                                           NSStrokeColorAttributeName : [UIColor blackColor]}
                                                            :
                                                            @{ NSFontAttributeName: [UIFont systemFontOfSize:30],
                                                                NSStrokeWidthAttributeName : @3,
                                                            NSStrokeColorAttributeName : [UIColor blackColor]};
}



-(void)updateConstraintsOfUIElement: (UIView*)view forState:(NSString *)state withNewCenter:(CGPoint )center
{
    
    
    if ([view isKindOfClass:[UILabel class]] ){
        //For the score Label
        
        UILabel * label = (UILabel *)view ;
        if ([state isEqualToString:WIN_STATE])
        {
            self.heightScoreLabelConstraint.constant = [self determinePerfectFrameForView:self.scoreLabel withTextAttributes:[self attributesForEndOfGame]].size.height + 40;
            self.widthScoreLabelConstraint.constant = ([self determinePerfectFrameForView:self.scoreLabel withTextAttributes:[self attributesForEndOfGame]].size.width)+10  ;
            self.distanceToBottomScoreLabelConstraint.constant  = (self.view.bounds.size.height+40) - ( center.y + ((label.bounds.size.height+40)/2)); // the label bounds changes, we can't rely on it
            self.distanceToLeftScoreLabelConstraint.constant =  center.x - ((label.bounds.size.width+10)/2); // here neither
            
          
            
            
        } else if ([state isEqualToString:NORMAL_STATE]){
            if(self.view.bounds.size.width > WIDTH_IPHONE){
                self.distanceToBottomScoreLabelConstraint.constant  = CONSTRAINT_FOR_NORMAL_STATE_BOTTOM_IPAD;
                self.distanceToLeftScoreLabelConstraint.constant = CONSTRAINT_FOR_NORMAL_STATE_LEFT_IPAD;
            }else{
                self.distanceToBottomScoreLabelConstraint.constant  = CONSTRAINT_FOR_NORMAL_STATE_BOTTOM_IPHONE;
                self.distanceToLeftScoreLabelConstraint.constant = CONSTRAINT_FOR_NORMAL_STATE_LEFT_IPHONE;
            }
        
         
            self.heightScoreLabelConstraint.constant = NORMAL_HEIGHT;
            self.widthScoreLabelConstraint.constant = NORMAL_WIDTH;
            
        }
        
        
        // I look for the appropriated size for this label
        //label.bounds = [self determinePerfectFrameForView:label withTextAttributes:attributes]; iOs do that automatically
        
        
    }
}

// this is cool !! Need to store it in a completion block (or just don't forget it)

-(CGRect) determinePerfectFrameForView:(UIView *)view withTextAttributes:(NSDictionary *)attributes{
    CGSize perfetSize;
    CGRect perfectFrame;
    if ([view isKindOfClass:[UILabel class]]){
        UILabel * label = (UILabel *)view ;
        perfetSize = [label.text sizeWithAttributes:attributes];
        perfectFrame = CGRectMake(label.bounds.origin.x, label.bounds.origin.y, perfetSize.width, perfetSize.height);
    }
    return perfectFrame;
}

#define END_SENTENCE_WIN NSLocalizedStringFromTable(@"SENTENCE_WIN", @"CardGameViewController",@"Message given to user at the end of the game if he loses" )
#define END_SENTENCE_LOSE NSLocalizedStringFromTable(@"SENTENCE_LOSE",  @"CardGameViewController", @"Message given to user at the end of the game if he wins" )

-(void)endOfGameConfigurationWinning:(BOOL)win
{
    [self saveScore];
    [self findHighScore];
    
    for (UIButton * button in self.cardButtons){
        button.enabled = NO;
        
    }
    // Animation for winning/losing
    NSString * endWord ;
    win ? (endWord = END_SENTENCE_WIN): (endWord = END_SENTENCE_LOSE) ;
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionTransitionCurlUp animations:^{
        
        
        for (UIButton * button in self.cardButtons){
            button.alpha = 0.25;
            NSUInteger index  = [self.cardButtons indexOfObject:button]; // We want to see the last cards
            Card * card = [self.game cardAtIndex:index];
            card.chosen = YES;
            [button setTitle: [self titleForCard:card] forState:UIControlStateNormal];
            [button setBackgroundImage:[self backgroundImageForCard:card] forState:UIControlStateNormal];
            button.enabled = NO;
            
        }
        
        
    } completion:^(BOOL finished){
        // When the animation finished do something
        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionTransitionCurlUp animations:^{
            
            [self.view layoutIfNeeded];
            
            NSMutableAttributedString *title =
            [[NSMutableAttributedString alloc] initWithString: [NSString stringWithFormat:@"%@\n%i points",endWord,self.game.score]];
            [title setAttributes:[self attributesForEndOfGame]
                           range:NSMakeRange(0, [title length])];
            self.scoreLabel.attributedText = title;
            [self updateConstraintsOfUIElement:self.scoreLabel
                                      forState:WIN_STATE
                                 withNewCenter:self.view.center];
            [self.view layoutIfNeeded];

            
           
            
            
            
        }completion:nil];
        
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
   
    //NSArray* scoreArray = [games sortedArrayUsingSelector:@selector(intValue)]; // we order the array
    
    


    [defaults setObject:games forKey:SCORES];
    [defaults synchronize];
    

}

-(void)findHighScore{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSNumber *hs = [[NSNumber alloc]init];
    hs =[defaults objectForKey:HIGHSCORE] ;
    
    
    
    
    NSSortDescriptor *LowestToHighest = [NSSortDescriptor sortDescriptorWithKey:@"self" ascending:YES];
    NSMutableArray* scoreArray  = [[[NSUserDefaults standardUserDefaults] objectForKey:SCORES] mutableCopy];
    [scoreArray sortUsingDescriptors:@[LowestToHighest]];
   
    if( hs < [scoreArray lastObject]) { //the last object is the greatest
       hs = [scoreArray lastObject] ;  // we update the highscore value
    }
  
    
    
    //if it's the first game the dictionnary doesn't exist yet
    [defaults setObject:hs forKey:HIGHSCORE];
    [defaults synchronize];
    

    
}

//In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Display_score" ]  ) {
        if ([segue.destinationViewController isKindOfClass:[ScoreTableViewController class]]){
            
            dispatch_queue_t load = dispatch_queue_create("score load", NULL);
            dispatch_async(load, ^{
            ((ScoreTableViewController *)segue.destinationViewController).gameTable = [[NSUserDefaults standardUserDefaults] objectForKey:SCORES];
            
            ((ScoreTableViewController *)segue.destinationViewController).highscore =[[NSUserDefaults standardUserDefaults] objectForKey:HIGHSCORE];// for the high score I should try a delegate and a notification
            });
            
        }
    }
    
    
    
    
}







@end
