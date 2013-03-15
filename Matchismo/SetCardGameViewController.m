//
//  SetCardGameViewController.m
//  Matchismo
//
//  Created by bgbb on 3/5/13.
//  Copyright (c) 2013 Qpoo Lab. All rights reserved.
//

#import "SetCardGameViewController.h"
#import "SetCardMatchingGame.h"
#import "PlayingSetCard.h"
#import "PlayingSetCardDeck.h"

@interface SetCardGameViewController ()

@property (weak, nonatomic) IBOutlet UILabel *flips;
@property (nonatomic) int flippedCount;
@property (strong, nonatomic) CardMatchingGame *game;
@end

@implementation SetCardGameViewController

- (CardMatchingGame *)game
{
    if (!_game)
        _game = [[CardMatchingGame alloc]
                 initWithCardCount:self.setCardButtons.count
                 usingDeck:[[PlayingSetCardDeck alloc] init]];
    return _game;
}

- (void) setSetCardButtons:(NSArray *)cardButtons
{
    _setCardButtons = cardButtons;
    [self updateUI];
}

- (IBAction)flipCard:(UIButton *)sender {
    
    [self.game flipCardAtIndex:[self.setCardButtons indexOfObject:sender]];
    
    self.flippedCount++;
    [self updateUI];
}


- (void)updateUI
{
    NSLog(@"updateUI");
    for (UIButton *cardButton in self.setCardButtons){
        PlayingSetCard *card = (PlayingSetCard *)[self.game cardAtIndex:[self.setCardButtons indexOfObject:cardButton]];
        NSLog(@"card contains %@", card.contents);
        NSMutableString *content = [[NSMutableString alloc] init];
        //create string content
        for (int i = 0; i < card.rank; i++){
            [content appendString: card.suit];
        }
        //dictionary object for attribute
        NSMutableDictionary *cardAttr = [[NSMutableDictionary alloc] init];
        
        //color
        UIColor *targetColor = [[UIColor alloc] init];
        if ([card.color isEqualToString: @"red"]) {
            targetColor = [UIColor redColor];
        }else if ([card.color isEqualToString: @"green"]) {
            targetColor = [UIColor greenColor];
        }else if ([card.color isEqualToString: @"blue"]){
            targetColor = [UIColor blueColor];
        }
        [cardAttr setObject:targetColor forKey:NSForegroundColorAttributeName];
        
        //shade
        if ([card.shading isEqualToString: @"solid"]){
            //do nothihg
        }else if ([card.shading isEqualToString: @"clear"]){
            [cardAttr setObject:[NSNumber numberWithFloat:3.0] forKey:NSStrokeWidthAttributeName];
        }else if ([card.shading isEqualToString: @"striped"]){
            [cardAttr setObject:@-5 forKey:
             NSStrokeWidthAttributeName];
            [cardAttr setObject:targetColor forKey:
             NSStrokeColorAttributeName];
            [cardAttr setObject:[targetColor colorWithAlphaComponent:0.1] forKey:
                NSForegroundColorAttributeName];
        }
        NSMutableAttributedString *cardContent =
        [[NSMutableAttributedString alloc] initWithString:content attributes:cardAttr];
        
        [cardButton setAttributedTitle:cardContent forState:UIControlStateNormal];
        cardButton.selected = card.isFaceUp;
        cardButton.enabled = !card.isUnplayable;
        cardButton.alpha = card.isUnplayable ? 0.3 : 1.0;

        
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}
- (IBAction)dealButton{
    [super dealButton];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end