//
//  CardGameCell.h
//  Cards Game
//
//  Created by KEVIN on 27/07/2014.
//  Copyright (c) 2014 KEVIN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CardGameCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIButton *button;
-(void)turningAnimation;

@end
