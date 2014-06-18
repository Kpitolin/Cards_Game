//
//  BeginViewController.m
//  Cards_Game
//
//  Created by KEVIN on 03/06/2014.
//  Copyright (c) 2014 KEVIN. All rights reserved.
//
#import "BeginViewController.h"
#import "CardGameViewController.h"
@interface BeginViewController ()<UIPickerViewDataSource,UIPickerViewDelegate>
@property (weak, nonatomic) IBOutlet UIPickerView *pickerOfColor;
@property (strong, nonatomic) NSArray *cardBacksArray;
@property (nonatomic) NSInteger selectedRow;

@end

@implementation BeginViewController


-(void) viewDidLoad
{
 
 self.cardBacksArray  = [[NSArray alloc]initWithObjects:@"linux",@"red", nil];
}

#pragma mark - Handle PickerView

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [self.cardBacksArray count];
}

#define WIDTH_CARD_IPHONE 60
#define WIDTH_CARD_IPAD 117
#define HEIGHT_CARD_IPHONE 88
#define HEIGHT_CARD_IPAD 169
#define WIDTH_IPHONE 320

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UIImageView * imageView = (UIImageView *)view;
    UIImage * image = [UIImage imageNamed:[self.cardBacksArray objectAtIndex:row] ];
    if(self.view.bounds.size.width > WIDTH_IPHONE)
    {
        imageView = [[UIImageView alloc ]initWithFrame:CGRectMake(imageView.center.x, imageView.center.y, WIDTH_CARD_IPAD, HEIGHT_CARD_IPAD)];
  
    }else
    {
        imageView = [[UIImageView alloc ]initWithFrame:CGRectMake(imageView.center.x, imageView.center.y, WIDTH_CARD_IPHONE, HEIGHT_CARD_IPHONE)];

    }
    imageView.image = image;
    return imageView;

}


- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
   return  self.view.bounds.size.width > WIDTH_IPHONE? WIDTH_CARD_IPAD : WIDTH_CARD_IPHONE;
}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
   return  self.view.bounds.size.width > WIDTH_IPHONE? HEIGHT_CARD_IPAD : HEIGHT_CARD_IPHONE;

}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row   inComponent:(NSInteger)component

{
    
    
    self.selectedRow = row;
   
    
    
}

#pragma mark - Navigation

 -(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 if ([segue.destinationViewController isKindOfClass:[CardGameViewController class]]) {
 CardGameViewController *cvc = (CardGameViewController *)segue.destinationViewController;
 
 cvc.cardback_name = self.cardBacksArray [self.selectedRow];
 
 
 
 }
 
 }

@end
