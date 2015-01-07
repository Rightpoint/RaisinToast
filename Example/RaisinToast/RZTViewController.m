//
//  RZViewController.m
//  RaisinToast
//
//  Created by adamhrz on 12/22/2014.
//  Copyright (c) 2014 adamhrz. All rights reserved.
//

#import "RZTViewController.h"
#import "RZTAppDelegate.h"


@interface RZTViewController () <UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UISegmentedControl *messageStrengthSegmentedControl;

@end

@implementation RZTViewController

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    RZTAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    RZTWindowType windowType = (RZTWindowType)indexPath.section;
    RZErrorMessengerLevel level = (RZErrorMessengerLevel)indexPath.row;
    RZMessageStrength messageStrength;
    if ( [self.messageStrengthSegmentedControl selectedSegmentIndex] == 0 ) {
        messageStrength = kRZMessageStrengthWeakAutoDismiss;
    }
    else {
        messageStrength = kRZMessageStrengthStrongAutoDismiss;
    }

    [appDelegate reconfigureMessagingWindowForDemoPurposes:windowType];

    NSArray *messages = @[
      @{@"quote":@"Why, sometimes I've believed as many as six impossible things before breakfast.", @"author":@" Lewis Carroll"},
      @{@"quote":@"'When you wake up in the morning, Pooh,' said Piglet at last, 'what's the first thing you say to yourself?'\n'What's for breakfast?' said Pooh. 'What do you say, Piglet?'\n'I say, I wonder what's going to happen exciting today?' said Piglet.\nPooh nodded thoughtfully. 'It's the same thing,' he said.",@"author":@"A.A. Milne"},
      
      @{@"quote":@"Love is a bicycle with two pancakes for wheels. You may see love as more of an exercise in hard work, but I see it as more of a breakfast on the go.",@"author":@"Jarod Kintz"},
      
      @{@"quote":@"'And now leave me in peace for a bit! I don't want to answer a string of questions while I am eating. I want to think!'\n\n'Good Heavens!' said Pippin. 'At breakfast?'",@"author":@"J.R.R. Tolkien"},
      
      @{@"quote":@"We've been rehearsing a classic from antiquity, Green Eggs and Hamlet, the story of a young prince of Denmark who goes mad, drowns his girlfriend, and in his remorse, forces spoiled breakfast on all whom he meets.",@"author":@"Christopher Moore"}
      ];
    NSInteger messageIndex = arc4random_uniform((u_int32_t)messages.count);
    NSDictionary *selectedMessage = messages[messageIndex];
    
    NSError *myError = [RZErrorMessenger errorWithDisplayTitle:selectedMessage[@"author"] detail:selectedMessage[@"quote"] error:nil];
    [RZErrorMessenger displayError:myError withStrength:messageStrength level:level animated:YES];
    
}

@end
