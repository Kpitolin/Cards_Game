//
//  ViewController.h
//  Cards_Game
//
//  Created by KEVIN on 04/04/2014.
//  Copyright (c) 2014 KEVIN. All rights reserved.
//
#import "PlayingCardDeck.h"
#import  "CardMatchingGame.h"
#import "ScoreTableViewController.h"
#import <UIKit/UIKit.h>

@interface CardGameViewController : UIViewController
@property (weak , nonatomic) NSString *cardback_name;
@property (weak , nonatomic) UIImage *cardfront;
@property (weak , nonatomic) UIImage *cardback;
@end
