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


-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row   forComponent:(NSInteger)component

{
    
    return [self.cardBacksArray objectAtIndex:row];
    
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
