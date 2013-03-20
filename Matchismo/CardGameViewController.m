//
//  CardGameViewController.m
//  Matchismo
//
//  Created by bgbb on 2/11/13.
//  Copyright (c) 2013 Qpoo Lab. All rights reserved.
//

#import "CardGameViewController.h"
#import "PlayingCardDeck.h"
#import "CardMatchingGame.h"

@interface CardGameViewController ()
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (weak, nonatomic) IBOutlet UILabel *flipLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *gameStatusLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *modeSegm;

@property (nonatomic) int flipCount;
@property (strong, nonatomic) CardMatchingGame *game;

@end

@implementation CardGameViewController


- (CardMatchingGame *)game
{
    if (!_game)
        _game = [[CardMatchingGame alloc]
                 initWithCardCount:self.cardButtons.count
                 usingDeck:[[PlayingCardDeck alloc] init]];
    return _game;
}


- (void) setCardButtons:(NSArray *)cardButtons
{
    _cardButtons = cardButtons;
    [self updateUI];
}

- (void)updateUI
{
    for (UIButton *cardButton in self.cardButtons) {
        Card *card = [self.game cardAtIndex:[self.cardButtons indexOfObject:cardButton]];
        [cardButton setTitle:card.contents forState:UIControlStateSelected];
        [cardButton setTitle:card.contents forState:UIControlStateSelected|UIControlStateDisabled];
        cardButton.selected = card.isFaceUp;
        cardButton.enabled = !card.isUnplayable;
        cardButton.alpha = card.isUnplayable ? 0.3 : 1.0;
    }
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
    self.modeSegm.enabled = !self.game.isGameOn;
}


- (void) setFlipCount:(int)flipCount{
    _flipCount = flipCount;
    NSLog(@"flips updated to %d", self.flipCount);
    self.flipLabel.text = [NSString stringWithFormat:@"Flip: %d", self.flipCount];

}

- (void) setGameStatusLabelText{
    self.gameStatusLabel.text = [NSString stringWithFormat:@"%@", self.game.gameStatus];
}

- (void) setScoreLabelText{
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
}


- (IBAction)flipCard:(UIButton *)sender {
    
    [self.game flipCardAtIndex:[self.cardButtons indexOfObject:sender]];
    
    self.flipCount++;
    [self setGameStatusLabelText];
    [self setScoreLabelText];
    [self updateUI];
}

- (IBAction)dealButton {
    
    self.game = nil;
    self.flipCount = 0;
    
    [self updateUI];
}


- (IBAction)selectModeSegm {
    
    if (self.modeSegm.selectedSegmentIndex == 0){
        self.game.mode = 2;
        NSLog(@" 2 card mode");
    }else if (self.modeSegm.selectedSegmentIndex == 1){
        self.game.mode = 3;
        NSLog(@" 3 card mode");
    }
}





@end
