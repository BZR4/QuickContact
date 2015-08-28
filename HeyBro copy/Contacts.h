//
//  Contacts.h
//  Tinder
//
//  Created by Marco on 8/28/15.
//  Copyright (c) 2015 Marco. All rights reserved.
//

#ifndef Tinder_Contacts_h
#define Tinder_Contacts_h

//
//  ViewController.h
//  QuickTutorial
//
//  Created by Jessica Oliveira on 21/08/15.
//  Copyright (c) 2015 Jessica Oliveira. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <AddressBookUI/AddressBookUI.h>

@interface ViewController : UIViewController <ABPeoplePickerNavigationControllerDelegate, ABNewPersonViewControllerDelegate,ABUnknownPersonViewControllerDelegate, ABPersonViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *firstName;
@property (weak, nonatomic) IBOutlet UILabel *phoneNumber;
@property (weak, nonatomic) IBOutlet UILabel *lastName;
@property (weak, nonatomic) IBOutlet UILabel *email;
@property (weak, nonatomic) IBOutlet UILabel *face;
@property (weak, nonatomic) IBOutlet UILabel *add;

- (IBAction)showPicker:(id)sender;
- (IBAction)create:(id)sender;

@end









#endif
